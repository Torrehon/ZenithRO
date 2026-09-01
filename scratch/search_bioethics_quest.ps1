Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

Write-Host "=== Searching for 238 or Bioethics or ALCH_SKILL in npc/ ==="
Select-String -Path "*.txt","**/*.txt" -Pattern "238|Bioethics|ALCH_SKILL|AM_BIOETHICS" -Context 1,3 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
