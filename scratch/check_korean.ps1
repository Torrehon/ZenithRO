$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$enc = [System.Text.Encoding]::GetEncoding(949)
$lines = [System.IO.File]::ReadAllLines($path, $enc)

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*\[502\]\s*=\s*\{') {
        $lines[$i..($i+12)]
        break
    }
}
