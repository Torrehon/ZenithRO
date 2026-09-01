$path = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"
$lines = Get-Content -Path $path

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "gef_fild07|1@4tro|1@exse|1@exnw|warp ") {
        Write-Host "Line $($i+1): $($lines[$i])"
    }
}
