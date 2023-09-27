#!/bin/bash
clear
# Define colors and checkmark
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
CHECK_MARK="\xE2\x9C\x94"

CLIENT="/usr/local/Cellar/proxmark3/4.14831/bin/pm3"

# Clear contents of the "temp" folder
temp_folder="temp"
rm -rf "$temp_folder"/*

echo "===================="
echo -e "     ${CYAN}AMIIBO PM3${NC}"
echo "===================="
echo ""

# Function to recursively rename folders
rename_folders() {
    local dir="$1"
    local new_dir

    # Rename the directory first
    new_dir="${dir// /_}"  # Replace spaces with underscores

    if [[ "$dir" != "$new_dir" ]]; then
        mv "$dir" "$new_dir"
    fi

    local has_bin_files=false

    # Iterate through each entry in the renamed directory
    for entry in "$new_dir"/*; do
        if [ -d "$entry" ]; then
            rename_folders "$entry"  # Recur into subdirectory
        elif [ -f "$entry" ] && [[ "$entry" == *".bin" ]]; then
            has_bin_files=true
        fi
    done

    # If there are no .bin files, and the directory name contains no spaces, skip renaming
    if ! $has_bin_files && [[ "$new_dir" != *" "* ]]; then
        return
    fi

    # Rename .bin files
    for bin_file in "$new_dir"/*.bin; do
        if [ -f "$bin_file" ]; then
            new_bin_file="${bin_file// /}"  # Remove spaces
            mv "$bin_file" "$new_bin_file"
        fi
    done
}

# Function to process .bin files
process_bin_files() {
    local temp_folder="$1"
    local current_dir

    # Check if there are subfolders in the temp folder
    if [ -z "$(find "$temp_folder" -mindepth 1 -type d)" ]; then
        # No subfolders, process .bin files directly in the temp folder
        for current_dir in "$temp_folder"/*.bin; do
            if [ -f "$current_dir" ]; then
                BIN_FILE_NAME=$(basename "$current_dir")
                echo -n -e "${YELLOW}Processing ${NC}'${BIN_FILE_NAME}'"
                ${CLIENT} -c "hf mf eclr" > /dev/null 2>&1
                ${CLIENT} -c "hf mfu eload -f ${current_dir} --ul" > /dev/null 2>&1
                echo -e -n "\\r\033[K${PURPLE}- ${GREEN}Ready ${NC}'${BIN_FILE_NAME}'"
                ${CLIENT} -c "hf 14a sim -t 7" > /dev/null 2>&1
                echo -e "\\r\033[K${PURPLE}${CHECK_MARK} ${GREEN}Done ${NC}'${BIN_FILE_NAME}'"
            fi
        done
    else
        # Iterate through subfolders and process .bin files
        for current_dir in "$temp_folder"/*; do
            if [ -d "$current_dir" ]; then
                process_bin_files "$current_dir"  # Recursive call for subdirectories
            fi
        done
    fi
}

# Check if a directory or .bin file is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory or .bin file>"
    exit 1
fi

# Check if the provided path exists
if [ ! -e "$1" ]; then
    echo -e "${RED}Error: Path '$1' does not exist.${NC}"
    exit 1
fi

# If it's a directory, check if it exists
if [ -d "$1" ]; then
    if [ ! -d "$1" ]; then
        echo -e "${RED}Error: Directory '$1' does not exist.${NC}"
        exit 1
    fi
fi

# Create a copy of the input directory in the "temp" folder
mkdir -p "$temp_folder"
echo -n -e "${YELLOW}Making copy of files.${NC}"
cp -r "$1" "$temp_folder"
echo -e "\\r\033[K${PURPLE}${CHECK_MARK} ${GREEN}Files copied to temp folder.${NC}"

# Call the function to rename folders in the copy
echo -e -n "${YELLOW}Formatting file names.${NC}"
rename_folders "$temp_folder/$(basename "$1")"

echo -e "\r\033[K${PURPLE}${CHECK_MARK} ${GREEN}Formatting complete.${NC}"

echo ""
echo "Starting Emulation: $(basename "$1")"
process_bin_files "$temp_folder"
echo -e "\\r\033[K${PURPLE}${CHECK_MARK} ${GREEN}Processing complete.${NC}"