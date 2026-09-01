$files = Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\rathena\db" -Recurse -Filter "*item*"

foreach ($f in $files) {
    $text = Get-Content -Path $f.FullName -Raw
    if ($text -match "50003") {
        Write-Host "Found 50003 in $($f.FullName)"
    }
}
