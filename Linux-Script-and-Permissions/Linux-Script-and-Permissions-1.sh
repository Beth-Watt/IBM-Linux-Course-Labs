#! /bin/bash
# This script will print Hello with firstname and lastname
# message greeting the user
 
# Print welcome message
echo -n "enter your firstname :"
 
# Wait for user to enter a firstname, and save the entered name into the
#variable \'name\'
read firstname
 
#Print prompt message on the screen
echo -n "enter your lastname :"
 
# Wait for user to enter a firstname, and save the entered name into the
#variable \'name\'
read lastname
 
# Print the welcome message followed by the name
echo "Hello $firstname $lastname."
