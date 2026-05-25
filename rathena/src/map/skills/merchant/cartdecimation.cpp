// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "cartdecimation.hpp"
#include "../../clif.hpp"
#include "../../map.hpp"
#include "../../status.hpp"
#include "../../skill.hpp"
#include "../../pc.hpp"

SkillCartDecimation::SkillCartDecimation() : SkillImpl(BS_DECIMATION) {
}

void SkillCartDecimation::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Ratio base: 100% físico nativo + 300% extra + Vit*2
	base_skillratio += 300 + (status_get_vit(src) * 2);

	// --- LECTURA DE CARGAS ---
	const status_change* sc = status_get_sc(src);
	if (sc && sc->getSCE(SC_SAVAGERY)) {
		int stacks = sc->getSCE(SC_SAVAGERY)->val1;
		
		// 1. Sumamos el 40% normal por cada carga
		base_skillratio += stacks * 40;

		// 2. ¡EL CLÍMAX! Si tiene exactamente 10 cargas, aumentamos el daño en 1,5
		if (stacks == 10) {
			base_skillratio = (base_skillratio * 15) / 10; 
		}
	}
}


void SkillCartDecimation::castendNoDamageId(block_list *src, block_list *bl, uint16 skill_lv, t_tick tick, int32& flag) const {
	e_skill skillId = getSkillId();
	
	skill_area_temp[1] = 0;
	
	// 1. Ejecutamos el ataque. Esto calculará el daño llamando a calculateSkillRatio
	map_foreachinshootrange(skill_area_sub, src, skill_get_splash(skillId, skill_lv), BL_SKILL | BL_CHAR,
							src, skillId, skill_lv, tick, flag | BCT_ENEMY | 1, skill_castend_damage_id);
							
	clif_skill_nodamage(src, *src, skillId, skill_lv);

	// 2. --- CONSUMIR SAVAGERY ---
	// Lo borramos justo después de golpear, para asegurarnos de que la fórmula
	// de daño anterior pudo leer los stacks correctamente.
	status_change_end(src, SC_SAVAGERY);
}

void SkillCartDecimation::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	if (flag & 1) {
		skill_attack(skill_get_type(getSkillId()), src, src, target, getSkillId(), skill_lv, tick, flag | SD_ANIMATION);
	}
}