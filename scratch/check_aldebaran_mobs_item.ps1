$mobDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_db.yml"
$mobText = Get-Content -Path $mobDb -Raw

$mobIds = @(1053, 1044, 1100, 1118, 1215, 1099, 1155, 1102, 1199, 1369, 1195, 1193, 1269)

foreach ($id in $mobIds) {
    if ($mobText -match "(?m)^\s*-\s*Id:\s*$id\s*\r?\n\s*AegisName:\s*(\w+)") {
        Write-Host "Mob $id -> AegisName: $($matches[1])"
    } else {
        Write-Host "Mob $id -> AegisName NOT FOUND!"
    }
}

# Check Aldebaran Coin in item_db
$itemDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db.yml"
$itemText = Get-Content -Path $itemDb -Raw

for ($itemId = 50001; $itemId -le 50010; $itemId++) {
    if ($itemText -match "(?m)^\s*-\s*Id:\s*$itemId\s*\r?\n\s*AegisName:\s*(\w+)") {
        Write-Host "Item $itemId -> AegisName: $($matches[1])"
    }
}
