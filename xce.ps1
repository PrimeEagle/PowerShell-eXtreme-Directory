param (
    [string]$Path,
    [switch]$All
)

. .\Directory-Search-Functions.ps1


$directory = Find-Directory -SearchPath $Path -ChildSearch
if ($directory) {
    Start-Process "explorer.exe" -ArgumentList $directory
} else {
    Write-Host "No matching directory found for '$Path'."
}