#!/bin/bash

# SYNTAX: bash amiibo-convert.sh </path/to/input/directory>
clear

# Initialize the conversion counter
CONVERSION_COUNT=0

GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

convert_amiibo() {
    local INPUT_DIR="$1"
    local OUTPUT_DIR="$2"
    local CONVERTER="$3"

    if [ ! -d "${OUTPUT_DIR}" ]; then
        mkdir -p "${OUTPUT_DIR}"
    fi

    for ITEM in "${INPUT_DIR}"/*; do
        local BASENAME=$(basename "${ITEM}")
        local BASENAME_NO_EXT="${BASENAME%.bin}"
        local OUTPUT_ITEM="${OUTPUT_DIR}/${BASENAME_NO_EXT// /_}"

        if [ -d "${ITEM}" ]; then
            local SUBFOLDER_NAME="${OUTPUT_DIR}/$(basename "${ITEM}" | tr ' ' '_')"
            convert_amiibo "${ITEM}" "${SUBFOLDER_NAME}" "${CONVERTER}"
        elif [ -f "${ITEM}" ] && [ "${ITEM##*.}" == "bin" ]; then
            local EMULATE_FILE="${OUTPUT_ITEM}.eml"

            if [ -f "${EMULATE_FILE}" ]; then
                rm -rf "${EMULATE_FILE}"
            fi

            ${CONVERTER} "${ITEM}" > "${OUTPUT_ITEM}.eml" 2> /dev/null # Convert directly to .eml

            # Increment the conversion counter
            ((CONVERSION_COUNT++))

            # Echo the name of the converted file (filtered for .bin extension)
            echo -e "${GREEN}Converted: ${NC}${BASENAME_NO_EXT}"
        fi
    done
}

INPUT_DIR="${1}"

DUMP_DIR="EML"

CONVERTER="/usr/local/Cellar/proxmark3/4.14831/share/proxmark3/tools/pm3_amii_bin2eml.pl"

if [ ! -d "${DUMP_DIR}" ]; then
    mkdir -p "${DUMP_DIR}"
fi

if [ ! -d "${INPUT_DIR}" ]; then
    echo "The input directory does not exist. Try again."
    exit 1
fi

echo "===================="
echo -e "${CYAN}Starting Conversion...${NC}"
echo "===================="
echo ""

convert_amiibo "${INPUT_DIR}" "${DUMP_DIR}/${INPUT_DIR// /_}" "${CONVERTER}"

echo -e "\n${PURPLE}Total conversions made: ${CONVERSION_COUNT}${NC}"
