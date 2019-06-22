[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$SourceLiteralPath,

    [Parameter(Mandatory=$True, Position=2)]
    [string]$TargetLiteralPath
)

function Get-ChildItemPath([string]$LiteralPath)
{
    Get-ChildItem -LiteralPath $LiteralPath -File -Recurse | 
        Select-Object -ExpandProperty FullName |
        ForEach-Object { $_.Substring($LiteralPath.Length, $_.Length - $LiteralPath.Length) }
}

$sourceFiles = Get-ChildItemPath -LiteralPath $SourceLiteralPath
$targetFiles = Get-ChildItemPath -LiteralPath $TargetLiteralPath

$newFiles = $targetFiles | Where-Object { $_ -notin $sourceFiles }
$removedFiles = $sourceFiles | Where-Object { $_ -notin $targetFiles }
$sharedFiles = $targetFiles | Where-Object { $_ -in $sourceFiles }

$differentVersions = @()

foreach($sharedFile in $sharedFiles)
{
    if ([System.IO.Path]::GetExtension($sharedFile) -eq ".dll")
    {
        try {
            $sourceAssemblyName = [System.Reflection.AssemblyName]::GetAssemblyName($SourceLiteralPath + $sharedFile).FullName
            $targetAssemblyName = [System.Reflection.AssemblyName]::GetAssemblyName($TargetLiteralPath + $sharedFile).FullName

            if ($sourceAssemblyName -ne $targetAssemblyName)
            {
                $props = [Ordered]@{
                    FileName = $sharedFile;
                    SourceAssemblyName = $sourceAssemblyName;
                    TargetAssemblyName = $targetAssemblyName;
                }

                $differentVersions += New-Object -TypeName PSCustomObject -Property $props
            }    
        }
        catch {
            Write-Verbose "Could not read assembly name of '$sharedFile' file."
        }
    }
}

$props = [Ordered]@{
    New = $newFiles;
    Removed = $removedFiles;
    DifferentVersions = $differentVersions
}

New-Object -TypeName PSCustomObject -Property $props