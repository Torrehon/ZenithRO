// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "bash.hpp"

#include "../../pc.hpp"
#include "../../status.hpp"

SkillBash::SkillBash() : WeaponSkillImpl(SM_BASH) {
}

void SkillBash::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// 1. Intentamos obtener los datos del jugador (por si lo usa un monstruo, evitar crashes)
	const map_session_data* sd = BL_CAST(BL_PC, src);

	// 2. Lógica para Armas a Dos Manos (Solo jugadores)
	if (sd != nullptr && sd->status.weapon == W_2HSWORD) {
		// Arma a dos manos: 150% + (40% x skilLv) - 550% max
		// base_skillratio inicia en 100. Sumamos 50 fijos + el escalado.
		base_skillratio += 50 + (40 * skill_lv);
	} 
	// 3. Lógica para Armas a Una Mano (Y por defecto para monstruos/mercenarios)
	else {
		// Arma a una mano: 130% + (32% x skilLv) - 450% max
		// base_skillratio inicia en 100. Sumamos 30 fijos + el escalado.
		base_skillratio += 30 + (32 * skill_lv);
	}
}


void SkillBash::modifyHitRate(int16& hit_rate, const block_list* src, const block_list* target, uint16 skill_lv) const {
	// It is proven that bonus is applied on final hitrate, not hit.
	// +5% hit per level
	hit_rate += hit_rate * 5 * skill_lv / 100;
}

void SkillBash::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	map_session_data* sd = BL_CAST(BL_PC, src);

	if (sd != nullptr && skill_lv > 5 && pc_checkskill(sd, SM_FATALBLOW) > 0) {
		// BaseChance gets multiplied with BaseLevel/50.0; 500/50 simplifies to 10 [Playtester]
		int32 stun_chance = (skill_lv - 5) * sd->status.base_level * 10;
		status_change_start(src, target, SC_STUN, stun_chance, skill_lv, 0, 0, 0, skill_get_time2(getSkillId(), skill_lv), SCSTART_NONE);
	}
}
