$lubAdd = Get-Content -Path "scratch/lub_output.txt" -Raw -Encoding UTF8
$clsPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
$clsText = Get-Content -Path $clsPath -Raw -Encoding UTF8

$qids = [System.Collections.Generic.List[int]]::new()
70001..70021 | ForEach-Object { $qids.Add($_) }
70101..70121 | ForEach-Object { $qids.Add($_) }
70201..70218 | ForEach-Object { $qids.Add($_) }
70301..70316 | ForEach-Object { $qids.Add($_) }

$classList = [System.Collections.Generic.List[string]]::new()
$classList.Add("`n-- Custom Hunting Quests Classification")
$classList.Add("if QuestClassificationList == nil then QuestClassificationList = {} end")

foreach ($qid in $qids) {
    $classList.Add("QuestClassificationList[$qid] = 2 -- Daily Quest")
}

$classStr = $classList -join "`n"

if ($clsText -match "(?s)(.*?\n\t\[80021\].*?\n\t\})(.*)") {
    $before = $matches[1]
    $after = $matches[2]
    $newCls = $before + ",`n" + $lubAdd + $after + "`n" + $classStr
    Set-Content -Path $clsPath -Value $newCls -Encoding UTF8
    Write-Host "OngoingQuests_CLS.lub updated cleanly!"
} else {
    Write-Host "Regex match failed for OngoingQuests_CLS.lub"
}
