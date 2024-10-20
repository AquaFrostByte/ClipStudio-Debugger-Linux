#!/bin/bash

# Define log file location
LOGFILE="$HOME/clip_studio_debug.log"

# Print the script header
echo "Clip Studio Debugger (Wine)"

# Get user input for mode (normal or added)
read -p "[N]ormal or [A]dded? " user_input

# Get user input for showing logs in the console
read -p "Do you want to show the logs in the console? (y/n): " show_logs

# Get user input for only recording errors
read -p "Do you want to only record errors? (y/n): " record_errors

# Convert input to lowercase
user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')

# Check if user wants normal mode
if [[ "$user_input" == "n" ]]; then
    # Change to the Clip Studio directory
    cd "$HOME/.wine/drive_c/Program Files/CELSYS/CLIP STUDIO 1.5/CLIP STUDIO/" || exit

    # Run wine with appropriate logging options
    if [[ "$show_logs" == "y" ]]; then
        if [[ "$record_errors" == "y" ]]; then
            wine CLIPStudio.exe 2>&1 | grep "error" | tee "$LOGFILE"
        else
            wine CLIPStudio.exe 2>&1 | tee "$LOGFILE"
        fi
    else
        if [[ "$record_errors" == "y" ]]; then
            wine CLIPStudio.exe 2>&1 | grep "error" > "$LOGFILE" 2>&1
        else
            wine CLIPStudio.exe > "$LOGFILE" 2>&1
        fi
    fi

# Check if user wants added mode
elif [[ "$user_input" == "a" ]]; then
    # Get expression to add
    read -p "What expressions should be added? " expression

    # Change to the Clip Studio directory
    cd "$HOME/.wine/drive_c/Program Files/CELSYS/CLIP STUDIO 1.5/CLIP STUDIO/" || exit

    # Run wine with the added expression and appropriate logging options
    if [[ "$show_logs" == "y" ]]; then
        if [[ "$record_errors" == "y" ]]; then
            env "$expression" wine CLIPStudio.exe 2>&1 | grep "error" | tee "$LOGFILE"
        else
            env "$expression" wine CLIPStudio.exe 2>&1 | tee "$LOGFILE"
        fi
    else
        if [[ "$record_errors" == "y" ]]; then
            env "$expression" wine CLIPStudio.exe 2>&1 | grep "error" > "$LOGFILE" 2>&1
        else
            env "$expression" wine CLIPStudio.exe > "$LOGFILE" 2>&1
        fi
    fi

# Handle invalid input
else
    echo "Invalid input. Please enter 'n' or 'a'."
    exit 1
fi

# Inform the user about the saved log file
echo "Wine output and debug information have been saved to $LOGFILE"