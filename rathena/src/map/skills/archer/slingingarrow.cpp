// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "slingingarrow.hpp"

#include <config/core.hpp>
#include <algorithm>
#include "map/pc.hpp"
#include "map/status.hpp"

SkillSlingingArrow::SkillSlingingArrow() : WeaponSkillImpl(DC_THROWARROW) {
}

void SkillSlingingArrow::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	base_skillratio += 10 + 40 * skill_lv;
#else
	base_skillratio += -40 + 40 * skill_lv;
#endif

	int hits = 1; // Por defecto es 1 solo golpe

	// --- INICIO CUSTOM: SOUL OF THE DISSONANT & MOMENTUM ---
	const map_session_data* sd = BL_CAST(BL_PC, src);
	if (sd && pc_checkskill(sd, BD_DISSONANT) > 0) {
		
		const status_change* sc = status_get_sc(src);
		if (sc && sc->getSCE(SC_MOMENTUM)) {
			// Aumentamos 5% por cada stack de Momentum
			base_skillratio += sc->getSCE(SC_MOMENTUM)->val1 * 5;
		}

		// Check de Canción Activa: SC_DANCING solo existe mientras el área está encendida
		if (sc && sc->getSCE(SC_DANCING)) {
			hits = 2;              // Convertimos el ataque en 2 hits
		}
	}
	// --- FIN CUSTOM ---

	// Aplicamos la cantidad de golpes al paquete de daño
	if (wd != nullptr) {
		const_cast<Damage*>(wd)->div_ = hits;
	}
}

void SkillSlingingArrow::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);

	map_session_data* sd = BL_CAST(BL_PC, src);
	
	if (sd && pc_checkskill(sd, BD_DISSONANT) > 0 && pc_checkskill(sd, AC_MOMENTUM) > 0) { 
		
		status_change* sc = status_get_sc(src);
		int32 current_stacks = 0;

		if (sc && sc->getSCE(SC_MOMENTUM)) {
			current_stacks = sc->getSCE(SC_MOMENTUM)->val1;
		}

		int32 new_stacks = std::min(10, current_stacks + 1);
		t_tick duration = (12 - new_stacks) * 1000;

		sc_start4(src, src, SC_MOMENTUM, 100, new_stacks, 0, 0, 0, duration);
	}
}
