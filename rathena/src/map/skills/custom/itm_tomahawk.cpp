#include "itm_tomahawk.hpp"
#include "../pc.hpp"

// Constructor usando WeaponSkillImpl
SkillItmTomahawk::SkillItmTomahawk() : WeaponSkillImpl(ITM_TOMAHAWK) {
}

void SkillItmTomahawk::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// --- CHIVATO PARA CONFIRMAR QUE ENTRAMOS ---
	ShowInfo("¡CHIVATO! Lanzando hacha. Nivel: %d\n", skill_lv);

	// 1. Aplicamos el Curse (25% al nivel 5)
	if (rnd() % 100 < (skill_lv * 5)) {
		status_change_start(src, target, SC_CURSE, 10000, skill_lv, 0, 0, 0, 10000, SCSTART_NONE);
	}

	// 2. FORZAMOS EL CÁLCULO DE DAÑO DIRECTO
	// Al llamar a 'battle_calc_skill_damage' evitamos que el servidor lo cancele por ser un ítem.
	struct Damage wd = battle_calc_skill_damage(src, target, ITM_TOMAHAWK, skill_lv, flag);
	
	// 3. APLICAMOS EL DAÑO AL OBJETIVO
	battle_delay_damage(tick, am_none, src, target, &wd, ITM_TOMAHAWK, skill_lv, flag);
}

void SkillItmTomahawk::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Aplicamos el Curse (25% al nivel 5)
	if (rnd() % 100 < (skill_lv * 4)) {
		status_change_start(src, target, SC_CURSE, 10000, skill_lv, 0, 0, 0, 10000, SCSTART_NONE);
	}

	// ¡IMPORTANTE! Llamamos a la función padre WeaponSkillImpl
	// Esto es lo que hace que rAthena lance el daño físico automáticamente
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);
}