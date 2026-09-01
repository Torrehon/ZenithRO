$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# 1. Clean OngoingQuests.lub: Remove appended block starting at line '-- Prontera Hunting Quests'
$ogPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub"
$ogText = [System.IO.File]::ReadAllText($ogPath)

$marker = "`t-- Prontera Hunting Quests"
if ($ogText.Contains($marker)) {
    $idx = $ogText.IndexOf($marker)
    $cleanOg = $ogText.Substring(0, $idx).TrimEnd() + "`n}`n"
    [System.IO.File]::WriteAllText($ogPath, $cleanOg, $utf8NoBom)
    Write-Host "Cleaned OngoingQuests.lub (removed duplicate tail block)!"
}

# 2. Clean OngoingQuests_C.lub: Keep base file + 1 clean set of custom quests
$cPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub"
$cText = [System.IO.File]::ReadAllText($cPath)

if ($cText.Contains($marker)) {
    $firstIdx = $cText.IndexOf($marker)
    $cleanC = $cText.Substring(0, $firstIdx).TrimEnd()
    
    # We will build 1 clean custom block for 70001 to 70413
    $lubAdd = Get-Content -Path "scratch/lub_output.txt" -Raw
    # Add Aldebaran block
    $aldAdd = @"
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
	}
"@

    $finalC = $cleanC + "`n`n" + $lubAdd + "`n" + $aldAdd + "`n}`n"
    [System.IO.File]::WriteAllText($cPath, $finalC, $utf8NoBom)
    Write-Host "Cleaned OngoingQuests_C.lub (single clean block)!"
}

# 3. Clean OngoingQuests_CLS.lub
$clsPath = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
$clsText = [System.IO.File]::ReadAllText($clsPath)

if ($clsText.Contains($marker)) {
    $firstIdx = $clsText.IndexOf($marker)
    # Find base part before custom hunting quests
    $cleanCls = $clsText.Substring(0, $firstIdx).TrimEnd()
    
    # Build classification lines
    $classList = [System.Collections.Generic.List[string]]::new()
    $classList.Add("`n-- Custom Hunting Quests Classification")
    $classList.Add("if QuestClassificationList == nil then QuestClassificationList = {} end")
    
    $qids = [System.Collections.Generic.List[int]]::new()
    70001..70021 | ForEach-Object { $qids.Add($_) }
    70101..70121 | ForEach-Object { $qids.Add($_) }
    70201..70218 | ForEach-Object { $qids.Add($_) }
    70301..70316 | ForEach-Object { $qids.Add($_) }
    70401..70413 | ForEach-Object { $qids.Add($_) }
    
    foreach ($qid in $qids) {
        $classList.Add("QuestClassificationList[$qid] = 2 -- Daily Quest")
    }
    $classStr = $classList -join "`n"

    $lubAddCls = Get-Content -Path "scratch/lub_output.txt" -Raw
    $lubAddCls = $lubAddCls.Replace("QuestInfoList_C", "QuestInfoList_CLS")

    $finalCls = $cleanCls + "`n" + $lubAddCls + "`n" + $aldAdd + "`n}`n" + $classStr + "`n"
    [System.IO.File]::WriteAllText($clsPath, $finalCls, $utf8NoBom)
    Write-Host "Cleaned OngoingQuests_CLS.lub (single clean block + QuestClassificationList)!"
}

# 4. Clean questid2display.txt: remove duplicate 70001+ lines
$q2dPath = "d:\SERVER_RO\LevitationRO\ZenithRO\data\questid2display.txt"
$q2dText = [System.IO.File]::ReadAllText($q2dPath)

$q2dMarker = "70001#Prontera Hunt: Poring"
if ($q2dText.Contains($q2dMarker)) {
    $firstIdx = $q2dText.IndexOf($q2dMarker)
    $cleanQ2d = $q2dText.Substring(0, $firstIdx).TrimEnd()
    
    $q2dAdd = Get-Content -Path "scratch/questid2display_output.txt" -Raw
    $q2dAld = @"
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

    $finalQ2d = $cleanQ2d + "`r`n" + $q2dAdd + "`r`n" + $q2dAld + "`r`n"
    [System.IO.File]::WriteAllText($q2dPath, $finalQ2d, $utf8NoBom)
    Write-Host "Cleaned questid2display.txt (removed duplicates)!"
}

# 5. Revert questinfo_f.lub in both locations to original state
$qf1 = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\questinfo_f.lub"
$qf1Content = @"

dofile("SystemEN/OngoingQuests_CLS.lub")
dofile("SystemEN/RecommendedQuests_CLS.lub")


"@
[System.IO.File]::WriteAllText($qf1, $qf1Content, $utf8NoBom)

$qf2 = "d:\SERVER_RO\LevitationRO\ZenithRO\data\luafiles514\lua files\datainfo\questinfo_f.lub"
$qf2Content = @"
-- Original translation works of zackdreaver: https://github.com/zackdreaver/ROenglishRE
-- Continuated by llchrisll at https://github.com/llchrisll/ROenglishRE
-- This file can be distributed, used and modified freely
-- This file shouldn't be claimed as part of your project, unless you fork it from https://github.com/llchrisll/ROenglishRE
-- This file only works if used in combination with the `Custom Lua Support`
-- Last updated: 20241005

require('SystemEN/LuaFiles514/rotp_f')
dofile("SystemEN/OngoingQuests_C.lub")
dofile("SystemEN/RecommendedQuests_C.lub")
-------------------------------------------------

function GetOngoingQuestInfoByID(questID)
	if QuestInfoList[questID] ~= nil then
		return GetOngoingSimpleView(questID), QuestInfoList[questID].Title, QuestInfoList[questID].IconName, QuestInfoList[questID].Summary, QuestInfoList[questID].NpcSpr, QuestInfoList[questID].NpcNavi, QuestInfoList[questID].RewardEXP, QuestInfoList[questID].RewardJEXP, QuestInfoList[questID].NpcPosX, QuestInfoList[questID].NpcPosY, GetCoolTimeQuest(questID)
	else
		return GetOngoingSimpleView(questID), 'Unknown Quest - ID: '..questID
	end
end

function GetCoolTimeQuest(questID)
	local desc = QuestInfoList[questID].CoolTimeQuest
	if desc == nil then
		return 0
	end
	return desc
end

function GetOngoingDescription(questID)
	if QuestInfoList[questID] == nil then
		return AddOngoingDescription(questID,'Missing Quest Entry')
	end
	local desc = QuestInfoList[questID].Description
	if nil == desc then
		return
	end
	for k, v in pairs(desc) do
		AddOngoingDescription(questID, v)
	end
end

function GetOngoingRewardInfo(questID)
	if QuestInfoList[questID] == nil then
		return
	end
	local reward = QuestInfoList[questID].RewardItemList
	if nil == reward then
		return
	end
	for k, v in pairs(QuestInfoList[questID].RewardItemList) do
		AddOngoingRewardInfo(questID, v.ItemID, v.ItemNum)
	end
end

function RecommendedQuestInfoLoad()
	if QuestInfoList_C ~= nil then
		F_ROTP(QuestInfoList_C,QuestInfoList)
	end
	if RecommendedQuests_C ~= nil then
		F_ROTP(RecommendedQuests_C,RecommendedQuestInfoList)
	end
	-----------------------------------------------------------
	for questID, table in pairs(RecommendedQuestInfoList) do
		if nil == table.Title then
			table.Title = ""
		end
		if nil == table.IconName then
			table.IconName = ""
		end
		if nil == table.Summary then
			table.Summary = ""
		end
		if nil == table.BgName then
			table.BgName = ""
		end
		if nil == table.NpcSpr then
			table.NpcSpr = ""
		end
		if nil == table.NpcNavi then
			table.NpcNavi = ""
		end
		if nil == table.NpcPosX then
			table.NpcPosX = 0
		end
		if nil == table.NpcPosY then
			table.NpcPosY = 0
		end
		InsertRecommededQuestInfo(questID, table.Title, table.IconName, table.Summary, table.BgName, table.NpcSpr, table.NpcNavi, table.NpcPosX, table.NpcPosY)
		if nil ~= table.QuestInfo1 then
			for k, v in pairs(table.QuestInfo1) do
				AddRecommendedQuestInfo(questID, 0, v)
			end
		end
		if nil ~= table.QuestInfo2 then
			for k, v in pairs(table.QuestInfo2) do
				AddRecommendedQuestInfo(questID, 1, v)
			end
		end
		if nil ~= table.QuestInfo3 then
			for k, v in pairs(table.QuestInfo3) do
				AddRecommendedQuestInfo(questID, 2, v)
			end
		end
	end
end
"@
[System.IO.File]::WriteAllText($qf2, $qf2Content, $utf8NoBom)
Write-Host "Reverted both questinfo_f.lub files to clean original state!"
