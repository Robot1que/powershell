[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True)]
    [string] $Path
)
Process
{
    if (-Not (Test-Path -Path $Path))
    {
        Write-Error "File '$Path' does not exist."
    }

    $item = Get-Item $Path
    $shell = New-Object -ComObject Shell.Application
    $nameSpace = $shell.NameSpace($item.DirectoryName)

    $attributes = 0..500 | ForEach-Object {
        $name = $nameSpace.GetDetailsOf($null, $_)
        if ($name)
        {
            @{ Index = $_; Name = $name }
        }
    }
    foreach($file in $nameSpace.Items())
    {
        if ($file.Name -eq $item.Name)
        {
            foreach($attribute in $attributes)
            {
                $props = [ordered]@{
                    Name = $attribute.Name;
                    Value = $nameSpace.GetDetailsOf($file, $attribute.Index)
                }
                New-Object -TypeName PSObject -Property $props
            }
        }
    }
}