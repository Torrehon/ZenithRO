SkillTreeView = {
	[JOBID.JT_NOVICE] = {
		[0] = 1,      -- Basic Skill (NV_BASIC)
		[1] = 11000,  -- TU SKILL PICKUP
		[7] = 8,      -- First Aid (NV_FIRSTAID)
	},
}

function GetSkillTreeView(jobID)
	local obj = SkillTreeView[jobID]
	if obj == nil then
		return {}
	end
	return obj
end