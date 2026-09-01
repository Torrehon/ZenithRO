$mobDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_db.yml"
$mobText = Get-Content -Path $mobDb -Raw

$mobNames = @("Thief Bug Female", "Dustiness", "Argos", "Flora", "Stem Worm", "Argiope", "Earth Petite", "Bathory", "Punk", "Grand Peco", "Rideword", "Alarm", "Clock")

foreach ($name in $mobNames) {
    if ($mobText -match "(?m)^\s*-\s*Id:\s*(\d+)\s*\r?\n\s*AegisName:\s*(\w+)\s*\r?\n\s*Name:\s*$name") {
        Write-Host "Name '$name' -> Id: $($matches[1]), AegisName: $($matches[2])"
    } else {
        Write-Host "Name '$name' NOT FOUND by exact regex match, searching loosely..."
        if ($mobText -match "(?i)Name:\s*.*$name.*") {
            # find surrounding block
            $lines = Get-Content -Path $mobDb
            for ($i = 0; $i -lt $lines.Length; $i++) {
                if ($lines[$i] -like "*Name:*$name*") {
                    Write-Host "   Line $($i+1): $($lines[$i-2]) | $($lines[$i-1]) | $($lines[$i])"
                }
            }
        }
    }
}
