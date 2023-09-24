# Amiibo Conversion Scripts

This repository contains two Bash scripts designed for converting Amiibo files and executing Proxmark3 commands. These scripts facilitate the process of converting Amiibo binary files (.bin) to their corresponding Emulate (.eml) format and emulating them using Proxmark3.

## Contents

1. [Scripts](#scripts)
2. [Usage](#usage)
3. [Prerequisites](#prerequisites)
4. [Instructions](#instructions)
5. [Contributing](#contributing)
6. [License](#license)

## Scripts

### 1. `bin2eml.sh`

This script converts Amiibo binary files to Emulate format. It recursively scans a specified directory, converts the files, and saves the resulting Emulate files in a specified output directory (EML).

### 2. `amiiboPM3.sh`

This script automates the execution of Proxmark3 commands on a batch of Emulate files. It takes an input directory containing Emulate files, executes Proxmark3 commands on each file, and provides status updates. Press the physical button on the device to skip to the next Amiibo.

## Usage

### `bin2eml.sh`

```
bash bin2eml.sh </path/to/.bin/directory>
```

### `amiiboPM3.sh`

```
bash amiiboPM3.sh </path/to/.eml/directory>
```

## Prerequisites

- Proxmark3 installed on your system
- Input Amiibo files in binary format (.bin)
- Emulate files will be saved with the .eml extension

## Instructions

- Ensure Proxmark3 is properly installed and accessible in your environment.  
- Place the Amiibo binary files in the specified input directory.  
- Execute bin2eml.sh with the input directory as an argument.  
- The script will convert the files and save the Emulate files in the specified output directory.  
- Use amiiboPM3.sh to automate the execution of Proxmark3 commands on the Emulate files.  
- Press the button on the side of the PM3 to emulate the next Amiibo (green light - ready).  
 
## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or create a pull request.

## License

This project is licensed under the MIT License.