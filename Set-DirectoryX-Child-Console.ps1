param (
    [string]$Path
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$includeFile = Join-Path $scriptPath "Directory-Search-Functions.ps1"
. $includeFile


$directory = Find-Directory -SearchPath $Path -ChildSearch
if ($directory) {
    Set-Location $directory
} else {
    Write-Host "No matching directory found for '$Path'."
}