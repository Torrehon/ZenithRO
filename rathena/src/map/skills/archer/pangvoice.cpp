// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "pangvoice.hpp"

#include <config/core.hpp>
#include "map/clif.hpp"
#include "map/status.hpp"
#include "map/pc.hpp"

// Actualizamos el constructor
SkillPangVoice::SkillPangVoice() : SkillImpl(BA_PANGVOICE) {
}

void SkillPangVoice::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Daño base: 250% MATK
	base_skillratio += 150; 

	int hits = 1;

	// --- INICIO CUSTOM: COMBO UNNERVED ---
	const map_session_data* sd = BL_CAST(BL_PC, src);
	if (sd && target != nullptr && pc_checkskill(sd, BD_DISSONANT) > 0) {
		const status_change* tsc = status_get_sc(target);
		
		if (tsc && tsc->getSCE(SC_UNNERVED)) {
			// Si el objetivo está marcado, el daño sube a 750% MATK (sumamos 650 al 100% inicial)
			base_skillratio += 500; // 250 base + 500 = 750% total
			hits = 3;               // Se divide en 3 impactos visuales
		}
	}
	// --- FIN CUSTOM ---

	if (wd != nullptr) {
		const_cast<Damage*>(wd)->div_ = hits;
	}
}

void SkillPangVoice::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// 1. Aplicamos el daño mágico
	SkillImpl::castendDamageId(src, target, skill_lv, tick, flag);

	// 2. Efecto de estado reducido a 50%
	sc_start(src, target, SC_CONFUSION, 50, skill_lv, skill_get_time(getSkillId(), skill_lv));

	// 3. Consumo de la marca Unnerved
	const map_session_data* sd = BL_CAST(BL_PC, src);
	if (sd && pc_checkskill(sd, BD_DISSONANT) > 0) {
		status_change* tsc = status_get_sc(target);
		if (tsc && tsc->getSCE(SC_UNNERVED)) {
			// Borramos el estado para que no puedan espamear el remate
			status_change_end(target, SC_UNNERVED, INVALID_TIMER);
		}
	}
}
