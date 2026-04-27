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

## Usage
```bash
bash backup.sh target_directory destination_directory
```

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
- Claude AI for troubleshooting, debugging, and guidance throughout the project

## Final Score
19/20 (95%) - Legendary Performance! 🏆
