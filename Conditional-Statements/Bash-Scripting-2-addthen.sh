#!/bin/bash
 
echo 'Are you having fun learning Linux?'
echo -n "Enter \"y\" for yes, \"n\" for no."
read response
if [ "$response" = "y" ]
then
        echo "I'm pleased to hear you are enjoying learning linux!"
        echo "What is one you like about it?"
elif [ "$response" = "n" ]
then
        echo "I'm sorry to hear you do not like Linux"
        echo "Why do you not like Linux?"
else
        echo "Your response must be either 'y' or 'no'."
        echo "Please re-run the script to try again."
fi
