// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "summonspiritsphere.hpp"

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillSummoningSpiritSphere::SkillSummoningSpiritSphere() : SkillImpl(MO_CALLSPIRITS) {
}

void SkillSummoningSpiritSphere::castendNoDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	map_session_data* sd = BL_CAST(BL_PC, src);

	if(sd) {
		int32 limit = skill_lv;
		
		// --- INICIO CUSTOM: Límite de esferas del Asceta ---
		if (pc_checkskill(sd, MO_ASCETIC) > 0) {
			limit = 10; // Si es Asceta, el límite base sube a 10
		}
		// --- FIN CUSTOM ---

		if( sd->sc.getSCE(SC_RAISINGDRAGON) )
			limit += sd->sc.getSCE(SC_RAISINGDRAGON)->val1;
			
		clif_skill_nodamage(src,*target,getSkillId(),skill_lv);
		pc_addspiritball(sd,skill_get_time(getSkillId(),skill_lv),limit);
	}
}