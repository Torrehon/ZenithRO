$lubAdd = Get-Content -Path "scratch/lub_output.txt" -Raw -Encoding UTF8

# 1. Update SystemEN/OngoingQuests_CLS.lub
$clsPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
$clsText = Get-Content -Path $clsPath -Raw -Encoding UTF8

if ($clsText -match "\n\}\s*$") {
    # Replace QuestInfoList_C with QuestInfoList_CLS if needed
    $clsAdd = $lubAdd.Replace("QuestInfoList_C", "QuestInfoList_CLS")
    $newCls = $clsText -replace "\n\}\s*$", ("`n`n" + $clsAdd + "`n}`n")
    Set-Content -Path $clsPath -Value $newCls -Encoding UTF8
    Write-Host "OngoingQuests_CLS.lub updated successfully!"
} else {
    Write-Host "Pattern match failed for OngoingQuests_CLS.lub"
}

# 2. Update SystemEN/OngoingQuests.lub
$ogPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub"
$ogText = Get-Content -Path $ogPath -Raw -Encoding UTF8

if ($ogText -match "\n\}\s*$") {
    $newOg = $ogText -replace "\n\}\s*$", ("`n`n" + $lubAdd + "`n}`n")
    Set-Content -Path $ogPath -Value $newOg -Encoding UTF8
    Write-Host "OngoingQuests.lub updated successfully!"
} else {
    Write-Host "Pattern match failed for OngoingQuests.lub"
}
