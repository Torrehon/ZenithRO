Set-Location -Path "C:\xampp\mysql\bin"

Write-Host "=== Repairing all MyISAM tables in C:\xampp\mysql\data\rathena ==="
Get-ChildItem -Path "C:\xampp\mysql\data\rathena\*.MYI" | ForEach-Object {
    Write-Host "Checking/Repairing $($_.Name) ..."
    .\myisamchk.exe -r $_.FullName
}
