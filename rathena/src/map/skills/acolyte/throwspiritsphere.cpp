// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "throwspiritsphere.hpp"

#include <config/core.hpp>

#include "map/battle.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillThrowSpiritSphere::SkillThrowSpiritSphere() : WeaponSkillImpl(MO_FINGEROFFENSIVE) {
}

void SkillThrowSpiritSphere::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	// --- INICIO CUSTOM ---
	// Al dejar esta función vacía, evitamos que el servidor modifique 'dmg.div_'.
	// Así, si la habilidad da 5 golpes, CADA GOLPE hará el daño completo.
	// --- FIN CUSTOM ---
}

void SkillThrowSpiritSphere::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	map_session_data* sd = BL_CAST(BL_PC, src);

	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);
	
	if (battle_config.finger_offensive_type && sd) {
		// --- INICIO CUSTOM: Golpes del Asceta / Mimic Soul ---
		// El Asceta (o Rogue con Mimic) lanza tantos golpes como nivel de skill (ej: 5).
		// El Monk normal lanza tantos golpes como esferas gastó.
		int32 hits = (pc_checkskill(sd, MO_ASCETIC) > 0 || pc_checkskill(sd, RG_MIMIC) > 0) ? skill_lv : sd->spiritball_old;
		
		for (int32 i = 1; i < hits; i++)
			skill_addtimerskill(src, tick + i * 200, target->id, 0, 0, getSkillId(), skill_lv, BF_WEAPON, flag);
		// --- FIN CUSTOM ---
	}
	status_change_end(src, SC_BLADESTOP);
}

void SkillThrowSpiritSphere::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	const status_change* tsc = status_get_sc(target);

	base_skillratio += 500 + skill_lv * 200;
	if (tsc && tsc->getSCE(SC_BLADESTOP))
		base_skillratio += base_skillratio / 2;
#else
	base_skillratio += 60 * skill_lv;

	// --- INICIO CUSTOM: Asceta Steel Body (INT Bonus) ---
	const map_session_data* sd = BL_CAST(BL_PC, src);
	const status_change* sc = status_get_sc(src);
	
	if (sd && pc_checkskill(sd, MO_ASCETIC) > 0 && sc && sc->getSCE(SC_STEELBODY)) {
		const status_data* sstatus = status_get_status_data(*src);
		base_skillratio += sstatus->int_ * 2; // Ratio de INT * 2
	}
	// --- FIN CUSTOM ---
#endif
}