function Write-Formatted
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Format,
        [Parameter(Mandatory=$false, Position=1)]
        [object[]]$InputObject
    )
    Process
    {
        $pattern = "(?<prefix>[^{}]*)(?<format>{\d+(:[^{}]*)?})(?<sufix>.*)"
        $string = $Format
        
        while($string -match $pattern)
        {
            $prefix = $Matches["prefix"]
            $format = $Matches["format"]
            $string = $Matches["sufix"]

            Write-Host -Object $prefix -NoNewline
            Write-Host -Object ($format -f $InputObject) -NoNewline -ForegroundColor Cyan
        }

        Write-Host $string
    }
}