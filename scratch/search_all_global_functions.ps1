Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc\custom"

Get-ChildItem -Path "." -Recurse -Filter "*.txt" | ForEach-Object {
    $m = Select-String -Path $_.FullName -Pattern "F_EinherjarWeaponMenu|F_ValkyrieReroll"
    if ($m) {
        foreach ($match in $m) {
            Write-Host "$($_.FullName): Line $($match.LineNumber): $($match.Line)"
        }
    }
}
