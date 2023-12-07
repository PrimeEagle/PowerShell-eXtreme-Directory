param (
    [string]$Path
)

$cacheFile = "D:\My Code\PowerShell Scripts\_xd-cache.txt"
$cacheLimit = 100

function Update-Cache {
    param (
        [string]$NewPath
    )

    $cache = @()
    if (Test-Path $cacheFile) {
        $cache = Get-Content $cacheFile
    }

    $cache = $cache | Where-Object { $_ -ne $NewPath }
    $cache = @($NewPath) + $cache

    if ($cache.Count -gt $cacheLimit) {
        $cache = $cache[0..($cacheLimit-1)]
    }

    $cache | Set-Content $cacheFile
}

function Find-Directory {
    param (
        [string]$SearchPath
    )

    if (-not (Test-Path $cacheFile)) {
        New-Item -Path $cacheFile -ItemType File -Force | Out-Null
    }

    $currentDirectory = Get-Location

    $cache = Get-Content $cacheFile
    $ancestors = $currentDirectory.Path -split '\\' | ForEach-Object {
        $path = ''
        for ($i = 0; $i -lt $PSItemIndex + 1; $i++) {
            $path = Join-Path -Path $path -ChildPath $_[$i]
        }
        $path
    }

    foreach ($ancestor in $ancestors) {
        $match = $cache | Where-Object { $_ -eq $ancestor -and $_ -like "*$SearchPath*" } | Select-Object -First 1
        if ($match) {
            Update-Cache $match
            return $match
        }
    }

    $current = Get-Item -Path $currentDirectory
    while ($current -ne $null) {
        if ($current.FullName -like "*$SearchPath*") {
            Update-Cache $current.FullName
            return $current.FullName
        }

        $current = $current.Parent
    }

    return $null
}

$directory = Find-Directory -SearchPath $Path
if ($directory) {
    Set-Location $directory
} else {
    Write-Host "No matching directory found for '$Path'."
}