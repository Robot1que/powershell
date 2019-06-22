function ConvertTo-NetFrameworkVersion([int]$Version)
{
    if ($Version -ge 460798) { return "4.7 or later"; }
    if ($Version -ge 394802) { return "4.6.2"; }
    if ($Version -ge 394254) { return "4.6.1"; }
    if ($Version -ge 393295) { return "4.6"; }
    if ($Version -ge 379893) { return "4.5.2"; }
    if ($Version -ge 378675) { return "4.5.1"; }
    if ($Version -ge 378389) { return "4.5"; }
}

$releaseVersion = `
    Get-ItemProperty `
        -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\" `
        -Name Release `
        -ErrorAction SilentlyContinue `
        | Select-Object -ExpandProperty Release

$output = "No 4.5 or later version detected"

if ($releaseVersion)
{
    $output = ConvertTo-NetFrameworkVersion -Version $releaseVersion
}

Write-Host $output