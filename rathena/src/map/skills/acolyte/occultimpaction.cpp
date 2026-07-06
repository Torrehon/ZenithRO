// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "occultimpaction.hpp"

#include "map/status.hpp"
#include "map/pc.hpp" // Añadido para poder comprobar MO_ASCETIC

SkillOccultImpaction::SkillOccultImpaction() : WeaponSkillImpl(MO_INVESTIGATE) {
}

void SkillOccultImpaction::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, &src);
	const status_change* sc = status_get_sc(&src);

	// --- INICIO CUSTOM: Investigate Asceta (2 hits en Blade Stop) ---
	// Comprobamos que es Asceta Y que él mismo (src) está bajo Blade Stop
	if (sd && pc_checkskill(sd, MO_ASCETIC) > 0 && sc && sc->getSCE(SC_BLADESTOP)) {
		dmg.div_ = 2; // Hace que la habilidad muestre 2 impactos
	}
	// --- FIN CUSTOM ---
}

void SkillOccultImpaction::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);
	status_change_end(src, SC_BLADESTOP); // Esto cancela el Blade Stop tras el golpe
}

void SkillOccultImpaction::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	const status_change* tsc = status_get_sc(target); // tsc es el Blade Stop del enemigo

	base_skillratio += -100 + 100 * skill_lv;
	if (tsc && tsc->getSCE(SC_BLADESTOP))
		base_skillratio += base_skillratio / 2;
#else
	base_skillratio += 75 * skill_lv;
#endif

	const map_session_data* sd = BL_CAST(BL_PC, src);
	const status_change* sc = status_get_sc(src);
	
	// (Bloque de 2 hits con Blade Stop que hicimos antes)
	if (sd && pc_checkskill(sd, MO_ASCETIC) > 0 && sc && sc->getSCE(SC_BLADESTOP)) {
		// base_skillratio *= 2; 
	}

	// --- INICIO CUSTOM: Asceta Steel Body (INT Bonus) ---
	if (sd && pc_checkskill(sd, MO_ASCETIC) > 0 && sc && sc->getSCE(SC_STEELBODY)) {
		const status_data* sstatus = status_get_status_data(*src);
		base_skillratio += sstatus->int_ * 2; // Ratio de INT * 2
	}
	// --- FIN CUSTOM ---
}