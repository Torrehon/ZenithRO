$backupPath = "d:\SERVER_RO\LevitationRO\scratch\extracted_backup\itemInfo.lua"
$targetPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$enc = [System.Text.Encoding]::GetEncoding(949)

$lines = [System.IO.File]::ReadAllLines($backupPath, $enc)

$start5383 = -1
$end5383 = -1

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*\[5383\]\s*=\s*\{') {
        $start5383 = $i
        for ($j = $i; $j -lt $lines.Count; $j++) {
            if ($lines[$j] -match '^\s*\},?\s*$') {
                $end5383 = $j
                break
            }
        }
        break
    }
}

$start20580 = -1
$end20580 = -1

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*\[20520\]\s*=\s*\{') {
        $start20580 = $i
        for ($j = $i; $j -lt $lines.Count; $j++) {
            if ($lines[$j] -match '^\s*\},?\s*$') {
                $end20580 = $j
                break
            }
        }
        break
    }
}

$new5383 = @(
    "`t[5383] = {",
    "`t`tunidentifiedDisplayName = `"Hat`",",
    "`t`tunidentifiedResourceName = `"캡`",",
    "`t`tunidentifiedDescriptionName = {",
    "`t`t`t`"Unknown Item, can be identified by using a ^6666CCMagnifier^000000.`"",
    "`t`t},",
    "`t`tidentifiedDisplayName = `"Hunter's Cap`",",
    "`t`tidentifiedResourceName = `"사냥모`",",
    "`t`tidentifiedDescriptionName = {",
    "`t`t`t`"A sturdy hat designed for wilderness trackers and trap specialists.`",",
    "`t`t`t`"_______________________`",",
    "`t`t`t`"Int +1`",",
    "`t`t`t`"Dex +1`",",
    "`t`t`t`"Increases Traps damage by 1% per Refine Level.`",",
    "`t`t`t`"_______________________`",",
    "`t`t`t`"When equipped with ^990099Camouflage Backpack^000000:`",",
    "`t`t`t`"2% * Refine Level to proc statuses with:`",",
    "`t`t`t`"- Claymore Trap: Burning`",",
    "`t`t`t`"- Land Mine: Buried`",",
    "`t`t`t`"- Blast Mine: Electrocute`",",
    "`t`t`t`"- Freezing Trap: Freeze`",",
    "`t`t`t`"_______________________`",",
    "`t`t`t`"Class:^6666CC Headgear^000000`",",
    "`t`t`t`"Defense:^0000FF 3`",",
    "`t`t`t`"Position:^6666CC Upper^000000`",",
    "`t`t`t`"Weight:^009900 250`",",
    "`t`t`t`"Level Requirement:^009900 60`",",
    "`t`t`t`"Jobs:^6666CC All except Novice Class^000000`"",
    "`t`t},",
    "`t`tslotCount = 1,",
    "`t`tClassNum = 389,",
    "`t`tcostume = false",
    "`t},"
)

$new20581 = @(
    "`t[20581] = {",
    "`t`tunidentifiedDisplayName = `"Garment`",",
    "`t`tunidentifiedResourceName = `"망토`",",
    "`t`tunidentifiedDescriptionName = {",
    "`t`t`t`"Unknown Item, can be identified by using a ^6666CCMagnifier^000000.`"",
    "`t`t},",
    "`t`tidentifiedDisplayName = `"Camouflage Backpack`",",
    "`t`tunidentifiedResourceName = `"배낭`",",
    "`t`tidentifiedDescriptionName = {",
    "`t`t`t`"A rugged backpack crafted with camouflage pattern for hunters in the wild.`",",
    "`t`t`t`"_______________________`",",
    "`t`t`t`"Int +1`",",
    "`t`t`t`"1% * Refine Level chance to obtain Trap when killing monsters.`",",
    "`t`t`t`"_______________________`",",
    "`t`t`t`"When equipped with ^990099Hunter's Cap^000000:`",",
    "`t`t`t`"2% * Refine Level to proc statuses with:`",",
    "`t`t`t`"- Claymore Trap: Burning`",",
    "`t`t`t`"- Land Mine: Buried`",",
    "`t`t`t`"- Blast Mine: Electrocute`",",
    "`t`t`t`"- Freezing Trap: Freeze`",",
    "`t`t`t`"_______________________`",",
    "`t`t`t`"Class:^6666CC Garment^000000`",",
    "`t`t`t`"Defense:^0000FF 2`",",
    "`t`t`t`"Position:^6666CC Garment^000000`",",
    "`t`t`t`"Weight:^009900 50`",",
    "`t`t`t`"Level Requirement:^009900 60`",",
    "`t`t`t`"Jobs:^6666CC All except Novice Class^000000`"",
    "`t`t},",
    "`t`tslotCount = 1,",
    "`t`tClassNum = 59,",
    "`t`tcostume = false",
    "`t},"
)

$result = @()
$result += $lines[0..($start5383 - 1)]
$result += $new5383
$result += $lines[($end5383 + 1)..$start20580]
$result += $lines[$start20580..$end20580]
$result += $new20581
$result += $lines[($end20580 + 1)..($lines.Count - 1)]

[System.IO.File]::WriteAllLines($targetPath, $result, $enc)
Write-Host "Successfully restored backup and updated itemInfo.lua with CP949 encoding!"
