Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

Get-ChildItem -Path "." -Recurse -Include "*.txt" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "PRT_PRISON_QUEST"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}
