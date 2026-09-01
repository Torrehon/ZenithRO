$files = @(
    "d:\SERVER_RO\LevitationRO\rathena\npc\quests\hunting_quests\hunting_prontera.txt",
    "d:\SERVER_RO\LevitationRO\rathena\npc\quests\hunting_quests\hunting_geffen.txt",
    "d:\SERVER_RO\LevitationRO\rathena\npc\quests\hunting_quests\hunting_morroc.txt",
    "d:\SERVER_RO\LevitationRO\rathena\npc\quests\hunting_quests\hunting_payon.txt",
    "d:\SERVER_RO\LevitationRO\rathena\npc\quests\hunting_quests\hunting_aldebaran.txt"
)

foreach ($f in $files) {
    Write-Host "=== $f ==="
    $lines = Get-Content -Path $f
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "51009") {
            Write-Host "Line $($i+1): $($lines[$i])"
        }
    }
}
