# Linux Script and Permissions Lab

## What I Did
This lab covered writing a basic bash script and managing file 
permissions in Linux. The script prompts the user to enter their 
first and last name, then prints a greeting message.

## Background
This was one of the more straightforward labs for me — I had already 
been introduced to Linux file permissions through the Google 
Cybersecurity Professional Certificate, so the `chmod` commands 
felt familiar going in.

## The Script
The script `greetnew.sh` asks for a first and last name using `read` 
to capture the input, then prints "Hello firstname lastname." to 
the screen.

## Permissions
The file started with `-rw-r--r--` permissions meaning only the owner 
could write to it and no one could execute it. Used `chmod` to add 
execute permissions for the owner and others, ending up with 
`-rwxr--r-x` before running the script successfully.

First attempt at `chmod` failed because there was no space between 
`o+x` and the filename — a small but important syntax detail.

## Screenshots

### The Script
![Linux Script Lab](1%20Linux%20Script%20Lab.png)

### Permissions and Running the Script
![Script Permissions Lab](2%20Script%20Permissions%20Lab.png)
