-- ~/.config/nvim/lua/snippets/arduino.lua

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
    -- Basic Arduino setup
    s("setup", {
        t("void setup() {"),
        t({"", "    // Initialize serial communication at 9600 baud"}),
        t({"", "    Serial.begin(9600);"}),
        t({"", "    "}),
        i(1, "// Add your setup code here"),
        t({"", "}"}),
        t({"", ""}),
        t({"", "void loop() {"}),
        t({"", "    "}),
        i(2, "// Add your main code here"),
        t({"", "}"}),
    }),

    -- Pin mode setup
    s("pinMode", {
        t("pinMode("),
        i(1, "pin"),
        t(", "),
        i(2, "INPUT"),
        t(");"),
    }),

    -- Digital read
    s("digitalRead", {
        t("digitalRead("),
        i(1, "pin"),
        t(")"),
    }),

    -- Digital write
    s("digitalWrite", {
        t("digitalWrite("),
        i(1, "pin"),
        t(", "),
        i(2, "HIGH"),
        t(");"),
    }),

    -- Analog read
    s("analogRead", {
        t("analogRead("),
        i(1, "pin"),
        t(")"),
    }),

    -- Analog write (PWM)
    s("analogWrite", {
        t("analogWrite("),
        i(1, "pin"),
        t(", "),
        i(2, "value"),
        t(");"),
    }),

    -- Serial print
    s("print", {
        t("Serial.print("),
        i(1, "value"),
        t(");"),
    }),

    -- Serial println
    s("println", {
        t("Serial.println("),
        i(1, "value"),
        t(");"),
    }),

    -- Delay
    s("delay", {
        t("delay("),
        i(1, "1000"),
        t(");"),
    }),

    -- For loop
    s("for", {
        t("for (int "),
        i(1, "i"),
        t(" = "),
        i(2, "0"),
        t("; "),
        f(function(args) return args[1][1] end, {1}),
        t(" < "),
        i(3, "10"),
        t("; "),
        f(function(args) return args[1][1] end, {1}),
        t("++) {"),
        t({"", "    "}),
        i(4, "// Loop body"),
        t({"", "}"}),
    }),

    -- If statement
    s("if", {
        t("if ("),
        i(1, "condition"),
        t(") {"),
        t({"", "    "}),
        i(2, "// If body"),
        t({"", "}"}),
    }),

    -- Function definition
    s("func", {
        i(1, "void"),
        t(" "),
        i(2, "functionName"),
        t("("),
        i(3, ""),
        t(") {"),
        t({"", "    "}),
        i(4, "// Function body"),
        t({"", "}"}),
    }),

    -- Include library
    s("include", {
        t("#include <"),
        i(1, "library.h"),
        t(">"),
    }),

    -- Define constant
    s("define", {
        t("#define "),
        i(1, "CONSTANT_NAME"),
        t(" "),
        i(2, "value"),
    }),

    -- Variable declaration
    s("int", {
        t("int "),
        i(1, "variable"),
        t(" = "),
        i(2, "0"),
        t(";"),
    }),

    -- Const variable
    s("const", {
        t("const int "),
        i(1, "VARIABLE"),
        t(" = "),
        i(2, "value"),
        t(";"),
    }),

    -- While loop
    s("while", {
        t("while ("),
        i(1, "condition"),
        t(") {"),
        t({"", "    "}),
        i(2, "// Loop body"),
        t({"", "}"}),
    }),

    -- LED blink example
    s("blink", {
        t("#define LED_PIN 13"),
        t({"", ""}),
        t({"", "void setup() {"}),
        t({"", "    pinMode(LED_PIN, OUTPUT);"}),
        t({"", "}"}),
        t({"", ""}),
        t({"", "void loop() {"}),
        t({"", "    digitalWrite(LED_PIN, HIGH);"}),
        t({"", "    delay(1000);"}),
        t({"", "    digitalWrite(LED_PIN, LOW);"}),
        t({"", "    delay(1000);"}),
        t({"", "}"}),
    }),

    -- Servo control
    s("servo", {
        t("#include <Servo.h>"),
        t({"", ""}),
        t({"", "Servo myServo;"}),
        t({"", ""}),
        t({"", "void setup() {"}),
        t({"", "    myServo.attach("},
        i(1, "9"),
        t(");"),
        t({"", "}"}),
        t({"", ""}),
        t({"", "void loop() {"}),
        t({"", "    myServo.write("},
        i(2, "90"),
        t(");"),
        t({"", "    delay(1000);"}),
        t({"", "}"}),
    }),

    -- Sensor reading template
    s("sensor", {
        t("int sensorPin = "),
        i(1, "A0"),
        t(";"),
        t({"", "int sensorValue = 0;"}),
        t({"", ""}),
        t({"", "void setup() {"}),
        t({"", "    Serial.begin(9600);"}),
        t({"", "}"}),
        t({"", ""}),
        t({"", "void loop() {"}),
        t({"", "    sensorValue = analogRead(sensorPin);"}),
        t({"", "    Serial.println(sensorValue);"}),
        t({"", "    delay(500);"}),
        t({"", "}"}),
    }),

    -- Button reading with debounce
    s("button", {
        t("const int buttonPin = "),
        i(1, "2"),
        t(";"),
        t({"", "const int ledPin = "},
        i(2, "13"),
        t(";"),
        t({"", ""}),
        t({"", "int buttonState = 0;"}),
        t({"", ""}),
        t({"", "void setup() {"}),
        t({"", "    pinMode(ledPin, OUTPUT);"}),
        t({"", "    pinMode(buttonPin, INPUT);"}),
        t({"", "}"}),
        t({"", ""}),
        t({"", "void loop() {"}),
        t({"", "    buttonState = digitalRead(buttonPin);"}),
        t({"", "    if (buttonState == HIGH) {"}),
        t({"", "        digitalWrite(ledPin, HIGH);"}),
        t({"", "    } else {"}),
        t({"", "        digitalWrite(ledPin, LOW);"}),
        t({"", "    }"}),
        t({"", "}"}),
    }),
}
