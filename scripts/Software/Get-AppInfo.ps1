[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$AppName
)
Process
{
    function Get-RegItem([string[]]$Path)
    {
        Get-ChildItem -Path $Path `
            | Where-Object { $_.Property -contains "DisplayName" } `
            | Where-Object { ($_ | Get-ItemProperty -Name "DisplayName").DisplayName -like $AppName } `
            | Get-ItemProperty
    }

    Get-RegItem -Path @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )
}