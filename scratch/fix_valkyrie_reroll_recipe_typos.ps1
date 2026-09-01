$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$upgradeFile = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\einherjar_weapon_upgrades.txt"

$content = [System.IO.File]::ReadAllText($upgradeFile)

# Fix case 40013 (Twilight Edge)
$oldEdge = "case 40013: // Twilight Edge`r`n			.@g1 = 726; .@c1 = 1; .@g2 = 723; .@c1 = 1; .@g3 = 728; .@c3 = 1; break;"
$oldEdgeUnix = "case 40013: // Twilight Edge`n			.@g1 = 726; .@c1 = 1; .@g2 = 723; .@c1 = 1; .@g3 = 728; .@c3 = 1; break;"

$newEdge = "case 40013: // Twilight Edge`n			.@g1 = 726; .@c1 = 1; .@g2 = 723; .@c2 = 1; .@g3 = 728; .@c3 = 1; break;"

if ($content.Contains(".@g2 = 723; .@c1 = 1;")) {
    $content = $content.Replace(".@g2 = 723; .@c1 = 1;", ".@g2 = 723; .@c2 = 1;")
    Write-Host "Fixed Twilight Edge recipe typo (.@c2 = 1)!"
}

if ($content.Contains(".@g2 = 726; .@c1 = 1;")) {
    $content = $content.Replace(".@g2 = 726; .@c1 = 1;", ".@g2 = 726; .@c2 = 1;")
    Write-Host "Fixed Twilight Violin/Whip recipe typo (.@c2 = 1)!"
}

[System.IO.File]::WriteAllText($upgradeFile, $content, $utf8NoBom)
Write-Host "Updated Valkyrie Kara recipe typos successfully!"
