Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

Get-ChildItem -Path "." -Recurse -Filter "*.txt" | ForEach-Object {
    $m = Select-String -Path $_.FullName -Pattern "1@4tro|1@exse|1@exnw|prt_prison|Pantheon|pantheon|comprobante"
    if ($m) {
        foreach ($match in $m) {
            Write-Host "$($_.FullName): Line $($match.LineNumber): $($match.Line)"
        }
    }
}
