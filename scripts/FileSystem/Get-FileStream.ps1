<#
.SYNOPSIS
Helps to find file origin when downloaded from Internet.
#>

Get-Item -Path .\file.png -Stream *
Get-Content -Path .\file.png -Stream Zone.Identifier