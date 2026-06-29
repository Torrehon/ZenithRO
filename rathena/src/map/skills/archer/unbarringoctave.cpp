// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "unbarringoctave.hpp"

#include "map/battle.hpp"
#include "map/clif.hpp"
#include "map/mob.hpp"
#include "map/status.hpp"
#include "map/pc.hpp" // Añadido para BL_CAST a map_session_data y pc_checkskill

SkillUnbarringOctave::SkillUnbarringOctave() : SkillImpl(BA_FROSTJOKER) {
}

void SkillUnbarringOctave::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// --- CUSTOM: Ya no afecta al caster ---
	if (src->id == target->id)
		return;

	// --- CUSTOM: Nuevo rate de 15% + 3% * skill_lv ---
	int32 rate = 150 + 30 * skill_lv; 
	int32 duration = skill_get_time2(getSkillId(), skill_lv);
	
	if (battle_check_target(src, target, BCT_PARTY) > 0) {
		rate /= 4;
		duration = skill_get_time(getSkillId(), skill_lv);
	}
	
	// Aplica el Freeze original con el rate modificado
	status_change_start(src, target, skill_get_sc(getSkillId()), rate * 10, skill_lv, 0, 0, 0, duration, SCSTART_NONE);

	// --- INICIO CUSTOM: UNNERVED ---
	if (src->type == BL_PC) {
		map_session_data* sd = BL_CAST(BL_PC, src);
		// Si el lanzador tiene la Soul of the Dissonant
		if (sd && pc_checkskill(sd, BD_DISSONANT) > 0) {
			// Aplica SC_UNNERVED con 100% de probabilidad (10000 base) por 10 segundos (10000 ms)
			status_change_start(src, target, SC_UNNERVED, 10000, skill_lv, 0, 0, 0, 10000, SCSTART_NONE);
		}
	}
	// --- FIN CUSTOM ---
}

void SkillUnbarringOctave::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	clif_skill_nodamage(src, *target, getSkillId(), skill_lv);
	skill_addtimerskill(src, tick + 500, target->id, src->x, src->y, getSkillId(), skill_lv, 0, flag);
	
	// --- CUSTOM: Eliminado el bloque de código que forzaba el texto/broma en monstruos ---
}