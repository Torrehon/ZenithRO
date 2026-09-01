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
	const map_session_data* sd = BL_CAST(BL_PC, &src);

	// Determina la cantidad de golpes según la cantidad de esferas consumidas (o skill_lv si es Asceta)
	int32 hits = 1;
	if (sd != nullptr) {
		hits = (pc_checkskill(sd, MO_ASCETIC) > 0) ? skill_lv : sd->spiritball_old;
	}
	if (hits <= 0) hits = 1;

	// Le pasamos el número de golpes (1 a 5) a rAthena para que el cliente haga 1 SOLA animación limpia oficial
	dmg.div_ = (dmg.div_ > 0 ? hits : -hits);
}

void SkillThrowSpiritSphere::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Ejecución limpia oficial de 1 solo casteo con N hits divididos por dmg.div_
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);

	status_change_end(src, SC_BLADESTOP);
}

void SkillThrowSpiritSphere::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	const status_change* tsc = status_get_sc(target);

	base_skillratio += 500 + skill_lv * 200;
	if (tsc && tsc->getSCE(SC_BLADESTOP))
		base_skillratio += base_skillratio / 2;
#else
	base_skillratio += 30 * skill_lv;

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