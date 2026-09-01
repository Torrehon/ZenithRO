$path1 = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$path2 = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\LuaFiles514\itemInfo.lua"

foreach ($p in @($path1, $path2)) {
    if (Test-Path $p) {
        $bytes = [System.IO.File]::ReadAllBytes($p)
        Write-Host "File $p - Size: $($bytes.Length) bytes"
        if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
            Write-Host "  Encoding: UTF-8 with BOM"
        } else {
            Write-Host "  Encoding: No BOM (Raw bytes)"
        }
    }
}
