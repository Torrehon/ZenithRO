$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\data\questid2display.txt",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\LuaFiles514\itemInfo.lua"
)

foreach ($path in $files) {
    if (Test-Path $path) {
        $text = [System.IO.File]::ReadAllText($path)
        $openCount = ([regex]::Matches($text, '\{')).Count
        $closeCount = ([regex]::Matches($text, '\}')).Count
        Write-Host "=== $path ==="
        Write-Host "Open braces '{': $openCount | Close braces '}': $closeCount"
        if ($openCount -ne $closeCount) {
            Write-Host "ERROR: BRACE MISMATCH!"
        }
    }
}
