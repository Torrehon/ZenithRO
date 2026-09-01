Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

Write-Host "=== Searching for soul_quest1, soul_molder, prt_prison ==="
Get-ChildItem -Path "." -Recurse -Include "*.txt" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "soul_quest|soul_molder|prt_prison|Soul Molder|Soul_Quest"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}
