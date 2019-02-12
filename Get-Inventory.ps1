<#
.SYNOPSIS
Get Server Information
.DESCRIPTION
This script will get the CPU specifications, memory usage statistics, and OS configuration of any Server or Computer listed in Serverlist.txt.
.NOTES  
The script will execute the commands on multiple machines sequentially using non-concurrent sessions. This will process all servers from Serverlist.txt in the listed order.
The info will be exported to a csv format.
Requires: Serverlist.txt must be created in the same folder where the script is.
File Name  : Get-Inventory.ps1
Author: Nikolay Petkov
Extensions: QDBA
http://power-shell.com/
#>


function Get-MSOfficeProductKey {
    param(
    [string[]]$computerName = "."
    )

    $product = @()
    $hklm = 2147483650
    $path = "SOFTWARE\Microsoft\Office"

    foreach ($computer in $computerName) {

        $wmi = [WMIClass]"\\$computer\root\default:stdRegProv"

        $subkeys1 = $wmi.EnumKey($hklm,$path)
        foreach ($subkey1 in $subkeys1.snames) {
            $subkeys2 = $wmi.EnumKey($hklm,"$path\$subkey1")
            foreach ($subkey2 in $subkeys2.snames) {
                $subkeys3 = $wmi.EnumKey($hklm,"$path\$subkey1\$subkey2")
                foreach ($subkey3 in $subkeys3.snames) {
                    $subkeys4 = $wmi.EnumValues($hklm,"$path\$subkey1\$subkey2\$subkey3")
                    foreach ($subkey4 in $subkeys4.snames) {
                        if ($subkey4 -eq "digitalproductid") {
                            $temp = "" | select ComputerName,ProductName,ProductKey
                            $temp.ComputerName = $computer
                            $productName = $wmi.GetStringValue($hklm,"$path\$subkey1\$subkey2\$subkey3","productname")
                            $temp.ProductName = $productName.sValue

                            $data = $wmi.GetBinaryValue($hklm,"$path\$subkey1\$subkey2\$subkey3","digitalproductid")
                            $valueData = ($data.uValue)[52..66]

                            # decrypt base24 encoded binary data 
                            $productKey = ""
                            $chars = "BCDFGHJKMPQRTVWXY2346789"
                            for ($i = 24; $i -ge 0; $i--) { 
                                $r = 0 
                                for ($j = 14; $j -ge 0; $j--) { 
                                    $r = ($r * 256) -bxor $valueData[$j] 
                                    $valueData[$j] = [math]::Truncate($r / 24)
                                    $r = $r % 24 
                                } 
                                $productKey = $chars[$r] + $productKey 
                                if (($i % 5) -eq 0 -and $i -ne 0) { 
                                    $productKey = "-" + $productKey 
                                } 
                            } 
                            $temp.ProductKey = $productKey
                            $product += $temp
                        }
                    }
                }
            }
        }
    }
    $product
}


echo "##Computerinformation"
echo "============================================================"
echo ""

# Update output buffer size to 500
if( $Host -and $Host.UI -and $Host.UI.RawUI ) {
  $rawUI = $Host.UI.RawUI
  $oldSize = $rawUI.BufferSize
  $typeName = $oldSize.GetType( ).FullName
  $newSize = New-Object $typeName (500, $oldSize.Height)
  $rawUI.BufferSize = $newSize
}

echo "--- Computer ---"
# Gather some things 
$CPUInfo = Get-WmiObject Win32_Processor -ComputerName . #Get CPU Information
$OSInfo = Get-WmiObject Win32_OperatingSystem -ComputerName . #Get OS Information
#Get Memory Information. The data will be shown in a table as MB, rounded to the nearest second decimal.
#$OSTotalVirtualMemory = [math]::round($OSInfo.TotalVirtualMemorySize / 1MB, 2)
#$OSTotalVisibleMemory = [math]::round(($OSInfo.TotalVisibleMemorySize / 1MB), 2)
$PhysicalMemory = Get-WmiObject CIM_PhysicalMemory -ComputerName . | Measure-Object -Property capacity -Sum | % { [Math]::Round(($_.sum / 1GB), 2) }
$System = Get-WmiObject -Class Win32_ComputerSystem
$BIOS = Get-WmiObject -Class Win32_BIOS -ComputerName .
	
# Get Windows Produktkey
$map="BCDFGHJKMPQRTVWXY2346789"
$value = (get-itemproperty "HKLM:\\SOFTWARE\Microsoft\Windows NT\CurrentVersion").digitalproductid[0x34..0x42]
$OSProductKey = ""
for ($i = 24; $i -ge 0; $i--) {
    $r = 0
    for ($j = 14; $j -ge 0; $j--) {
        $r = ($r * 256) -bxor $value[$j]
        $value[$j] = [math]::Floor([double]($r/24))
        $r = $r % 24
    }
    $OSProductKey = $map[$r] + $OSProductKey
    if (($i % 5) -eq 0 -and $i -ne 0) {
        $OSProductKey = "-" + $OSProductKey
    }
}
    



	$infoObject = New-Object PSObject
	#The following add data to the infoObjects.	
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "ComputerName" -value $CPUInfo.SystemName
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "Manufacturer" -value $System.Manufacturer
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "Model" -value $System.Model
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "BIOS Version" -value $BIOS.SMBIOSBIOSVersion
    Add-Member -inputObject $infoObject -memberType NoteProperty -name "Computer S/N" -value $BIOS.SerialNumber

	Add-Member -inputObject $infoObject -memberType NoteProperty -name "CPU" -value $CPUInfo.Name
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "CPU Model" -value $CPUInfo.Description
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "CPU Manufacturer" -value $CPUInfo.Manufacturer
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "PhysicalCores" -value $CPUInfo.NumberOfCores
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "CPU L2CacheSize" -value $CPUInfo.L2CacheSize
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "CPU L3CacheSize" -value $CPUInfo.L3CacheSize
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "Sockets" -value $CPUInfo.SocketDesignation
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "LogicalCores" -value $CPUInfo.NumberOfLogicalProcessors
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "OS Name" -value $OSInfo.Caption
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "OS Version" -value $OSInfo.Version
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "Windows Produkt Key" -value $OSProductKey
	Add-Member -inputObject $infoObject -memberType NoteProperty -name "Total Physical Memory GB" -value $PhysicalMemory
#	Add-Member -inputObject $infoObject -memberType NoteProperty -name "Total Virtual Memory MB" -value $OSTotalVirtualMemory
#	Add-Member -inputObject $infoObject -memberType NoteProperty -name "Total Visable Memory MB" -value $OSTotalVisibleMemory
	
    ($infoObject|Out-String).Trim()
    echo ""

    echo "--- Hotfixes ---"
    (Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName . |Select-Object Description, HotFixID, InstalledOn |out-string).Trim()
    echo ""

    echo "--- Software ---"
    (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, DisplayVersion, Publisher, InstallDate|Out-String).Trim()
    echo ""

    echo "--- User ---"
    Get-WmiObject -Class Win32_UserAccount | Select-Object Caption,SID
    echo ""



    echo "`n`n`n"