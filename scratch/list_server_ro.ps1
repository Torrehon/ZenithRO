Get-ChildItem -Path "d:\SERVER_RO" | ForEach-Object {
    Write-Host "$($_.FullName) - IsDir: $($_.PSIsContainer)"
}
