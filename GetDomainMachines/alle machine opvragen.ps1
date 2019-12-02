Install-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory
Get-ADComputer -Filter * | ConvertTo-Json | Out-File "c:\temp\machines.json"