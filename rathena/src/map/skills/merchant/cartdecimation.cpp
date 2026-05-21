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
	// Ratio base: 100% físico nativo + 300% extra = 400%
	base_skillratio += 300 + (status_get_vit(src) * 2);
}

void SkillCartDecimation::castendNoDamageId(block_list *src, block_list *bl, uint16 skill_lv, t_tick tick, int32& flag) const {
	e_skill skillId = getSkillId();
	
	// Limpiamos la memoria del área (obligatorio para el bucle del motor)
	skill_area_temp[1] = 0;
	
	// Buscamos a los enemigos alrededor y les pasamos la "bandera" (flag | BCT_ENEMY | 1)
	map_foreachinshootrange(skill_area_sub, src, skill_get_splash(skillId, skill_lv), BL_SKILL | BL_CHAR,
							src, skillId, skill_lv, tick, flag | BCT_ENEMY | 1, skill_castend_damage_id);
							
	// Efecto visual en ti mismo
	clif_skill_nodamage(src, *src, skillId, skill_lv);
}

void SkillCartDecimation::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Aquí está el gatillo: si viene del bucle de área (flag & 1), ejecutamos el ataque.
	if (flag & 1) {
		// skill_attack calcula el daño, el elemento del arma y ejecuta el Knockback del DB.
		skill_attack(skill_get_type(getSkillId()), src, src, target, getSkillId(), skill_lv, tick, flag | SD_ANIMATION);
	}
}