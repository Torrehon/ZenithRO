$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub"
$lines = Get-Content -Path $path

for ($i = 87095; $i -lt 87105; $i++) {
    if ($lines[$i] -eq "`t}") {
        Write-Host "Found missing comma on line $($i+1): '$($lines[$i])'"
        $lines[$i] = "`t},"
    }
}

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$text = $lines -join "`n"
[System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
Write-Host "Updated OngoingQuests.lub with comma!"
