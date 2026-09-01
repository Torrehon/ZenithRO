$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\quest_db.yml"
$bytes = [System.IO.File]::ReadAllBytes($path)

$crCount = 0
$lfCount = 0

for ($i = 0; $i -lt $bytes.Length; $i++) {
    if ($bytes[$i] -eq 13) { $crCount++ }
    if ($bytes[$i] -eq 10) { $lfCount++ }
}

Write-Host "CR (\\r) count: $crCount"
Write-Host "LF (\\n) count: $lfCount"

# Let's check original from git
$gitBytes = [System.Text.Encoding]::UTF8.GetBytes((git show HEAD:rathena/db/pre-re/quest_db.yml))
$gitCrCount = 0
$gitLfCount = 0
for ($i = 0; $i -lt $gitBytes.Length; $i++) {
    if ($gitBytes[$i] -eq 13) { $gitCrCount++ }
    if ($gitBytes[$i] -eq 10) { $gitLfCount++ }
}
Write-Host "Git HEAD CR (\\r) count: $gitCrCount"
Write-Host "Git HEAD LF (\\n) count: $gitLfCount"
