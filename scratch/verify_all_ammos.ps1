$prereEtc = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"
$reEtc    = "d:\SERVER_RO\LevitationRO\rathena\db\re\item_db_etc.yml"

$ids = 13200..13232 + 50021..50022

Write-Host "=== All Ammo IDs Status ==="
foreach ($id in $ids) {
    $inPrere = (Select-String -Path $prereEtc -Pattern "^\s*-\s*Id:\s*$id\b") -ne $null
    $inRe    = (Select-String -Path $reEtc -Pattern "^\s*-\s*Id:\s*$id\b") -ne $null
    
    $name = ""
    if ($inPrere) {
        $lines = Get-Content $prereEtc
        for ($i = 0; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -match "^\s*-\s*Id:\s*$id\b") {
                $name = $lines[$i+2].Replace("Name:", "").Trim()
                break
            }
        }
    } elseif ($inRe) {
        $lines = Get-Content $reEtc
        for ($i = 0; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -match "^\s*-\s*Id:\s*$id\b") {
                $name = $lines[$i+2].Replace("Name:", "").Trim()
                break
            }
        }
    }
    
    Write-Host "ID $id : Name '$name' | Pre-RE: $inPrere | RE: $inRe"
}
