// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "thunderstorm.hpp"

SkillThunderStorm::SkillThunderStorm() : SkillImpl(MG_THUNDERSTORM) {
}

void SkillThunderStorm::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Mantenemos la lógica de la unidad de la skill en el suelo
	flag |= 1;
	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

void SkillThunderStorm::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// --- BALANCEO CUSTOM ---
	// Cada impacto (hit) hará un 90% de daño.
	// Como la skill escala en número de hits por nivel (Lv 1 = 1 hit, Lv 5 = 5 hits),
	// el daño total al nivel 5 será: 90% * 5 = 450%.
	base_skillratio = 90;
}
