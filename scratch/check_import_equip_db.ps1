$importPaths = Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\rathena\db" -Recurse -Include "item_db*.yml"

foreach ($f in $importPaths) {
    Write-Host "Found file: $($f.FullName) ($($f.Length) bytes)"
}
