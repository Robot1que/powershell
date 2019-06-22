[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$Path,
    [Parameter(Mandatory=$true)]
    [string]$ReferenceName,
    [Parameter(Mandatory=$false)]
    [string]$ReferenceVersion
)

function Get-Assembly([string]$Path)
{
    Get-ChildItem -Path $Path -Include "*.dll" -Recurse | Select-Object -ExpandProperty FullName
}

function Get-AssemblyReference
{
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$AssemblyFilePath,
        [Parameter(Mandatory=$true)]
        [string]$ReferenceName,
        [Parameter(Mandatory=$false)]
        [string]$ReferenceVersion
    )
    Process
    {
        try 
        {
            $assembly = [System.Reflection.Assembly]::LoadFrom($AssemblyFilePath)    
        }
        catch {
            return
        }
        
        $references = `
            $assembly.GetReferencedAssemblies() `
                | Where-Object { $_.Name -eq $ReferenceName }

        if ($ReferenceVersion)
        {
            $references = $references | Where-Object { $_.Version -eq $ReferenceVersion }
        }

        if ($references)
        {
            $props = [Ordered]@{
                FullName = $AssemblyFilePath;
                Reference = $references;
            }
            
            New-Object -TypeName PSObject -Property $props
        }
    }
}

 Get-Assembly -Path $Path `
    | Get-AssemblyReference `
        -ReferenceName $ReferenceName `
        -ReferenceVersion $ReferenceVersion