#!/bin/bash

# Color codes
GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
BLUE='\e[34m'
BOLD='\e[1m'
RESET='\e[0m'

# Clear the terminal
clear

# Config file path (for saving user preferences)
CONFIG_FILE="$HOME/.domainsplitter_config"

# Display the custom ASCII banner
echo -e "${BLUE}${BOLD}"
echo "          DOMAIN SPLITTING TOOL"
echo "                     ______"
echo "  Devloped by     .-\"      \".   YADAV"
echo "                 /            \\"
echo "  Release at    |              |   14/11/2024"
echo "                |,  .-.  .-.  ,|"
echo "                | )(__/  \\__)( |"
echo "                |/     /\\     \\|"
echo "      (@_       (_     ^^     _)"
echo " _     ) \\_______\\__|IIIIII|__/__________________________"
echo "(_)@8@8{}<________|-\\IIIIII/-|___________________________>"
echo "       )_/        \\          /"
echo "      (@           \`--------\` "
echo "                Version: 1.0.0 - Initial Release"
echo -e "${RESET}"

# Step 1: Get the file path from the user
echo -e "${YELLOW}${BOLD}Enter Domain file path${RESET}"
read -p "➡️ File Path: " file_path

# Check if the file exists and is a text file (case insensitive check)
if [[ -f "$file_path" && "$file_path" =~ \.txt$ ]]; then
    echo -e "${GREEN}${BOLD}✅ 𝗙𝗶𝗹𝗲 𝘄𝗮𝘀 𝗳𝗼𝘂𝗻𝗱!${RESET}"

    # Count the lines in the file
    line_count=$(wc -l < "$file_path")
    file_size=$(du -h "$file_path" | cut -f1)
    echo -e "${BLUE}${BOLD}Total lines: $line_count, File size: $file_size${RESET}"

    # Step 2: Get suggested number of parts based on file size and line count
    suggested_parts=$((line_count / 200 + 1))
    echo -e "${YELLOW}${BOLD}Suggested parts: approximately $suggested_parts.${RESET}"

    # Step 3: Get the number of parts to split the file into
    while true; do
        echo -e "${YELLOW}${BOLD}Enter number of parts:${RESET}"
        read -p "➡️ Number of parts: " num_parts
        if [[ "$num_parts" =~ ^[0-9]+$ ]] && (( num_parts > 0 )); then
            break
        else
            echo -e "${RED}${BOLD}❌ Please enter a valid positive integer.${RESET}"
        fi
    done

    # Step 4: Get custom prefix for part files (suggest previous if available)
    if [[ -f "$CONFIG_FILE" ]]; then
        . "$CONFIG_FILE"  # Load previous settings
        echo -e "${YELLOW}${BOLD}Previous prefix: $saved_prefix${RESET}"
    fi
    echo -e "${YELLOW}${BOLD}Enter file prefix (default: 'part'):${RESET}"
    read -p "➡️ File prefix: " file_prefix
    file_prefix=${file_prefix:-part}

    # Step 5: Get the save location (ensure it's a valid directory)
    if [[ -f "$CONFIG_FILE" ]]; then
        echo -e "${YELLOW}${BOLD}Previous save location: $saved_path${RESET}"
    fi
    echo -e "${YELLOW}${BOLD}Enter save location (default: /storage/emulated/0/)${RESET}"
    read -p "➡️ Save location: " output_path
    output_path=${output_path:-/storage/emulated/0/}

    # Save current settings for next time
    echo "saved_prefix=$file_prefix" > "$CONFIG_FILE"
    echo "saved_path=$output_path" >> "$CONFIG_FILE"

    # Check if the directory exists, create if it doesn't
    if [[ ! -d "$output_path" ]]; then
        echo -e "${YELLOW}${BOLD}Directory not found, creating it.${RESET}"
        mkdir -p "$output_path" || { echo -e "${RED}${BOLD}Error creating directory. Check permissions.${RESET}"; exit 1; }
    fi

    # Calculate lines per part
    lines_per_part=$(( (line_count + num_parts - 1) / num_parts ))

    # Step 6: Splitting process with incremental progress
    echo -e "${BLUE}${BOLD}Splitting in progress... Please wait.${RESET}"
    
    # Split the file
    split -l $lines_per_part --numeric-suffixes=1 --suffix-length=1 --additional-suffix=.txt "$file_path" "$output_path/$file_prefix"

    echo -e "${GREEN}${BOLD}🎉 File has been split into $num_parts parts and saved at $output_path!${RESET}"

    # Summary
    echo -e "${BLUE}${BOLD}"
    echo "========================================="
    echo "Process Summary:"
    echo "➡️ Total lines: $line_count"
    echo "➡️ Lines per part: $lines_per_part"
    echo "➡️ Number of parts: $num_parts"
    echo "➡️ Output directory: $output_path"
    echo "========================================="
    echo -e "${RESET}"

else
    echo -e "${RED}${BOLD}❌ File not found or invalid format. Ensure it is a .txt file.${RESET}"
fi