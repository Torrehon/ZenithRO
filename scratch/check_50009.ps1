$etcDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"
$text = Get-Content -Path $etcDb -Raw

if ($text -match "50009") {
    Write-Host "50009 is ALREADY used!"
} else {
    Write-Host "50009 is FREE to use for Aldebaran Coin!"
}
