# PowerShell eXtreme Directory

<img src="https://github.com/PrimeEagle/PowerShell-eXtreme-Directory/blob/main/extreme%20directory.png?raw=true" width="250" />

Fast directory changing from the console, with pattern matching and caching. Ideal for developers who spend a lot of time in the console.

### Usage
```
x    -  change directory to any match, using top-down breadth-wise search on current drive
xc   -  change directory to any child directory match, using top-down breadth-wise search within current directory
xp   -  change directory to any parent directory match,  using bottom-up search from the current directory
xe   -  same as "x", but instead of changing the directory it opens it in File Explorer
xce  -  same as "xc", but instead of changing the directory it opens it in File Explorer
xpe  -  same as "xp", but instead of changing the directory it opens it in File Explorer
xb   -  same as "x", but in addition to changing the directory, it also opens it in File Explorer
xcb  -  same as "xc", but in addition to changing the directory it also opens it in File Explorer
xpb  -  same as "xp", but in addition to changing the directory it also it in File Explorer
```

### Setup
In each .ps1 file, edit the following variables at the top:
```
$cacheFile  - the full path to the text file to use for a cache. File does not have to exist.
              All scripts can share the same cache file, or have diferent ones,
              depending on what you prefer.
$cacheLimit - the number of items to keep in the cach (default is 1000)
```
