Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== Inspecting custom random options in mob.cpp ==="
Select-String -Path "mob.cpp" -Pattern "random_option|option|set_option|pc_apply|RND_|243" -Context 1,8 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}

Write-Host "`n=== Searching all cpp files for custom random option functions ==="
Select-String -Path "*.cpp","skills\*\*.cpp" -Pattern "random_option|CUSTOM.*OPTION|custom_option" -Context 0,2 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
