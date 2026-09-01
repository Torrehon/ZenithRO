Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc\custom"

Get-ChildItem -Path "." -Filter "*.txt" | ForEach-Object {
    $path = $_.FullName
    $lines = Get-Content -Path $path
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "F_HasDawnWeaponEquipped") {
            Write-Host "$($_.Name): Line $($i+1): $($lines[$i])"
        }
    }
}
