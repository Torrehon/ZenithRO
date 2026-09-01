$prerePath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_usable.yml"
$lines = Get-Content -Path $prerePath

$found = $false
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "22876" -or $lines[$i] -match "Shabby_Purse") {
        Write-Host "Found in pre-re item_db_usable.yml at line $($i+1): $($lines[$i])"
        $found = $true
        for ($j = [Math]::Max(0, $i-2); $j -le [Math]::Min($lines.Length-1, $i+10); $j++) {
            Write-Host "   $($lines[$j])"
        }
    }
}

if (-not $found) {
    Write-Host "ID 22876 / Shabby_Purse NOT found in pre-re/item_db_usable.yml!"
}
