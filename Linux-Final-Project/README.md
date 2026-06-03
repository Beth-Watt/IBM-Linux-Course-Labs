# Linux Final Project - Automated Backup Script

## Overview
A bash script that automatically backs up files modified in the last 24 hours 
to a specified destination directory. This was the final project for the 
IBM Hands-On Linux course.

## What the Script Does
- Accepts a target directory and destination directory as arguments
- Identifies files modified within the last 24 hours using timestamps
- Compresses and archives those files into a .tar.gz backup file
- Moves the backup file to the destination directory
- Can be scheduled with crontab to run automatically every 24 hours

## Usage backup.sh
#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
targetDirectory=$1
destinationDirectory=$2

# [TASK 2]
echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

# [TASK 3]
currentTS=$(date +%s)

# [TASK 4]
backupFileName="backup-$currentTS.tar.gz"

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# [TASK 5]
origAbsPath=`pwd`

# [TASK 6]
cd "$destinationDirectory" || exit
destAbsPath=$(pwd)

# [TASK 7]
cd "$origAbsPath" || exit
cd "$targetDirectory" || exit

# [TASK 8]
yesterdayTS=$(($currentTS - 24 * 60 * 60))

declare -a toBackup

for file in *  # [TASK 9]
do
  # [TASK 10]
  if [[ $(date -r $file +%s) -gt $yesterdayTS ]]
  then
  # [TASK 11]
  toBackup+=($file)
fi
  
done

# [TASK 12]
tar -czvf $backupFileName ${toBackup[@]}

# [TASK 13]
mv $backupFileName $destAbsPath
# Congratulations! You completed the final project for this course!
```

## Proof of Outcomes

### Backup Permissions
![Backup Permissions](Backup%20Permissions.png)

### Backup File Check
![Backup File Check](Backup%20File%20Check.png)

### Backup Script Copy
![Backup Script Copy](Backup%20Script%20Copy.png)

### Crontab Schedule
![Crontab Schedule](Crontab%20Schedule.png)

### Files in Directory
![Files in Directory](Files%20in%20Directory.png)

## Challenges & Problem Solving
This project came with its share of debugging challenges:
- Encountered syntax errors from mixed use of backticks and $() for command substitution
- Struggled with hidden characters in the script editor causing persistent errors
- After multiple failed attempts to fix the corrupted script, made the decision 
  to reset the lab and start fresh — which turned out to be the right call
- Successfully completed the project on the second attempt with a score of 95%

## Tools Used
- Linux terminal (Theia Lab environment)
- Bash scripting
- Debugged syntax errors and hidden character issues through research and iterative testing
  



## Final Score
19/20 (95%) - Legendary Performance! 🏆
