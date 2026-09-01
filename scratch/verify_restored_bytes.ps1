$target1 = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$target2 = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\LuaFiles514\itemInfo.lua"

foreach ($t in @($target1, $target2)) {
    $bytes = [System.IO.File]::ReadAllBytes($t)
    Write-Host "$t -> $($bytes.Length) bytes"
}
