import os
import std/tables
import std/parsecsv

var inputFile: string
# Check if a CSV file was passed to the application. Quit if not
try:
  var file: string = paramStr(1)
  var ext: string = file[^4 .. ^1]
  inputFile = file
  if ext != ".csv":
    quit(0)

except:
  quit(0)

var measures = newSeq[string]() # This will store the list in the order we want
var dataBank: Table[string, Table[string, string]] # This will be the list we loop through at the end
let countyFips = @["48453", "48491", "48209", "48021", "48055"] # FIPS that we want to keep

var p: CsvParser
# Read input file
p.open(inputFile)
p.readHeaderRow()
while p.readRow():
  # Temp variables
  var locName: string
  var measureName: string
  var dataVal: string
  for col in items(p.headers):
    # If the columns is LocationName, set the temp locName to col value
    if col == "LocationName":
      locName = p.rowEntry(col)
    # If the columns is Measure, set the temp measureName to col value
    elif col == "Measure":
      measureName = p.rowEntry(col)
    # If the columns is Data_Value, set the temp dataVal to col value
    elif col == "Data_Value":
      dataVal = p.rowEntry(col)
      
      # Check if locName is in the Fips list and if not, skip this part (we don't want it)
      if locName[0..4] in countyFips:
      # Check if dataBank has the key for locName
      # If not, we create a temp table and add to the loc val
        if not dataBank.hasKey(locName):
          var placeHolder = initTable[string, string]()
          placeHolder[measureName] = dataVal
          dataBank[locName] = placeHolder
        # If it exists, just set the value to dataVal
        else:
          dataBank[locName][measureName] = dataVal
      
# Start the header string
var header = "GeoID,"

# Generate measure list so that we can get the proper formatting for the CSV output
for key, value in dataBank:
  for keys, values in value:
    if keys notin measures:
      measures.add(keys)
      header = header & "\"" & keys & "\","
  # Break so that it only runs through this once
  break 

# Create the output file
let f = open("PLACES_Output.csv", fmWrite)

# Write headers
f.writeLine(header[0..^2])

# Loop through and populate
for key, value in dataBank:
  var outputString: string
  outputString = "\"" & key & "\","
  for measure in measures:
    # If the value is missing, just put a 0 in its place
    try:
      outputString = outputString & "\"" & dataBank[key][measure] & "\"" & ","
    except:
      outputString = outputString & "\"0\","
  # Write the file
  f.writeLine(outputString[0..^2])