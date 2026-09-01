Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Select-String -Path "skill.cpp","pc.cpp","skills\thief\remover.cpp","skills\thief\snatch.cpp" -Pattern "RG_SUPPORT_PLAGIARISM|support_plagiarism" -Context 2,15 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
