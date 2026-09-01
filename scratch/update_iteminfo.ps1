$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$lines = Get-Content $path -Encoding UTF8

$startIndex = -1
$endIndex = -1

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*\[5383\]\s*=\s*\{') {
        $startIndex = $i
    }
    if ($startIndex -ge 0 -and $lines[$i] -match '^\s*costume\s*=\s*false') {
        # find closing brace
        for ($j = $i; $j -lt $lines.Count; $j++) {
            if ($lines[$j] -match '^\s*\},?') {
                $endIndex = $j
                break
            }
        }
        break
    }
}

if ($startIndex -ge 0 -and $endIndex -ge 0) {
    $replacement = @(
        "`t[5383] = {",
        "`t`tunidentifiedDisplayName = `"Hat`",",
        "`t`tunidentifiedResourceName = `"캡`",",
        "`t`tunidentifiedDescriptionName = {",
        "`t`t`t`"Unknown Item, can be identified by using a ^6666CCMagnifier^000000.`"",
        "`t`t},",
        "`t`tidentifiedDisplayName = `"Hunter's Cap`",",
        "`t`tidentifiedResourceName = `"사냥모`",",
        "`t`tidentifiedDescriptionName = {",
        "`t`t`t`"A sturdy hat designed for wilderness trackers and trap specialists.`"",
        "`t`t`t`"_______________________`"",
        "`t`t`t`"Int +1`"",
        "`t`t`t`"Dex +1`"",
        "`t`t`t`"Increases Traps damage by 1% per Refine Level.`"",
        "`t`t`t`"_______________________`"",
        "`t`t`t`"When equipped with ^990099Camouflage Backpack^000000:`"",
        "`t`t`t`"2% * Refine Level to proc statuses with:`"",
        "`t`t`t`"- Claymore Trap: Burning`"",
        "`t`t`t`"- Land Mine: Buried`"",
        "`t`t`t`"- Blast Mine: Electrocute`"",
        "`t`t`t`"- Freezing Trap: Freeze`"",
        "`t`t`t`"_______________________`"",
        "`t`t`t`"Class:^6666CC Headgear^000000`"",
        "`t`t`t`"Defense:^0000FF 3^000000`"",
        "`t`t`t`"Position:^6666CC Upper^000000`"",
        "`t`t`t`"Weight:^009900 250^000000`"",
        "`t`t`t`"Level Requirement:^009900 60^000000`"",
        "`t`t`t`"Jobs:^6666CC All except Novice Class^000000`"",
        "`t`t},",
        "`t`tslotCount = 1,",
        "`t`tClassNum = 389,",
        "`t`tcostume = false",
        "`t},",
        "`t[20581] = {",
        "`t`tunidentifiedDisplayName = `"Garment`",",
        "`t`tunidentifiedResourceName = `"망토`",",
        "`t`tunidentifiedDescriptionName = {",
        "`t`t`t`"Unknown Item, can be identified by using a ^6666CCMagnifier^000000.`"",
        "`t`t},",
        "`t`tidentifiedDisplayName = `"Camouflage Backpack`",",
        "`t`tidentifiedResourceName = `"배낭`",",
        "`t`tidentifiedDescriptionName = {",
        "`t`t`t`"A rugged backpack crafted with camouflage pattern for hunters in the wild.`"",
        "`t`t`t`"_______________________`"",
        "`t`t`t`"Int +1`"",
        "`t`t`t`"1% * Refine Level chance to obtain Trap when killing monsters.`"",
        "`t`t`t`"_______________________`"",
        "`t`t`t`"When equipped with ^990099Hunter's Cap^000000:`"",
        "`t`t`t`"2% * Refine Level to proc statuses with:`"",
        "`t`t`t`"- Claymore Trap: Burning`"",
        "`t`t`t`"- Land Mine: Buried`"",
        "`t`t`t`"- Blast Mine: Electrocute`"",
        "`t`t`t`"- Freezing Trap: Freeze`"",
        "`t`t`t`"_______________________`"",
        "`t`t`t`"Class:^6666CC Garment^000000`"",
        "`t`t`t`"Defense:^0000FF 2^000000`"",
        "`t`t`t`"Position:^6666CC Garment^000000`"",
        "`t`t`t`"Weight:^009900 50^000000`"",
        "`t`t`t`"Level Requirement:^009900 60^000000`"",
        "`t`t`t`"Jobs:^6666CC All except Novice Class^000000`"",
        "`t`t},",
        "`t`tslotCount = 1,",
        "`t`tClassNum = 59,",
        "`t`tcostume = false",
        "`t},"
    )

    $newLines = $lines[0..($startIndex - 1)] + $replacement + $lines[($endIndex + 1)..($lines.Count - 1)]
    [System.IO.File]::WriteAllLines($path, $newLines, (New-Object System.Text.UTF8Encoding $false))
    Write-Host "itemInfo.lua updated successfully!"
} else {
    Write-Host "Item 5383 not found in itemInfo.lua!"
}
