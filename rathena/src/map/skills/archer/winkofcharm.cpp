// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "winkofcharm.hpp"

#include <config/core.hpp>
#include "map/battle.hpp"
#include "map/clif.hpp"
#include "map/mob.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillWinkofCharm::SkillWinkofCharm() : SkillImpl(DC_WINKCHARM) {
}

void SkillWinkofCharm::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Daño base: 250% MATK
	base_skillratio += 150; 

	int hits = 1;

	// --- INICIO CUSTOM: COMBO UNNERVED ---
	const map_session_data* sd = BL_CAST(BL_PC, src);
	if (sd && target != nullptr && pc_checkskill(sd, BD_DISSONANT) > 0) {
		const status_change* tsc = status_get_sc(target);
		
		if (tsc && tsc->getSCE(SC_UNNERVED)) {
			base_skillratio += 500; // 750% total
			hits = 3;               // 3 impactos
		}
	}
	// --- FIN CUSTOM ---

	if (wd != nullptr) {
		const_cast<Damage*>(wd)->div_ = hits;
	}
}

void SkillWinkofCharm::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// 1. Aplicamos el daño mágico
	SkillImpl::castendDamageId(src, target, skill_lv, tick, flag);

	// 2. Efecto de estado reducido a 50%
	sc_type type = skill_get_sc(getSkillId());
	map_session_data* dstsd = BL_CAST(BL_PC, target);
	mob_data* dstmd = BL_CAST(BL_MOB, target);

	if (dstsd) {
		// A jugadores: 50% de probabilidad
		if (sc_start(src, target, SC_CONFUSION, 50, skill_lv, skill_get_time(getSkillId(), skill_lv)))
			sc_start(src, target, type, 100, skill_lv, skill_get_time2(getSkillId(), skill_lv));
	} else if (dstmd) {
		// A monstruos: 50% de probabilidad fija (simplificando la fórmula original)
		sc_start2(src, target, type, 50, skill_lv, src->id, skill_get_time2(getSkillId(), skill_lv));
	}

	// 3. Consumo de la marca Unnerved
	const map_session_data* sd = BL_CAST(BL_PC, src);
	if (sd && pc_checkskill(sd, BD_DISSONANT) > 0) {
		status_change* tsc = status_get_sc(target);
		if (tsc && tsc->getSCE(SC_UNNERVED)) {
			status_change_end(target, SC_UNNERVED, INVALID_TIMER);
		}
	}
}
