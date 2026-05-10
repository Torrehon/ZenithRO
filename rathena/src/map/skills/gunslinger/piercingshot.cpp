// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "piercingshot.hpp"

#include "map/pc.hpp"
#include "map/status.hpp"

SkillPiercingShot::SkillPiercingShot() : WeaponSkillImpl(GS_PIERCINGSHOT) {
}

void SkillPiercingShot::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);
	const status_change* tsc = status_get_sc(target);

#ifdef RENEWAL
	if (sd && sd->weapontype1 == W_RIFLE)
		base_skillratio += 150 + 30 * skill_lv;
	else
		base_skillratio += 100 + 20 * skill_lv;
#else
	base_skillratio += 20 * skill_lv;
#endif

	// --- SINERGIA TRACER SHOT ---
	// Si el objetivo está marcado (EXPOSED) y el usuario lleva Rifle
	if (sd && sd->weapontype1 == W_RIFLE && tsc != nullptr && tsc->getSCE(SC_EXPOSED)) {
		base_skillratio += 300; // +300% de daño extra
	}
}

void SkillPiercingShot::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);
	status_change* tsc = status_get_sc(target);
	
	// --- UNIFICACIÓN DE TIEMPOS ---
	// 30 segundos = 30000 milisegundos
	t_tick duration = 30000;

	// 1. Efecto base: Probabilidad de Bleeding (30s)
	sc_start2(src, target, SC_BLEEDING, 15, skill_lv, src->id, duration);

	// 2. Efecto base: Probabilidad de Ralentización SC_PSLOW (30s)
	// Pasamos 'skill_lv' como val1, delegando el efecto a status.cpp
	sc_start(src, target, SC_PSLOW, 30, skill_lv, duration);

	// 3. Consumir la marca EXPOSED
	// Si se aplicó el bono de daño por usar Rifle y tener la marca, la limpiamos.
	if (sd && sd->weapontype1 == W_RIFLE && tsc != nullptr && tsc->getSCE(SC_EXPOSED)) {
		status_change_end(target, SC_EXPOSED, INVALID_TIMER);
	}
}