// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "sandattack.hpp"

#include "map/pc.hpp"
#include "map/status.hpp"

// 1. Cambiamos el padre al de ataques en área
SkillSandAttack::SkillSandAttack() : SkillImplRecursiveDamageSplash(TF_SPRINKLESAND) {
}

// 2. Tu fórmula de daño y escalado por DEX
void SkillSandAttack::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// base_skillratio ya trae 100. Sumamos 100 para llegar a tu 200% base.
	int32 ratio = 100; 

	// Sumamos 1% por cada punto de DEX
	const map_session_data *sd = BL_CAST(BL_PC, src);
	if (sd) {
		ratio += sd->status.dex; 
	}

	base_skillratio += ratio;
}

// 3. Tu 30% fijo de ceguera
void SkillSandAttack::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	sc_start(src, target, SC_BLIND, 30, skill_lv, skill_get_time2(getSkillId(), skill_lv));
}

// 4. AQUÍ ESTÁ LA RECETA QUE FALTABA: La ejecución del área
void SkillSandAttack::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	// Bandera para la animación del área
	flag |= SD_PREAMBLE; 

	// Llamada a la lógica recursiva del Splash
	SkillImplRecursiveDamageSplash::castendDamageId(src, target, skill_lv, tick, flag);
}