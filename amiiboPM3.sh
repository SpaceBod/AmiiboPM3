#!/bin/bash

# SYNTAX: bash execute_commands.sh </path/to/eml/directory>
clear

CLIENT="/usr/local/Cellar/proxmark3/4.14831/bin/pm3"

EMULATE_DIR="${1}"

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"

if [ ! -d "${EMULATE_DIR}" ]; then
    echo -e "${RED}The input directory does not exist. Try again.${NC}"
    exit 1
fi

echo "===================="
echo -e "${CYAN}Starting Emulation...${NC}"
echo "===================="
echo ""

for EMULATE_FILE in "${EMULATE_DIR}"/*.eml; do
    if [ -f "${EMULATE_FILE}" ]; then
        EMULATE_FILE_NAME=$(basename "${EMULATE_FILE}")
        echo -n -e "${YELLOW}Processing ${NC}'${EMULATE_FILE_NAME}'"
        ${CLIENT} -c "hf mf eclr" > /dev/null 2>&1
        ${CLIENT} -c "hf mfu eload -f ${EMULATE_FILE} --ul" > /dev/null 2>&1
        echo -e -n "\\r\033[K${GREEN}Ready ${NC}'${EMULATE_FILE_NAME}'"
        ${CLIENT} -c "hf 14a sim -t 7" > /dev/null 2>&1
        echo -e "\\r\033[K${CHECK_MARK} ${PURPLE}Done ${NC}'${EMULATE_FILE_NAME}'"

    fi
done

echo -e "\n${GREEN}Execution of commands complete.${NC}"
