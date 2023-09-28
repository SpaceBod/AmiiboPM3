#!/bin/bash
clear

CLIENT="/usr/local/Cellar/proxmark3/4.17140/bin/pm3"
retail="/usr/local/Cellar/proxmark3/4.17140/share/proxmark3/resources/key_retail.bin"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
CHECK_MARK="\xE2\x9C\x94"

function random_num_hex() {
    local str=""
    for ((i=1; i<=$1; i++)); do
        str="$str$(printf "%x" $((RANDOM % 16)))"
    done
    echo "$str"
}

function main() {
    local file=$1

    echo "===================="
    echo -e "  ${CYAN}INFINITE AMIIBO${NC}"
    echo "===================="
    echo ""

    # Create or clear 'temp' directory
    if [ ! -d "temp" ]; then
        mkdir "temp"
    else
        rm -rf "temp"/*
    fi

    # Copy the file to 'temp'
    cp "$file" "temp/"

    # Remove spaces from the file name
    local baseName=$(basename "$file")
    local newName="${baseName// /}"

    mv "temp/$baseName" "temp/$newName"

    echo -e "${YELLOW}Processing - ${NC}${file}"
    echo "Press the PM3s button to cycle to the next UID..."
    echo -e "\nEmulating UIDs"
    echo "--------------"
    while true; do
        local uid="04$(random_num_hex 12)"
        ${CLIENT} -c "script run amiibo_change_uid $uid $inputTemplate temp/$newName $retail" > /dev/null 2>&1
        echo -e "${GREEN}${uid}"
        ${CLIENT} -c "script run hf_mfu_amiibo_sim -f temp/$newName" > /dev/null 2>&1
    done
}

main "$@"
