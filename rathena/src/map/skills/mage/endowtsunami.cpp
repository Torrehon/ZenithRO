// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "endowtsunami.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillEndowTsunami::SkillEndowTsunami() : SkillImpl(SA_FROSTWEAPON) {
}

void SkillEndowTsunami::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	sc_type type = skill_get_sc(getSkillId());
	map_session_data* sd = BL_CAST( BL_PC, src );
	map_session_data* dstsd = BL_CAST( BL_PC, target );

	if (dstsd && dstsd->status.weapon == W_FIST) {
		if (sd)
			clif_skill_fail( *sd, getSkillId() );
		clif_skill_nodamage(src,*target,getSkillId(),skill_lv,false);
		return;
	}

	// --- INICIO CUSTOM: Endows 100% éxito sin desequipar ---
	clif_skill_nodamage(src, *target, getSkillId(), skill_lv, sc_start(src, target, type, 100, skill_lv, skill_get_time(getSkillId(), skill_lv)));
	// --- FIN CUSTOM ---
}
