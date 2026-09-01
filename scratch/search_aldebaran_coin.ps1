$etcDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"
$text = Get-Content -Path $etcDb -Raw

if ($text -match "(?i)aldebaran_coin|aldebaran coin") {
    Write-Host "Found in item_db_etc.yml!"
} else {
    Write-Host "NOT found in item_db_etc.yml."
}

$itemInfo = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lub"
if (Test-Path $itemInfo) {
    $infoText = Get-Content -Path $itemInfo -Raw
    if ($infoText -match "(?i)aldebaran") {
        Write-Host "Found in itemInfo.lub!"
    } else {
        Write-Host "NOT found in itemInfo.lub."
    }
}
