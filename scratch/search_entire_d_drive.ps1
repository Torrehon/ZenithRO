Get-ChildItem -Path "D:\" -Recurse -Filter "*itemInfo*" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "$($_.FullName) - Size: $($_.Length) bytes"
}
