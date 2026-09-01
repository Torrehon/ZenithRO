$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\achievement_db.yml"
$lines = Get-Content -Path $path

$count = 0
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "Item:\s*Shabby_Purse") {
        $count++
        Write-Host "Achievement #$count at line $($i+1):"
        for ($j = [Math]::Max(0, $i-6); $j -le [Math]::Min($lines.Length-1, $i+3); $j++) {
            Write-Host "   $($lines[$j])"
        }
    }
}
Write-Host "Total achievements with Shabby_Purse: $count"
