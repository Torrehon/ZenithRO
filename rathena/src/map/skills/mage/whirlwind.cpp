// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "whirlwind.hpp"
#include "map/pc.hpp" // Required to check player skills

SkillWhirlwind::SkillWhirlwind() : SkillImpl(SA_VIOLENTGALE) {
}

void SkillWhirlwind::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
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

// --- INICIO CUSTOM: Violent Gale Damage (Soul of the Arcanist) ---
void SkillWhirlwind::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	
	base_skillratio = 0; // Official barrier: 0 native damage for normal Sages

	if (src && src->type == BL_PC) {
		map_session_data* sd = const_cast<map_session_data*>(BL_CAST(BL_PC, src));
		
		// If the Sage has the passive learned, the area gains 100% MATK
		if (pc_checkskill(sd, SA_ARCSOUL) > 0) {
			base_skillratio = 100;
		}
	}
}
// --- FIN CUSTOM ---