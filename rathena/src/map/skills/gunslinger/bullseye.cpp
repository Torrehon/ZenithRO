// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "bullseye.hpp"

#include "map/status.hpp"

SkillBullseye::SkillBullseye() : WeaponSkillImpl(GS_BULLSEYE) {
}

void SkillBullseye::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// --- REWORK TRACER SHOT ---
	// Elimina la restricción de raza y cambia el daño a 50% x nivel de skill
	base_skillratio = 50 * skill_lv;
}

void SkillBullseye::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// --- REWORK TRACER SHOT ---
	// Aplica el estado "Exposed" con 100% de probabilidad en lugar del antiguo Coma
	// Duración: 2 segundos por nivel (1 segundo = 1000 ms)
	t_tick duration = 2000 * skill_lv;
	
	sc_start(src, target, SC_EXPOSED, 100, 1, duration);
}
