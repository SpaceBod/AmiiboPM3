#!/bin/bash

#  SYNTAX: bash amiibo-convert.sh </path/to/input/directory>
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
        local OUTPUT_ITEM="${OUTPUT_DIR}/${BASENAME// /_}"

        if [ -d "${ITEM}" ]; then
            convert_amiibo "${ITEM}" "${OUTPUT_ITEM}" "${CONVERTER}"
        elif [ -f "${ITEM}" ] && [ "${ITEM##*.}" == "bin" ]; then
            local EMULATE_FILE="${OUTPUT_ITEM}.eml"
            local AMIIBO_COPY="${OUTPUT_ITEM}.bin"

            if [ -f "${EMULATE_FILE}" ]; then
                rm -rf "${EMULATE_FILE}"
            fi

            cp -rf "${ITEM}" "${AMIIBO_COPY}"
            ${CONVERTER} "${AMIIBO_COPY}" > /dev/null 2>&1  # Suppress converter output

            if [ -f "${AMIIBO_COPY}" ]; then
                rm -rf "${AMIIBO_COPY}"
            fi

            # Increment the conversion counter
            ((CONVERSION_COUNT++))

            # Echo the name of the converted file
            echo -e "${GREEN}Converted: ${NC}${BASENAME}"
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

convert_amiibo "${INPUT_DIR}" "${DUMP_DIR}" "${CONVERTER}"

echo -e "\n${PURPLE}Total conversions made: ${CONVERSION_COUNT}${NC}"
