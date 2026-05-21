// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "landmine.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillLandMine::SkillLandMine() : SkillImpl(HT_LANDMINE) {
}

void SkillLandMine::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	flag |= 1;

	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

void SkillLandMine::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	sc_start(src, target, SC_STUN, 10, skill_lv, skill_get_time2(getSkillId(), skill_lv), 1000);

// --- INICIO CUSTOM: SOUL OF THE TRAPPER (PINNED) ---
	map_session_data* sd = BL_CAST(BL_PC, src);
	
	if (sd && pc_checkskill(sd, HT_TRAPPERSOUL) > 0) {
		// sc_start(origen, objetivo, estado, probabilidad, valor1_asociado, duración_ms)
		// Probabilidad = 100 (100%). Valor = 25 (el porcentaje de slow). Tiempo = 10000ms.
		sc_start(src, target, SC_PINNED, 100, 25, 10000);
	}
	// --- FIN CUSTOM
}
