Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Select-String -Path "item_randomopt_db.yml","pre-re\item_randomopt_db.yml" -Pattern "INDES|DURA|UNBREAK|ARMOR|WEAPON" -Context 2,5 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
