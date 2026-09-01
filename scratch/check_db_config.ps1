Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\conf"

Write-Host "=== Checking inter_athena.conf and char_athena.conf ==="
Get-ChildItem -Path "." -Recurse -Include "*.conf" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "login_server_|char_server_|sql_|db_name|save_log|reset"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}
