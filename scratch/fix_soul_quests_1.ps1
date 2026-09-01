$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$soulFile = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"

$content = [System.IO.File]::ReadAllText($soulFile)

# 1. Replace checkquest(90004) >= 1 with checkquest(90004) == 2 in all Einherjar restoration blocks
# This prevents active quest (checkquest 90004 == 1) from bypassing the item 50020 requirement!
$content = $content.Replace("checkquest(90004) >= 1", "checkquest(90004) == 2")

[System.IO.File]::WriteAllText($soulFile, $content, $utf8NoBom)
Write-Host "Updated checkquest(90004) == 2 in restoration blocks!"
