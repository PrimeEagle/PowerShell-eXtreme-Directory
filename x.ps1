param (
    [string]$Path,
    [switch]$All
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$includeFile = Join-Path $scriptPath "Directory-Search-Functions.ps1"
. $includeFile


$directory = Find-Directory -SearchPath $Path -SearchAllDrives:$All
if ($directory) {
    Set-Location $directory
} else {
    Write-Host "No matching directory found for '$Path'."
}