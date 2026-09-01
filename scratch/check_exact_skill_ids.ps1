Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

$skillsToFind = @(
    "NPC_COMBOATTACK",
    "NPC_CRITICALSLASH",
    "NPC_CRITICALWOUND",
    "NPC_WIDEPOISON",
    "ASC_METEORASSAULT",
    "ASC_SOULBREAKER",
    "NPC_WIDEBLEEDING",
    "NPC_PULSESTRIKE",
    "NPC_POWERUP",
    "NPC_AGIUP"
)

$skillDbFile = "pre-re\skill_db.yml"

Write-Host "=== Searching skill_db.yml for exact Skill IDs ==="
foreach ($sk in $skillsToFind) {
    $matches = Select-String -Path $skillDbFile -Pattern "  - Id: (\d+)" -Context 0,2 | Where-Object { $_.Context.PostContext -match "Name: $sk" }
    foreach ($m in $matches) {
        Write-Host "$sk -> $($m.Line)"
    }
}
