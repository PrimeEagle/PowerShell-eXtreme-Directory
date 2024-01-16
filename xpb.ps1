param (
    [string]$Path,
    [switch]$All
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$includeFile = Join-Path $scriptPath "Directory-Search-Functions.ps1"
. $includeFile


$directory = Find-Directory -SearchPath $Path -ParentSearch
if ($directory) {
	Set-Location $directory
    Start-Process "explorer.exe" -ArgumentList $directory
} else {
    Write-Host "No matching directory found for '$Path'."
}