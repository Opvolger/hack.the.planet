param (
    [string]$smtpserver = "localhost:6625",
    [string]$toaddress = "bla@opvolger.net",
    [string]$fromaddress = "bla@opvolger.net",
    [string]$files = "test.txt,README.md"
)

if ([string]::IsNullOrEmpty($fromaddress))
{
    $fromaddress = $toaddress
}

Write-Host $smtpserver
Write-Host $toaddress
Write-Host $fromaddress
Write-Host $files
#################################### 
 
$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress) 
$message.Subject = "Hack the planet"
$message.IsBodyHtml = $True 
$files.Split(",") | ForEach {
    #$attach = new-object Net.Mail.Attachment($_)
    #Write-Host $_
    $message.Attachments.Add($_)
}
$message.body = "the files that I had to mail you"
$smtp = new-object Net.Mail.SmtpClient($smtpserver, 25)
$smtp.Send($message)
 
#################################################################################