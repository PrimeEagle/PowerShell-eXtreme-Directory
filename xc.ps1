param (
    [string]$Path
)

. "D:\My Code\PowerShell Scripts\Directory-Search-Functions.ps1"


$directory = Find-Directory -SearchPath $Path -ChildSearch
if ($directory) {
    Set-Location $directory
} else {
    Write-Host "No matching directory found for '$Path'."
}