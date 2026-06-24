// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "hipshaker.hpp"

#include <config/core.hpp>

#include "map/pc.hpp"
#include "map/status.hpp" // Añadido para leer los estados alterados (SC_UNNERVED)

SkillHipShaker::SkillHipShaker() : SkillImpl(DC_UGLYDANCE) {
}

void SkillHipShaker::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST( BL_PC, src );

	// Porcentaje base físico: 60% a nivel 1, 260% a nivel 5 (sin contar el Job Level)
	base_skillratio += 10 + skill_lv * 50;

	// --- INICIO CUSTOM: UNNERVED ---
	// Si hay un objetivo y tiene el estado Unnerved activo, aumentamos este multiplicador en un 25%
	if (target != nullptr) {
		const status_change* tsc = status_get_sc(target);
		if (tsc && tsc->getSCE(SC_UNNERVED)) {
			base_skillratio = (base_skillratio * 125) / 100;
		}
	}
	// --- FIN CUSTOM ---
}

void SkillHipShaker::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
#ifdef RENEWAL
	skill_castend_song(src, getSkillId(), skill_lv, tick);
#endif
}

void SkillHipShaker::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
#ifndef RENEWAL
	flag|=1;//Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	// Ammo should be deleted right away.
	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
#endif
}