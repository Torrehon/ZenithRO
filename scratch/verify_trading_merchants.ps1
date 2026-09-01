$files = @(
    "d:\SERVER_RO\LevitationRO\rathena\npc\pre-re\merchants\shops.txt",
    "d:\SERVER_RO\LevitationRO\rathena\npc\re\merchants\shops.txt"
)

foreach ($f in $files) {
    Write-Host "=== $f ==="
    $lines = Get-Content -Path $f
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "Trading Merchant") {
            Write-Host "Line $($i+1): $($lines[$i])"
        }
    }
}
