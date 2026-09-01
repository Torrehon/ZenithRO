Set-Location -Path "d:\SERVER_RO\LevitationRO"

Write-Host "=== Searching git log for drop / card / mi commits ==="
git log --grep="drop" --oneline
git log --grep="card" --oneline
git log -p -n 10 -- conf/battle/drops.conf
