$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# 1. Update/Add item 22876 (Shabby_Purse) in pre-re/item_db_usable.yml
$prereItemDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_usable.yml"
$prereItemText = [System.IO.File]::ReadAllText($prereItemDb)

$shabbyBlock = @"
  - Id: 22876
    AegisName: Shabby_Purse
    Name: Old Money Pocket
    Type: Usable
    Weight: 10
    Script: |
      specialeffect2 EF_STEAL;
      Zeny += rand(5000, 10000);
"@

if (-not $prereItemText.Contains("22876")) {
    $cleanPrereItemText = $prereItemText.TrimEnd() + "`n" + $shabbyBlock + "`n"
    [System.IO.File]::WriteAllText($prereItemDb, $cleanPrereItemText, $utf8NoBom)
    Write-Host "Added Shabby_Purse (22876) with 5k-10k Zeny script to pre-re/item_db_usable.yml!"
} else {
    Write-Host "Item 22876 already present in pre-re/item_db_usable.yml"
}

# 2. Update item 22876 in re/item_db_usable.yml
$reItemDb = "d:\SERVER_RO\LevitationRO\rathena\db\re\item_db_usable.yml"
$reItemText = [System.IO.File]::ReadAllText($reItemDb)

if ($reItemText.Contains("AegisName: Shabby_Purse")) {
    $oldScript = "Zeny += rand(100,1000);"
    $newScript = "Zeny += rand(5000, 10000);"
    if ($reItemText.Contains($oldScript)) {
        $updatedReText = $reItemText.Replace($oldScript, $newScript)
        [System.IO.File]::WriteAllText($reItemDb, $updatedReText, $utf8NoBom)
        Write-Host "Updated Shabby_Purse script to 5k-10k Zeny in re/item_db_usable.yml!"
    }
}

# 3. Uncomment Shabby_Purse rewards in pre-re/achievement_db.yml and re/achievement_db.yml
$achFiles = @(
    "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\achievement_db.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\re\achievement_db.yml"
)

foreach ($achPath in $achFiles) {
    if (Test-Path $achPath) {
        $achText = [System.IO.File]::ReadAllText($achPath)
        
        $oldRewardPattern1 = "       #Rewards:`r`n       #  Item: Shabby_Purse"
        $newRewardPattern1 = "       Rewards:`r`n         Item: Shabby_Purse"
        
        $oldRewardPattern2 = "       #Rewards:`n       #  Item: Shabby_Purse"
        $newRewardPattern2 = "       Rewards:`n         Item: Shabby_Purse"
        
        $replacedCount = 0
        if ($achText.Contains("#Rewards:")) {
            $updatedAchText = $achText.Replace($oldRewardPattern1, $newRewardPattern1).Replace($oldRewardPattern2, $newRewardPattern2)
            [System.IO.File]::WriteAllText($achPath, $updatedAchText, $utf8NoBom)
            Write-Host "Uncommented Shabby_Purse rewards in $achPath!"
        } else {
            Write-Host "No commented rewards found in $achPath."
        }
    }
}
