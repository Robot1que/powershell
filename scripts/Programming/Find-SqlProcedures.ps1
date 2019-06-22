[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true, Position = 1)]
    [string] $FolderPath,
    [Parameter(Mandatory = $true, Position = 2)]
    [string] $StoredProcedureName
)

$ErrorActionPreference = "Stop"

$spFilePaths = 
    Get-Item -LiteralPath $folderPath `
        | Get-ChildItem -Filter "*.sqs" -Recurse `
        | Select-Object -ExpandProperty FullName

[string[]] $global:alreadyProcessed = @()

function Get-FromFile([string] $filePath)
{
    $lines = Get-Content -LiteralPath $filePath
    foreach($line in $lines)
    {
        if ($line -match "bsp_[a-zA-Z0-9_]+")
        {
            Write-Output $Matches[0]
        }
    }
}

function Get-FromStoredProcedure([string] $spName)
{
    $global:alreadyProcessed += $spName

    $fileName = $spName.substring(1, $spName.Length - 1) + ".sqs"
    $filePath = $spFilePaths | where { $_ -like "*$fileName" }

    if ($filePath)
    {
        $spNames = Get-FromFile $filePath

        if ($spNames)
        {
            foreach($childName in $spNames)
            {
                if ($global:alreadyProcessed -notcontains $childName)
                {
                    Get-FromStoredProcedure $childName
                }
            }
        }
    }
}

Get-FromStoredProcedure $StoredProcedureName

$global:alreadyProcessed
