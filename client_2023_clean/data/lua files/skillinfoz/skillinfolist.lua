SkillInfoList = {
	[11000] = {
		"CUSTOM_PICKUP";
		SkillName = "Pickup",
		MaxLv = 1,
		SpAmount = { 0 },
		bSeperateLv = false,
		AttackRange = { 1 },
	},
}

function GetSkillInfo(skid)
	if SkillInfoList[skid] ~= nil then
		return SkillInfoList[skid]
	end
	return nil
end