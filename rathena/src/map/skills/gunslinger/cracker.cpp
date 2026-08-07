// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "cracker.hpp"

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillCracker::SkillCracker() : SkillImpl(GS_CRACKER) {
}

void SkillCracker::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	// Fase 2: El core propaga el efecto a cada entidad dentro del SplashArea
	if (flag & 1) {
		// Evitamos que el jugador se aplique Confusión a sí mismo
		if (src->id == target->id)
			return;

		map_session_data *sd = BL_CAST(BL_PC, src);
		map_session_data *dstsd = BL_CAST(BL_PC, target);
		mob_data *dstmd = BL_CAST(BL_MOB, target);

		/* per official standards, this skill works on players and mobs. */
		if (sd && (dstsd || dstmd)) {
			int32 i = 65 - 5 * distance_bl(src, target); // Base rate
			if (i < 30)
				i = 30;
			
			// Cambiado de SC_STUN a SC_CONFUSION
			sc_start(src, target, SC_CONFUSION, i, skill_lv, skill_get_time2(getSkillId(), skill_lv));
		}
	} 
	// Fase 1: Casteo inicial de la habilidad por parte del jugador
	else {
		// Mostramos la animación visual de la habilidad centrada en el propio jugador
		clif_skill_nodamage(src, *src, getSkillId(), skill_lv);
	}
}