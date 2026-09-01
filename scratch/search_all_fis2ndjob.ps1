Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

Get-ChildItem -Path "." -Recurse -Include "*.txt" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "F_Is2ndJob"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}
