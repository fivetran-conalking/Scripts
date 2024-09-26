# Runmock Download Script

## Description
- This script will extract the Region and Job ID from the most recent .json file in the folder, pass them to the salame shell download command, and then run it
- The runmock output files will be downloaded to the path defined in line 44 of the script

## How do I use this?
- Download the script to the same folder where you save runmock .json files (I use /Users/conal.king/runmock)
- Change the download parameter on line 44 to where you want the files to output
- cd to the folder and run the script from terminal with ./runmockdl.sh
