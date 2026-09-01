$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"

$content = [System.IO.File]::ReadAllText($soul1)

$oldSnippet = @"
			case 2:
				skill 1066, 1, SKILL_PERM;
				mes "[Rogue Einherjar]";
				mes "Your ^0000FFSoul of the Mimic^000000 has been restored!";
				close;
"@

$newSnippet = @"
			case 2:
				skill 1066, 1, SKILL_PERM;
				skill 1067, 1, SKILL_PERM;
				mes "[Rogue Einherjar]";
				mes "Your ^0000FFSoul of the Mimic^000000 and ^0000FFSupport Plagiarism^000000 have been restored!";
				close;
"@

if ($content.Contains($oldSnippet.Replace("`r`n", "`n"))) {
    $content = $content.Replace($oldSnippet.Replace("`r`n", "`n"), $newSnippet.Replace("`r`n", "`n"))
} else {
    $content = $content.Replace($oldSnippet, $newSnippet)
}

[System.IO.File]::WriteAllText($soul1, $content, $utf8NoBom)
Write-Host "Replaced Rogue recovery snippet successfully!"
