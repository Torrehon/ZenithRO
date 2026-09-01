Set-Location -Path "d:\SERVER_RO\LevitationRO\ZenithRO"
$log = git log -n 50 --oneline -- "SystemEN/itemInfo.lua" "SystemEN/LuaFiles514/itemInfo.lua"
Write-Host "Git log for itemInfo files in ZenithRO:"
Write-Host $log

if (-not $log) {
    Write-Host "No commits in ZenithRO git log for SystemEN/itemInfo.lua. Checking git status / git diff..."
    git status
}
