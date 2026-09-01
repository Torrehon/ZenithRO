$files = @(
    "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_molder.txt",
    "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt",
    "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt",
    "d:\SERVER_RO\LevitationRO\rathena\npc\custom\prt_prison_access.txt"
)

foreach ($f in $files) {
    if (Test-Path $f) {
        Write-Host "=== Searching job checks in $f ==="
        $lines = Get-Content -Path $f
        for ($i = 0; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -match "BaseJob|Job_|Class|Job_Ninja|Job_Gunslinger|SOUL_QUEST") {
                if ($lines[$i] -match "BaseJob" -or $lines[$i] -match "Job_" -or $lines[$i] -match "Class ==|Class >=") {
                    Write-Host "Line $($i+1): $($lines[$i])"
                }
            }
        }
    }
}
