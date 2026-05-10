// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "cartrevolution.hpp"
#include "map/pc.hpp"

SkillCartRevolution::SkillCartRevolution() : SkillImplRecursiveDamageSplash(MC_CARTREVOLUTION) {
}

void SkillCartRevolution::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const map_session_data *sd = BL_CAST(BL_PC, src);

	// --- NUEVA FÓRMULA:
	base_skillratio = 100 + (70 * skill_lv);

	// --- BONO EXTRA: Overcharge (20% extra por nivel) ---
	int32 over_lv = 0;
	if (sd && (over_lv = pc_checkskill(sd, MC_OVERCHARGE)) > 0) {
		base_skillratio += (over_lv * 20);
	}

}


void SkillCartRevolution::modifyHitRate(int16 &hit_rate, const block_list *src, const block_list *target, uint16 skill_lv) const {
	const map_session_data *sd = BL_CAST(BL_PC, src);

	// Mantenemos el bono oficial de Cart Remodeling de Genetic si existe
	if (sd && pc_checkskill(sd, GN_REMODELING_CART))
		hit_rate += pc_checkskill(sd, GN_REMODELING_CART) * 4;
}

void SkillCartRevolution::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Esta bandera es vital para que el cliente procese bien el primer golpe de área
	flag |= SD_PREAMBLE; 

	// Llamamos a la lógica base de daño en splash (recursiva)
	SkillImplRecursiveDamageSplash::castendDamageId(src, target, skill_lv, tick, flag);
}