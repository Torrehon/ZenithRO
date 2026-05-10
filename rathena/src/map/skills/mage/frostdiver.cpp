// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "frostdiver.hpp"

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

// 1. Cambiamos SkillImpl por SkillImplRecursiveDamageSplash
SkillFrostDiver::SkillFrostDiver() : SkillImplRecursiveDamageSplash(MG_FROSTDIVER) {
}

void SkillFrostDiver::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
    // Definimos el daño: 100% base + 30% por nivel (250% al nivel 5)
	base_skillratio = 100 + 30 * skill_lv;
}

void SkillFrostDiver::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
    // 2. Usamos la función de la clase Splash para que el motor busque objetivos en el área del YAML
	SkillImplRecursiveDamageSplash::castendDamageId(src, target, skill_lv, tick, flag);
}

void SkillFrostDiver::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	map_session_data *sd = BL_CAST(BL_PC, src);
	
	// Probabilidad de congelar fija al 33% para cada enemigo alcanzado por el área
	if (!sc_start(src, target, SC_FREEZE, 33, skill_lv, skill_get_time2(getSkillId(), skill_lv)) && sd)
		clif_skill_fail(*sd, getSkillId());
}