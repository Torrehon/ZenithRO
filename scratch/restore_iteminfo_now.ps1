$extracted = "d:\SERVER_RO\LevitationRO\scratch\extracted_backup\itemInfo.lua"
$target1   = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$target2   = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\LuaFiles514\itemInfo.lua"

Copy-Item -Path $extracted -Destination $target1 -Force
Copy-Item -Path $extracted -Destination $target2 -Force

Write-Host "Restored original itemInfo.lua from zip backup to both ZenithRO locations!"
