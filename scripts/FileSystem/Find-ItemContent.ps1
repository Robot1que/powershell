[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$LiteralPath,

    [Parameter(Mandatory=$True, Position=2)]
    [string]$RegexPattern,

    [Parameter(Mandatory=$False, Position=3)]
    [string]$FileFilter
)

$ErrorActionPreference = "Stop"

$projects = 
    Get-Item -LiteralPath $LiteralPath |
    Get-ChildItem -Filter $FileFilter -File -Recurse | 
    Select-Object -ExpandProperty FullName

foreach($filePath in $projects)
{
    $matchingLines = 
        Get-Content -LiteralPath $filePath | 
        Where-Object { $_ -match $RegexPattern }

    if ($matchingLines.Length -gt 0)
    {
        $props = [Ordered]@{
            Path = $filePath;
            Lines = $matchingLines
        }
        Write-Output (New-Object PSObject -Property $props)
    }
}