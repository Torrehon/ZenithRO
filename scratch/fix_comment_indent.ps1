$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\quest_db.yml"
$content = Get-Content -Path $path -Raw -Encoding UTF8

$oldStr = "# Custom Hunting Quests System"
$newStr = "  # Custom Hunting Quests System"

if ($content.Contains($oldStr)) {
    $content = $content.Replace($oldStr, $newStr)
    Set-Content -Path $path -Value $content -Encoding UTF8
    Write-Host "Replaced unindented comment successfully!"
} else {
    Write-Host "Comment not found or already fixed."
}
