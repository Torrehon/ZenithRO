$etcDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"
$text = Get-Content -Path $etcDb -Raw

for ($id = 50010; $id -le 50099; $id++) {
    if (-not ($text -match "Id:\s*$id\b")) {
        Write-Host "First free ID: $id"
        break
    }
}
