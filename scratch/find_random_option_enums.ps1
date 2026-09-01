Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src"

Select-String -Path "map\itemdb.hpp","map\itemdb.cpp","common\mmo.hpp" -Pattern "VAR_INDES|VAR_DUR|VAR_ARMOR|RDM_OPT|e_item_option" | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
