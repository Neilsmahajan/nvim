#!/bin/bash
# ~/.config/nvim/scripts/generate_arduino_compile_commands.sh

# This script generates a compile_commands.json file for Arduino projects
# to help clangd provide better IntelliSense

ARDUINO_CLI_PATH="/opt/homebrew/bin/arduino-cli"
SKETCH_DIR="$1"

if [ -z "$SKETCH_DIR" ]; then
    echo "Usage: $0 <sketch_directory>"
    echo "Example: $0 ~/Arduino/MyProject"
    exit 1
fi

if [ ! -f "$ARDUINO_CLI_PATH" ]; then
    echo "Arduino CLI not found at $ARDUINO_CLI_PATH"
    echo "Please install Arduino CLI: brew install arduino-cli"
    exit 1
fi

cd "$SKETCH_DIR" || exit 1

# Get the sketch name (directory name)
SKETCH_NAME=$(basename "$PWD")

# Find the .ino file
INO_FILE=$(find . -name "*.ino" | head -1)
if [ -z "$INO_FILE" ]; then
    echo "No .ino file found in $SKETCH_DIR"
    exit 1
fi

# Get Arduino paths and compile flags
ARDUINO_DATA_DIR=$($ARDUINO_CLI_PATH config get directories.data)
ARDUINO_USER_DIR=$($ARDUINO_CLI_PATH config get directories.user)

# Common Arduino include paths
ARDUINO_INCLUDES=(
    "-I$ARDUINO_DATA_DIR/packages/arduino/hardware/avr/1.8.6/cores/arduino"
    "-I$ARDUINO_DATA_DIR/packages/arduino/hardware/avr/1.8.6/variants/standard"
    "-I$ARDUINO_DATA_DIR/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/avr/include"
    "-I$ARDUINO_DATA_DIR/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/lib/gcc/avr/7.3.0/include"
    "-I$ARDUINO_USER_DIR/libraries"
)

# Arduino defines
ARDUINO_DEFINES=(
    "-DARDUINO=10819"
    "-DARDUINO_AVR_UNO"
    "-DARDUINO_ARCH_AVR"
    "-DF_CPU=16000000L"
)

# Generate compile_commands.json
cat > compile_commands.json << EOF
[
  {
    "directory": "$PWD",
    "command": "avr-g++ ${ARDUINO_DEFINES[*]} ${ARDUINO_INCLUDES[*]} -mmcu=atmega328p -c $INO_FILE",
    "file": "$PWD/$INO_FILE"
  }
]
EOF

echo "Generated compile_commands.json for $SKETCH_NAME"
echo "You may need to adjust include paths based on your Arduino installation"
