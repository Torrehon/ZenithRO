// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "deluge.hpp"
#include "map/pc.hpp" // Necesario para comprobar las habilidades del jugador

SkillDeluge::SkillDeluge() : SkillImpl(SA_DELUGE) {
}

void SkillDeluge::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	//Does not consumes if the skill is already active. [Skotlex]
	std::shared_ptr<s_skill_unit_group> sg2;
	if ((sg2= skill_locate_element_field(src)) != nullptr && ( sg2->skill_id == SA_VOLCANO || sg2->skill_id == SA_DELUGE || sg2->skill_id == SA_VIOLENTGALE ))
	{
		if (sg2->limit - DIFF_TICK(gettick(), sg2->tick) > 0)
		{
			skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
			flag |= SKILL_NOCONSUME_REQ; // not to consume items
			return;
		}
		else
			sg2->limit = 0; //Disable it.
	}
	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

// --- INICIO CUSTOM: Daño de Deluge (Soul of the Arcanist) ---
void SkillDeluge::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	
	base_skillratio = 0; // Barrera oficial: 0 daño nativo para Sages normales

	if (src && src->type == BL_PC) {
		map_session_data* sd = const_cast<map_session_data*>(BL_CAST(BL_PC, src));
		
		// Si el Sage tiene la pasiva aprendida, el área gana un 100% de MATK
		if (pc_checkskill(sd, SA_ARCSOUL) > 0) {
			base_skillratio = 100;
		}
	}
}
// --- FIN CUSTOM ---