// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "fireball.hpp"

#include "map/pc.hpp"

SkillFireBall::SkillFireBall() : SkillImplRecursiveDamageSplash(MG_FIREBALL) {
}

void SkillFireBall::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// --- BALANCEO CUSTOM ---
	// Formula: 100% base + 50% por nivel (Lv 1: 150% ... Lv 5: 350%)
	base_skillratio = 100 + 50 * skill_lv;

	// Reducción de daño por área:
	// Si el enemigo no es el objetivo principal (está en el borde), recibe el 75% del daño.
	if (wd->miscflag == 2) 
		base_skillratio = base_skillratio * 3 / 4;
}

void SkillFireBall::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	SkillImplRecursiveDamageSplash::castendDamageId(src, target, skill_lv, tick, flag);
}

int64 SkillFireBall::splashDamage(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 flag) const {
	// Esta parte se encarga de calcular la distancia para aplicar la reducción anterior
	if( map_session_data* sd = BL_CAST( BL_PC, src ); sd != nullptr ){
		if (block_list* orig_bl = map_id2bl(skill_area_temp[1]); orig_bl != nullptr)
			flag |= distance_bl(orig_bl, target);
	}

	// Llama a la implementación por defecto de Splash
	return SkillImplRecursiveDamageSplash::splashDamage(src, target, skill_lv, tick, flag);
}