Param(
    [string]$ItemPath
)
$outlook = New-Object -ComObject Outlook.Application

$mailPath = (Get-Item -Path $ItemPath).FullName
$mail = $outlook.CreateItemFromTemplate($mailPath)

@(1..$mail.Attachments.Count) | 
    % { $mail.Attachments.Item($_) } | 
    % { $_.SaveAsFile("$PWD/$($_.FileName)") }