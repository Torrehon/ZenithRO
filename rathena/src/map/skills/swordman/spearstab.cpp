// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "spearstab.hpp"

#include "map/pc.hpp"     
#include "map/status.hpp" 
#include "map/unit.hpp"

SkillSpearStab::SkillSpearStab() : SkillImpl(KN_SPEARSTAB) {
}

void SkillSpearStab::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	dmg.blewcount = 0;
}

void SkillSpearStab::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	if (flag & 1) {
		int animation = (skill_area_temp[0] > 0) ? (SD_ANIMATION | skill_area_temp[0]) : SD_ANIMATION;
		
		if (skill_attack(BF_WEAPON, src, src, target, getSkillId(), skill_lv, tick, animation)) {
			// 1. Empujamos a ESTE enemigo 6 celdas hacia atrás
			skill_blown(src, target, 6, -1, BLOWN_NONE);
			
			// 2. Aplicamos SC_STAGGER solo si: 
			// - Es un jugador (sd != nullptr)
			// - Tiene la pasiva Lancer Soul
			// - Tiene equipada una lanza a 2 manos (W_2HSPEAR)
			map_session_data* sd = BL_CAST(BL_PC, src);
			if (sd != nullptr && pc_checkskill(sd, KN_LANCERSOUL) > 0 && sd->status.weapon == W_2HSPEAR) {
				sc_start(src, target, SC_STAGGER, 100, skill_lv, 5000); 
			}
		}
	} else {
		int splash = skill_get_splash(getSkillId(), skill_lv);
		
		if (splash > 0) {
			skill_area_temp[0] = map_foreachinallrange(skill_area_sub, target, splash, BL_CHAR, src, getSkillId(), skill_lv, tick, BCT_ENEMY, skill_area_sub_count);
			map_foreachinrange(skill_area_sub, target, splash, BL_CHAR|BL_SKILL, src, getSkillId(), skill_lv, tick, flag | BCT_ENEMY | SD_SPLASH | 1, skill_castend_damage_id);
		} else {
			skill_castend_damage_id(target, src, getSkillId(), skill_lv, tick, flag | BCT_ENEMY | 1);
		}
	}
}

void SkillSpearStab::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	base_skillratio += 50 * skill_lv;
}