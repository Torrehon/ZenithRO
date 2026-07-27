// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "venomdust.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillVenomDust::SkillVenomDust() : SkillImpl(AS_VENOMDUST) {
}

void SkillVenomDust::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	flag|=1;
	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

// --- INICIO CUSTOM: Ratio para Viper Soul / Mimic Soul (Escalado de INT) ---
void SkillVenomDust::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	
	base_skillratio = 0; // Barrera oficial: 0 daño para Assassins normales

	if (src && src->type == BL_PC) {
		map_session_data* sd = const_cast<map_session_data*>(BL_CAST(BL_PC, src));
		
		// Si tiene Soul of the Viper O Mimic Soul
		if (pc_checkskill(sd, AS_VIPERSOUL) > 0 || pc_checkskill(sd, RG_MIMIC) > 0) {
			base_skillratio = 100 + skill_lv * (status_get_int(src) / 4);
		}
	}
}
// --- FIN CUSTOM ---