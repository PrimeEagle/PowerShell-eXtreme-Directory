param (
    [string]$Path
)

$cacheFile = "D:\My Code\PowerShell Scripts\_xd-cache.txt"
$cacheLimit = 1000

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
    $match = $cache | Where-Object {
        $_ -like "*\$SearchPath*" -and $_.StartsWith($currentDirectory.Path) -and $_ -ne $currentDirectory.Path
    } | Select-Object -First 1

    if ($match) {
        Update-Cache $match
        return $match
    }

    $queue = New-Object System.Collections.Generic.Queue[System.IO.DirectoryInfo]
    $root = Get-Item -Path $currentDirectory
    $queue.Enqueue($root)

    while ($queue.Count -gt 0) {
        $current = $queue.Dequeue()
        foreach ($subDir in $current.GetDirectories()) {
            if ($subDir.Name -like "*$SearchPath*") {
                Update-Cache $subDir.FullName
                return $subDir.FullName
            }
            $queue.Enqueue($subDir)
        }
    }

    return $null
}

$directory = Find-Directory -SearchPath $Path
if ($directory) {
    Set-Location $directory
} else {
    Write-Host "No matching directory found for '$Path'."
}