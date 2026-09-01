$infoC = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo_C.lua"
$text = Get-Content -Path $infoC -Raw

if ($text -match "\[50003\]") {
    Write-Host "Found 50003 in itemInfo_C.lua!"
    $lines = Get-Content -Path $infoC
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "\[50003\]") {
            for ($j = 0; $j -le 15; $j++) {
                Write-Host $lines[$i+$j]
            }
        }
    }
} else {
    Write-Host "50003 NOT found in itemInfo_C.lua"
}
