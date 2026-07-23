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

void SkillPlagiarismOffensive::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	map_session_data *sd = BL_CAST(BL_PC, src);
	if (!sd) return;


	// Validamos si la libreta ofensiva tiene algo guardado
	if (sd->plagia_offensive_count == 0) {
		clif_skill_fail(*sd, RG_PLAGIARISM);
		return;
	}

	// Aquí irá la llamada al menú NPC de Ofensivas
}

// ==========================================
// 2. PLAGIARISM DE SOPORTE (La skill nueva)
// ==========================================
// Sustituye RG_SUPPORT_PLAGIARISM por el nombre que le hayas dado a tu skill custom en skill.hpp
SkillPlagiarismSupport::SkillPlagiarismSupport() : SkillImpl(RG_SUPPORT_PLAGIARISM) {
}

void SkillPlagiarismSupport::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	map_session_data *sd = BL_CAST(BL_PC, src);
	if (!sd) return;

	// Validamos dos cosas: que tenga la Soul of Mimic (RG_MIMIC) y que la libreta tenga algo
	if (pc_checkskill(sd, RG_MIMIC) == 0 || sd->plagia_support_count == 0) {
		clif_skill_fail(*sd, RG_SUPPORT_PLAGIARISM); // Usa el nombre de tu skill aquí
		return;
	}

	// Aquí irá la llamada al menú NPC de Soporte
}