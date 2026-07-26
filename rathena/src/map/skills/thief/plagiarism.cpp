// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "plagiarism.hpp"

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/skill.hpp"

// ==========================================
// 1. PLAGIARISM OFENSIVO (La skill clásica)
// ==========================================
SkillPlagiarismOffensive::SkillPlagiarismOffensive() : SkillImpl(RG_PLAGIARISM) {
}

void SkillPlagiarismOffensive::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	map_session_data *sd = BL_CAST(BL_PC, src);
	if (!sd) return;

	if (sd->plagia_offensive_count == 0) {
		clif_skill_fail(*sd, RG_PLAGIARISM);
		return;
	}

	// Llama a la ventana de UI, 'false' significa Ofensiva
	clif_plagiarism_list(sd, false);
}

// ==========================================
// 2. PLAGIARISM DE SOPORTE (La skill nueva)
// ==========================================
// NOTA: Si en skill.hpp llamaste a tu skill de otra forma, cambia RG_SUPPORT_PLAGIARISM
SkillPlagiarismSupport::SkillPlagiarismSupport() : SkillImpl(RG_SUPPORT_PLAGIARISM) {
}

void SkillPlagiarismSupport::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	map_session_data *sd = BL_CAST(BL_PC, src);
	if (!sd) return;

	if (pc_checkskill(sd, RG_MIMIC) == 0 || sd->plagia_support_count == 0) {
		clif_skill_fail(*sd, RG_SUPPORT_PLAGIARISM); 
		return;
	}

	// Llama a la ventana de UI, 'true' significa Soporte
	clif_plagiarism_list(sd, true);
}