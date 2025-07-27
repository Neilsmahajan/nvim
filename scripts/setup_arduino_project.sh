#!/bin/bash
# ~/.config/nvim/scripts/setup_arduino_project.sh
# Script to set up a new Arduino project with proper configuration

set -e

PROJECT_NAME="$1"
BOARD_FQBN="${2:-arduino:avr:uno}"  # Default to Arduino Uno

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: $0 <project_name> [board_fqbn]"
    echo "Example: $0 my_arduino_project arduino:avr:uno"
    echo "Available boards:"
    arduino-cli board listall | grep -E "(arduino:|esp32:|esp8266:)" | head -10
    exit 1
fi

# Check if arduino-cli is installed
if ! command -v arduino-cli &> /dev/null; then
    echo "Error: arduino-cli is not installed."
    echo "Install it with: brew install arduino-cli"
    echo "Then run: arduino-cli core update-index"
    echo "And: arduino-cli core install arduino:avr"
    exit 1
fi

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create main .ino file
cat > "${PROJECT_NAME}.ino" << EOF
/*
 * ${PROJECT_NAME}
 * Created: $(date)
 * Board: ${BOARD_FQBN}
 */

void setup() {
    // Initialize serial communication at 9600 baud
    Serial.begin(9600);
    
    // Add your setup code here
    
}

void loop() {
    // Add your main code here
    
}
EOF

# Create arduino.json for VS Code Arduino extension compatibility
cat > "arduino.json" << EOF
{
    "board": "${BOARD_FQBN}",
    "port": "/dev/cu.usbmodem*",
    "sketch": "${PROJECT_NAME}.ino"
}
EOF

# Create a simple README
cat > "README.md" << EOF
# ${PROJECT_NAME}

Arduino project created on $(date)

## Board Configuration
- **Board**: ${BOARD_FQBN}
- **Port**: /dev/cu.usbmodem* (auto-detect)

## Building and Uploading

### Using Neovim Commands
- \`<leader>av\` or \`:ArduinoCompile\` - Compile/verify the code
- \`<leader>au\` or \`:ArduinoUpload\` - Upload to board
- \`<leader>as\` or \`:ArduinoSerial\` - Open serial monitor
- \`<leader>ab\` or \`:ArduinoBoardList\` - List connected boards

### Using Arduino CLI directly
\`\`\`bash
# Compile
arduino-cli compile --fqbn ${BOARD_FQBN} ${PROJECT_NAME}.ino

# Upload
arduino-cli upload -p /dev/cu.usbmodem* --fqbn ${BOARD_FQBN} ${PROJECT_NAME}.ino

# Monitor serial output
arduino-cli monitor -p /dev/cu.usbmodem*
\`\`\`

## Dependencies
Make sure you have arduino-cli installed and the core for your board:
\`\`\`bash
arduino-cli core install arduino:avr  # For Arduino Uno/Nano/etc
arduino-cli core install esp32:esp32   # For ESP32 boards
\`\`\`
EOF

echo "✅ Arduino project '${PROJECT_NAME}' created successfully!"
echo "📂 Location: $(pwd)"
echo "🔧 Board: ${BOARD_FQBN}"
echo ""
echo "Next steps:"
echo "1. cd ${PROJECT_NAME}"
echo "2. nvim ${PROJECT_NAME}.ino"
echo "3. Write your Arduino code"
echo "4. Use <leader>av to compile and <leader>au to upload"
