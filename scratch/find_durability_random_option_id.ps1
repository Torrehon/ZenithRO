Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Select-String -Path "db\pre-re\item_options.yml","db\re\item_options.yml","db\item_options.yml","src\map\itemdb.hpp" -Pattern "INDES|DURA|UNBREAK|BREAK" | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
