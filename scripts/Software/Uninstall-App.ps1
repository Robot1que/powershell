[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$AppName
)
Process
{
    Get-CimInstance -ClassName Win32_Product -Filter "Name like '%$AppName%'" |
        ForEach-Object {
            msiexec /x $_.IdentifyingNumber /passive
        }
}