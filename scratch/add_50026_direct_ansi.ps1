# 1. Reset itemInfo_C.lua so custom version is not used
$cPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo_C.lua"
$cContent = @"
-- Table for Custom Items
tbl_custom = {
}

-- Table for Official Overrides
tbl_override = {
	
}
"@
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($cPath, $cContent, $utf8NoBom)
Write-Host "Reset itemInfo_C.lua to default (empty tbl_custom)."

# 2. Append item 50026 into main itemInfo.lua preserving exact ANSI/Windows-1252 encoding
$ansi = [System.Text.Encoding]::GetEncoding(1252)

$targets = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\LuaFiles514\itemInfo.lua"
)

$newItemStr = @"
	[50026] = {
		unidentifiedDisplayName = "Coin",
		unidentifiedResourceName = "aldebaran_coin",
		unidentifiedDescriptionName = {
			" "
		},
		identifiedDisplayName = "Aldebaran Coin",
		identifiedResourceName = "aldebaran_coin",
		identifiedDescriptionName = {
			"^0000CCAldebaran Hunting Reward^000000",
			"_______________________________________",
			"A precision-engineered coin minted in",
			"the canal city of ^FF0000Aldebaran^000000. Stamped",
			"with the gears of the Clock Tower.",
			"_______________________________________",
			"^0000CCUsage:^000000",
			"Can be exchanged for provisions with the",
			"^0000CCVeteran Hunter^000000 in Aldebaran.",
			"_______________________________________",
			"^FF0000Account Bound.^000000"
		},
		slotCount = 0,
		ClassNum = 0
	},
}

function main()
"@

foreach ($target in $targets) {
    if (Test-Path $target) {
        $bytes = [System.IO.File]::ReadAllBytes($target)
        $text = $ansi.GetString($bytes)
        
        if ($text.Contains("function main()")) {
            if (-not $text.Contains("[50026]")) {
                $targetPattern = "}`r`n`r`nfunction main()"
                if (-not $text.Contains($targetPattern)) {
                    $targetPattern = "}`n`nfunction main()"
                }
                
                $replacement = "`t" + $newItemStr
                $newText = $text.Replace($targetPattern, $replacement)
                $newBytes = $ansi.GetBytes($newText)
                [System.IO.File]::WriteAllBytes($target, $newBytes)
                Write-Host "Directly added item 50026 into $target using ANSI encoding!"
            } else {
                Write-Host "Item 50026 already present in $target."
            }
        }
    }
}
