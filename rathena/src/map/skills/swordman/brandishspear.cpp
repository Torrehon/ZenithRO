// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "brandishspear.hpp"

#include <config/core.hpp>

#include "map/pc.hpp"
#include "map/status.hpp"

SkillBrandishSpear::SkillBrandishSpear() : SkillImpl(KN_BRANDISHSPEAR) {
}

void SkillBrandishSpear::castendNoDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	skill_area_temp[0] = map_foreachinallrange(skill_area_sub, target, skill_get_splash(getSkillId(), skill_lv), BL_CHAR, src, getSkillId(), skill_lv, tick, BCT_ENEMY, skill_area_sub_count);
	map_foreachinrange(skill_area_sub, target, skill_get_splash(getSkillId(), skill_lv), BL_CHAR|BL_SKILL, src, getSkillId(), skill_lv, tick, flag | BCT_ENEMY | SD_SPLASH | 1, skill_castend_damage_id);
}

void SkillBrandishSpear::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Ejecución limpia del ataque
	skill_attack(skill_get_type(getSkillId()), src, src, target, getSkillId(), skill_lv, tick, (skill_area_temp[0]) > 0 ? SD_ANIMATION | skill_area_temp[0] : skill_area_temp[0]);
}

void SkillBrandishSpear::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, &src);

	// Por defecto asume 2 hits
	int hits = 2;

	// Solo pega 3 veces si el jugador tiene la pasiva KN_LANCERSOUL
	if (sd != nullptr && pc_checkskill(sd, KN_LANCERSOUL) > 0) {
		hits = 3;
	}

	dmg.div_ = hits;
}

void SkillBrandishSpear::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);
	const status_data* sstatus = status_get_status_data(*src);

	int hits = 2;
	if (sd != nullptr && pc_checkskill(sd, KN_LANCERSOUL) > 0) {
		hits = 3;
	}

	// AJUSTE 1: Daño base. A nivel 10 = 100% por hit.
	// 3 hits = 300% total.
	int ratio_per_hit = 20 + (8 * skill_lv);
	int total_ratio = ratio_per_hit * hits;

	// AJUSTE 2: Escalado de STR (1% extra por cada 2 puntos de STR pura)
	if (sstatus != nullptr) {
		total_ratio += (sstatus->str);
	}

	// AJUSTE 3: Sinergia de Stagger. (+50% plano)
	const status_change* tsc = status_get_sc(target);
	if (tsc != nullptr && tsc->getSCE(SC_STAGGER)) {
		total_ratio += 150;
	}

	// Ajustamos el base_skillratio de rAthena (restamos el 100% que aplica por defecto)
	base_skillratio += (total_ratio - 100);
}