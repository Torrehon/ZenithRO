$files = Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\ZenithRO" -Recurse -File

foreach ($f in $files) {
    if ($f.Name -like "*quest*" -or $f.Name -like "*Quest*") {
        Write-Host "$($f.FullName)"
    }
}
