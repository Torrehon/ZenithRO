// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "hocuspocus.hpp"

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillHocusPocus::SkillHocusPocus() : SkillImpl(SA_ABRACADABRA) {
}

void SkillHocusPocus::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// --- INICIO CUSTOM: Overcast (Reemplaza Abracadabra) ---
	// Otorga el buff SC_OVERCAST durante 20000 ms (20 segundos)
	clif_skill_nodamage(src, *target, getSkillId(), skill_lv, sc_start(src, target, SC_OVERCAST, 100, skill_lv, 20000));
	// --- FIN CUSTOM ---
}