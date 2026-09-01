$files = @(
    "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_usable.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\re\item_db_usable.yml"
)

foreach ($f in $files) {
    Write-Host "=== $f ==="
    $lines = Get-Content -Path $f
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "22876" -or $lines[$i] -match "Shabby_Purse") {
            Write-Host "Line $($i+1): $($lines[$i])"
            for ($j = [Math]::Max(0, $i-2); $j -le [Math]::Min($lines.Length-1, $i+8); $j++) {
                Write-Host "   $($lines[$j])"
            }
        }
    }
}
