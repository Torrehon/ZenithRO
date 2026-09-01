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
	// Por defecto 2 hits. 3 hits si tiene pasiva KN_LANCERSOUL
	int hits = 2;
	if (sd != nullptr && pc_checkskill(sd, KN_LANCERSOUL) > 0) {
		hits = 3;
	}
	dmg.div_ = hits;
}

void SkillBrandishSpear::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);
	const status_data* sstatus = status_get_status_data(*src);

	// 1. Determinar número de hits (2 por defecto, 3 con pasiva Lancer Soul)
	int hits = 2;
	if (sd != nullptr && pc_checkskill(sd, KN_LANCERSOUL) > 0) {
		hits = 3;
	}

	// 2. Ratio Base por golpe (A Nivel 10 = 150% por hit)
	int ratio_per_hit = 50 + (10 * skill_lv); // Nivel 1 = 60%, Nivel 10 = 150%

	// 3. Escalado de STR (+1% por cada 2 puntos de STR total a CADA hit)
	if (sstatus != nullptr) {
		ratio_per_hit += (sstatus->str / 2); // Con 100 STR = +50% por hit -> 200% por hit
	}

	// 4. Daño TOTAL acumulado antes de Stagger
	int total_ratio = ratio_per_hit * hits; // Con 3 hits y 100 STR = 600% total

	// 5. Sinergia de Stagger (+300% con Lanza a 2 Manos, +150% con Lanza a 1 Mano)
	const status_change* tsc = status_get_sc(target);
	if (tsc != nullptr && tsc->getSCE(SC_STAGGER)) {
		if (sd != nullptr && sd->status.weapon == W_2HSPEAR) {
			total_ratio += 300; // +300% al ratio TOTAL con Lanza a 2 Manos
		} else {
			total_ratio += 150; // +150% al ratio TOTAL con Lanza a 1 Mano
		}

		// Elimina/consume el estado Stagger del objetivo tras aprovechar el combo
		status_change_end(const_cast<block_list*>(target), SC_STAGGER);
	}

	// 6. Convertimos el ratio total al ratio por hit individual para rAthena
	int final_ratio_per_hit = total_ratio / hits;

	// Ajustamos el base_skillratio de rAthena
	base_skillratio += (final_ratio_per_hit - 100);
}