$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub"
$text = [System.IO.File]::ReadAllText($path)

$oldStr = "`t`tSummary = `"`"`n`t}`n`n`t-- Prontera Hunting Quests"
$newStr = "`t`tSummary = `"`"`n`t},`n`n`t-- Prontera Hunting Quests"

if ($text.Contains($oldStr)) {
    $newText = $text.Replace($oldStr, $newStr)
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($path, $newText, $utf8NoBom)
    Write-Host "Fixed missing comma in OngoingQuests.lub successfully!"
} else {
    Write-Host "Pattern not found in OngoingQuests.lub!"
}
