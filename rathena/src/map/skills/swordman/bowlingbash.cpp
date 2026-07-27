// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "bowlingbash.hpp"

#include <config/core.hpp>

#include <common/db.hpp>

#include "map/battle.hpp"
#include "map/pc.hpp"
#include "map/unit.hpp"

SkillBowlingBash::SkillBowlingBash() : SkillImpl(KN_BOWLINGBASH) {
}

void SkillBowlingBash::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, &src);

	// Por defecto, Bowling Bash siempre da 2 hits.
	dmg.div_ = 2;

	if (sd != nullptr) {
		// --- INICIO CUSTOM: Knight Blader Soul (Espada a 2 Manos) ---
		if (sd->status.weapon == W_2HSWORD && pc_checkskill(sd, KN_BLADERSOUL) > 0) {
			if (dmg.miscflag >= 4)
				dmg.div_ = 4; // 4 hits si hay 4 o más enemigos
			else if (dmg.miscflag >= 3)
				dmg.div_ = 3; // 3 hits si hay 3 enemigos
		}
		// --- INICIO CUSTOM: Rogue Mimic Soul (Espada a 1 Mano) ---
		else if (sd->status.weapon == W_1HSWORD && pc_checkskill(sd, RG_MIMIC) > 0) {
			if (dmg.miscflag >= 3)
				dmg.div_ = 3; // Hasta 3 hits si hay 3 o más enemigos
		}
		// --- FIN CUSTOM ---
	}
}

void SkillBowlingBash::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);
	
	// Calculamos el número de hits bajo la misma lógica que modifyDamageData
	int hits = 2;

	if (sd != nullptr) {
		// --- INICIO CUSTOM: Knight Blader Soul (Espada a 2 Manos) ---
		if (sd->status.weapon == W_2HSWORD && pc_checkskill(sd, KN_BLADERSOUL) > 0) {
			if (mflag >= 4)
				hits = 4;
			else if (mflag >= 3)
				hits = 3;
		}
		// --- INICIO CUSTOM: Rogue Mimic Soul (Espada a 1 Mano) ---
		else if (sd->status.weapon == W_1HSWORD && pc_checkskill(sd, RG_MIMIC) > 0) {
			if (mflag >= 3)
				hits = 3;
		}
		// --- FIN CUSTOM ---
	}

	// Tu fórmula: 100% + (10% * nivel) por cada hit.
	int ratio_per_hit = 100 + (10 * skill_lv);
	int total_ratio = ratio_per_hit * hits;

	// Ajuste para el ratio de rAthena (restamos el 100% base)
	base_skillratio += (total_ratio - 100);
}

void SkillBowlingBash::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Mantenemos la lógica de área limpia de Renewal
	if (flag & 1) {
		skill_attack(skill_get_type(getSkillId()), src, src, target, getSkillId(), skill_lv, tick, (skill_area_temp[0]) > 0 ? SD_ANIMATION | skill_area_temp[0] : skill_area_temp[0]);
	} else {
		skill_area_temp[0] = map_foreachinallrange(skill_area_sub, target, skill_get_splash(getSkillId(), skill_lv), BL_CHAR, src, getSkillId(), skill_lv, tick, BCT_ENEMY, skill_area_sub_count);
		map_foreachinrange(skill_area_sub, target, skill_get_splash(getSkillId(), skill_lv), BL_CHAR|BL_SKILL, src, getSkillId(), skill_lv, tick, flag | BCT_ENEMY | SD_SPLASH | 1, skill_castend_damage_id);
	}
}