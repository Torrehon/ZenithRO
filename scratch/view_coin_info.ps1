$infoLua = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$lines = Get-Content -Path $infoLua

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "\[5000[3-8]\]") {
        for ($j = 0; $j -le 16; $j++) {
            Write-Host $lines[$i+$j]
        }
        Write-Host "---"
    }
}
