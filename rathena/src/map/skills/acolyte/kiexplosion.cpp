// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "kiexplosion.hpp"

#include <config/core.hpp>

// Necesario para leer la función de splash de rAthena
#include "map/battle.hpp" 
#include "map/skill.hpp"

SkillKiExplosion::SkillKiExplosion() : SkillImpl(MO_BALKYOUNG) {
}

void SkillKiExplosion::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	// Mantenemos el blewcount en 0 para que no empuje a los enemigos fuera del área
	dmg.blewcount = 0;
}

void SkillKiExplosion::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Si flag & 1 es verdadero, significa que estamos procesando a un objetivo afectado por el Splash
	if (flag & 1) {
		skill_attack(skill_get_type(getSkillId()), src, src, target, getSkillId(), skill_lv, tick, flag);
	} else {
		// Si es el objetivo principal, iniciamos el iterador de área para golpear a todos en el rango.
		// Lee directamente el rango que le hayas puesto en skill_db.yml
		map_foreachinrange(skill_area_sub, target, skill_get_splash(getSkillId(), skill_lv), BL_CHAR, src, getSkillId(), skill_lv, tick, flag | BCT_ENEMY | SD_SPLASH | 1, skill_castend_damage_id);
	}
}

void SkillKiExplosion::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	base_skillratio += 700;
#else
	base_skillratio += 300; // Daño base (100) + 300 = 400% total en Pre-Renewal
#endif
}