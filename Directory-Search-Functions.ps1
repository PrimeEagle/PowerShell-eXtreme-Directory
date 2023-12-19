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
        [string]$SearchPath,
        [switch]$SearchAllDrives,
        [switch]$ParentSearch,
        [switch]$ChildSearch
    )

    $switchCount = @($SearchAllDrives, $ParentSearch, $ChildSearch).Where({ $_ }).Count
    if ($switchCount -gt 1) {
        throw "Only one of -SearchAllDrives, -ParentSearch, or -ChildSearch can be used at a time."
    }

    if (-not (Test-Path $cacheFile)) {
        New-Item -Path $cacheFile -ItemType File -Force | Out-Null
    }

    $cache = Get-Content $cacheFile

    if ($ParentSearch) {
        $currentPath = Get-Location
        $parentPaths = while ($currentPath.Parent) {
            $currentPath = $currentPath.Parent
            $currentPath.Path
        }

        $match = $cache | Where-Object { $parentPaths -contains $_ -and $_ -like "*$SearchPath*" } | Select-Object -First 1
    } elseif ($ChildSearch) {
        $currentPath = (Get-Location).Path
        $match = $cache | Where-Object { $_.StartsWith($currentPath) -and $_ -like "*$SearchPath*" } | Select-Object -First 1
	else {
		$currentDrive = (Get-Location).Drive.Name + ":"
		$cache = $cache | Where-Object { $_.StartsWith($currentDrive) }
		$match = $cache | Where-Object { $_ -like "*$SearchPath*" } |
				 Sort-Object { $_.Length } | Select-Object -First 1
	}

    if ($match -and (Test-Path $match)) {
        Update-Cache $match
        return $match
    } elseif ($match) {
        $cache = $cache | Where-Object { $_ -ne $match }
        $cache | Set-Content $cacheFile
    }

    if ($ParentSearch) {
        $currentPath = Get-Location
        while ($currentPath.Parent) {
            $currentPath = $currentPath.Parent
            if ($currentPath.Path -like "*$SearchPath*") {
                Update-Cache $currentPath.Path
                return $currentPath.Path
            }
        }
    } elseif ($ChildSearch) {
        $queue = New-Object System.Collections.Generic.Queue[System.IO.DirectoryInfo]
        $queue.Enqueue((Get-Location))

        while ($queue.Count -gt 0) {
            $current = $queue.Dequeue()
            if ($current.FullName -like "*$SearchPath*") {
                Update-Cache $current.FullName
                return $current.FullName
            }

            try {
                foreach ($subDir in $current.GetDirectories()) {
                    $queue.Enqueue($subDir)
                }
            }
            catch { }
        }
    } elseif ($SearchAllDrives) {
        $drivesToSearch = Get-PSDrive -PSProvider 'FileSystem' | Select-Object -ExpandProperty Name | Sort-Object
        foreach ($drive in $drivesToSearch) {
            $root = Get-Item -Path "$($drive):"
            $queue = New-Object System.Collections.Generic.Queue[System.IO.DirectoryInfo]
            $queue.Enqueue($root)

            while ($queue.Count -gt 0) {
                $current = $queue.Dequeue()
                if ($current.FullName -like "*$SearchPath*") {
                    Update-Cache $current.FullName
                    return $current.FullName
                }

                try {
                    foreach ($subDir in $current.GetDirectories()) {
                        $queue.Enqueue($subDir)
                    }
                }
                catch { }
            }
        }
    } else {
		$drivesToSearch = if ($SearchAllDrives) { Get-PSDrive -PSProvider 'FileSystem' | Select-Object -ExpandProperty Name | Sort-Object | Where-Object { $_ -ne $currentDrive.Trim(':') } | ForEach-Object { "$_:" } } else { $currentDrive }
		foreach ($drive in $drivesToSearch) {
			$root = Get-Item -Path $drive
			$queue = New-Object System.Collections.Generic.Queue[System.IO.DirectoryInfo]
			$queue.Enqueue($root)

			while ($queue.Count -gt 0) {
				$current = $queue.Dequeue()
				if ($current.FullName -like "*$SearchPath*") {
					Update-Cache $current.FullName
					return $current.FullName
				}

				try {
					foreach ($subDir in $current.GetDirectories()) {
						$queue.Enqueue($subDir)
					}
				}
				catch { }
			}
		}
	}
	
    return $null
}