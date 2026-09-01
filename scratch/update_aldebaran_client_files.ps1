$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# 1. Update questid2display.txt
$q2dPath = "d:\SERVER_RO\LevitationRO\ZenithRO\data\questid2display.txt"
$q2dText = [System.IO.File]::ReadAllText($q2dPath)

$q2dAdd = @"
70401#Aldebaran Hunt: Thief Bug Female#SG_FEEL#Que_god#Hunt 25 Thief Bug Female.#
70402#Aldebaran Hunt: Dustiness#SG_FEEL#Que_god#Hunt 25 Dustiness.#
70403#Aldebaran Hunt: Argos#SG_FEEL#Que_god#Hunt 25 Argos.#
70404#Aldebaran Hunt: Flora#SG_FEEL#Que_god#Hunt 25 Flora.#
70405#Aldebaran Hunt: Stem Worm#SG_FEEL#Que_god#Hunt 20 Stem Worm.#
70406#Aldebaran Hunt: Argiope#SG_FEEL#Que_god#Hunt 20 Argiope.#
70407#Aldebaran Hunt: Earth Petite#SG_FEEL#Que_god#Hunt 20 Earth Petite.#
70408#Aldebaran Hunt: Bathory#SG_FEEL#Que_god#Hunt 20 Bathory.#
70409#Aldebaran Hunt: Punk#SG_FEEL#Que_god#Hunt 20 Punk.#
70410#Aldebaran Hunt: Grand Peco#SG_FEEL#Que_god#Hunt 15 Grand Peco.#
70411#Aldebaran Hunt: Rideword#SG_FEEL#Que_god#Hunt 15 Rideword.#
70412#Aldebaran Hunt: Alarm#SG_FEEL#Que_god#Hunt 15 Alarm.#
70413#Aldebaran Hunt: Clock#SG_FEEL#Que_god#Hunt 15 Clock.#
"@

if (-not ($q2dText -match "70401#")) {
    $q2dText = $q2dText.TrimEnd() + "`r`n" + $q2dAdd
    [System.IO.File]::WriteAllText($q2dPath, $q2dText, $utf8NoBom)
    Write-Host "questid2display.txt updated!"
}

# Build Lua block for OngoingQuests
$lubAdd = @"
	-- Aldebaran Hunting Quests
	[70401] = {
		Title = "Aldebaran Hunt: Thief Bug Female",
		Description = {
			"Hunt down 25 Thief Bug Females to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 25 Thief Bug Female.",
		Hunt1 = "Thief Bug Female",
		NpcName = "Hunting Board",
	},
	[70402] = {
		Title = "Aldebaran Hunt: Dustiness",
		Description = {
			"Hunt down 25 Dustiness to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 25 Dustiness.",
		Hunt1 = "Dustiness",
		NpcName = "Hunting Board",
	},
	[70403] = {
		Title = "Aldebaran Hunt: Argos",
		Description = {
			"Hunt down 25 Argos to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 25 Argos.",
		Hunt1 = "Argos",
		NpcName = "Hunting Board",
	},
	[70404] = {
		Title = "Aldebaran Hunt: Flora",
		Description = {
			"Hunt down 25 Floras to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 25 Flora.",
		Hunt1 = "Flora",
		NpcName = "Hunting Board",
	},
	[70405] = {
		Title = "Aldebaran Hunt: Stem Worm",
		Description = {
			"Hunt down 20 Stem Worms to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 20 Stem Worm.",
		Hunt1 = "Stem Worm",
		NpcName = "Hunting Board",
	},
	[70406] = {
		Title = "Aldebaran Hunt: Argiope",
		Description = {
			"Hunt down 20 Argiopes to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 20 Argiope.",
		Hunt1 = "Argiope",
		NpcName = "Hunting Board",
	},
	[70407] = {
		Title = "Aldebaran Hunt: Earth Petite",
		Description = {
			"Hunt down 20 Earth Petites to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 20 Earth Petite.",
		Hunt1 = "Earth Petite",
		NpcName = "Hunting Board",
	},
	[70408] = {
		Title = "Aldebaran Hunt: Bathory",
		Description = {
			"Hunt down 20 Bathorys to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 20 Bathory.",
		Hunt1 = "Bathory",
		NpcName = "Hunting Board",
	},
	[70409] = {
		Title = "Aldebaran Hunt: Punk",
		Description = {
			"Hunt down 20 Punks to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 20 Punk.",
		Hunt1 = "Punk",
		NpcName = "Hunting Board",
	},
	[70410] = {
		Title = "Aldebaran Hunt: Grand Peco",
		Description = {
			"Hunt down 15 Grand Pecos to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 15 Grand Peco.",
		Hunt1 = "Grand Peco",
		NpcName = "Hunting Board",
	},
	[70411] = {
		Title = "Aldebaran Hunt: Rideword",
		Description = {
			"Hunt down 15 Ridewords to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 15 Rideword.",
		Hunt1 = "Rideword",
		NpcName = "Hunting Board",
	},
	[70412] = {
		Title = "Aldebaran Hunt: Alarm",
		Description = {
			"Hunt down 15 Alarms to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 15 Alarm.",
		Hunt1 = "Alarm",
		NpcName = "Hunting Board",
	},
	[70413] = {
		Title = "Aldebaran Hunt: Clock",
		Description = {
			"Hunt down 15 Clocks to complete the contract",
			"and claim your Aldebaran Coins."
		},
		Summary = "Hunt 15 Clock.",
		Hunt1 = "Clock",
		NpcName = "Hunting Board",
	},
"@

# 2. Update SystemEN/OngoingQuests_C.lub
$cPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub"
$cText = [System.IO.File]::ReadAllText($cPath)

if (-not ($cText -match "\[70401\]")) {
    $cAdd = $lubAdd.Replace("QuestInfoList_C", "QuestInfoList_C")
    if ($cText -match "(?s)(.*?\n\t\[70316\].*?\n\t\})(.*)") {
        $before = $matches[1]
        $after = $matches[2]
        $newC = $before + ",`n" + $cAdd + $after
        [System.IO.File]::WriteAllText($cPath, $newC, $utf8NoBom)
        Write-Host "OngoingQuests_C.lub updated!"
    }
}

# 3. Update SystemEN/OngoingQuests.lub
$ogPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub"
$ogText = [System.IO.File]::ReadAllText($ogPath)

if (-not ($ogText -match "\[70401\]")) {
    if ($ogText -match "(?s)(.*?\n\t\[70316\].*?\n\t\})(.*)") {
        $before = $matches[1]
        $after = $matches[2]
        $newOg = $before + ",`n" + $lubAdd + $after
        [System.IO.File]::WriteAllText($ogPath, $newOg, $utf8NoBom)
        Write-Host "OngoingQuests.lub updated!"
    }
}

# 4. Update SystemEN/OngoingQuests_CLS.lub
$clsPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
$clsText = [System.IO.File]::ReadAllText($clsPath)

if (-not ($clsText -match "\[70401\]")) {
    $classList = [System.Collections.Generic.List[string]]::new()
    70401..70413 | ForEach-Object {
        $classList.Add("QuestClassificationList[$_] = 2 -- Daily Quest")
    }
    $classStr = $classList -join "`n"

    if ($clsText -match "(?s)(.*?\n\t\[70316\].*?\n\t\})(.*)") {
        $before = $matches[1]
        $after = $matches[2]
        $newCls = $before + ",`n" + $lubAdd + $after + "`n" + $classStr
        [System.IO.File]::WriteAllText($clsPath, $newCls, $utf8NoBom)
        Write-Host "OngoingQuests_CLS.lub updated!"
    }
}

# 5 & 6. Update itemInfo.lua files with item 50026
$itemLuaAdd = @"
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
"@

$infoFiles = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\LuaFiles514\itemInfo.lua"
)

foreach ($infoPath in $infoFiles) {
    if (Test-Path $infoPath) {
        $infoText = [System.IO.File]::ReadAllText($infoPath)
        if (-not ($infoText -match "\[50026\]")) {
            if ($infoText -match "(?s)(.*?\n\t\[50007\].*?\n\t\},)(.*)") {
                $b = $matches[1]
                $a = $matches[2]
                $newInfo = $b + "`n" + $itemLuaAdd + $a
                [System.IO.File]::WriteAllText($infoPath, $newInfo, $utf8NoBom)
                Write-Host "Updated $infoPath with item 50026!"
            }
        }
    }
}
