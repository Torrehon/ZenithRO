Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

Get-ChildItem -Path "." -Recurse -Filter "*.txt" | ForEach-Object {
    $m = Select-String -Path $_.FullName -Pattern "4501|4502|Genin|Hiregun|JOB_GENIN|JOB_HIREGUN"
    if ($m) {
        foreach ($match in $m) {
            Write-Host "$($_.FullName): Line $($match.LineNumber): $($match.Line)"
        }
    }
}
