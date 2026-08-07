// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "tracking.hpp"

SkillTracking::SkillTracking() : WeaponSkillImpl(GS_TRACKING) {
}

void SkillTracking::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);
	const status_change* tsc = status_get_sc(target);
	
	base_skillratio += 100 * (skill_lv + 1);
	
	// --- INICIO CUSTOM: Sinergia EXPOSED ---
	if (tsc != nullptr && tsc->getSCE(SC_EXPOSED)) {
		// Aumenta el ratio final de la habilidad un 50%
		base_skillratio += (base_skillratio * 50) / 100;
	}
	// --- FIN CUSTOM ---
	
}

void SkillTracking::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	status_change* tsc = status_get_sc(target);
	
	// --- INICIO CUSTOM: Consumir la marca EXPOSED ---
	// Si el objetivo estaba marcado y Tracking le aplicó el bono de daño, limpiamos la marca.
	if (tsc != nullptr && tsc->getSCE(SC_EXPOSED)) {
		status_change_end(target, SC_EXPOSED, INVALID_TIMER);
	}
	// --- FIN CUSTOM ---
}