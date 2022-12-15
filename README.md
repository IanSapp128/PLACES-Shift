# PLACES Shift
I needed to create an application that would take in the CDC PLACES (census tract) dataset and pivot the values so that all of the measures were their own columns with
the correct values in each row.

I had a simple Python script that did this, but I wanted to make a compiled binary that you could drag and drop the .CSV file onto it and have it process. I also didn't
want to use any additional libraries so I did it by hand.

This is my **first time using Nim** for anything. It was confusing, but I got it working. I'm sure there's a much better way to do most of this, but it works, it's pretty 
fast, and it compiles to a 517KB executable (on Windows) which would be impossible with PyInstaller. 

I don't really expect anybody to want to use this, but I'm putting it here. I'll probably update it soon with some QOL fixes.  
Tested on Windows so far. Mac isn't playing nice with the dropping of a file onto the executable but you can still run it in the terminal with the CSV file as an argument.
