// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "jupitelthunder.hpp"
#include "map/status.hpp"

SkillJupitelThunder::SkillJupitelThunder() : SkillImpl(WZ_JUPITEL) {
}

void SkillJupitelThunder::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	//Jupitel Thunder is delayed by 150ms, you can cast another spell before the knockback
	skill_addtimerskill(src, tick + TIMERSKILL_INTERVAL, target->id, 0, 0, getSkillId(), skill_lv, 1, flag);
}
void SkillJupitelThunder::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// 1. Calculamos el MATK base del Wizard
	int32 base_matk = status_get_matk_max(src);

	// 2. Escalamos el MATK según el nivel de skill (20% a 100%)
	// Nivel 1: (base * 20) / 100
	// Nivel 5: (base * 100) / 100
	int32 final_matk = (base_matk * (10 * skill_lv)) / 100;

	// 3. Fórmula de probabilidad
	
	int rate = 4 * skill_lv;
	int duration = 10000;
	
	map_session_data* sd = BL_CAST(BL_PC, src);
	
	// Si es un jugador y tiene un nivel de WZ_HEXERSOUL mayor a 0...
	if (sd != nullptr && pc_checkskill(sd, WZ_HEXERSOUL) > 0) {
		rate *= 2;               // Buf 1: Doble de probabilidad
		final_matk *= 2;         // Buf 2: +100% de la porción de MATK (el doble)
		duration += 10000;       // Buf 3: 10 segundos extra (pasa de 10000 a 20000 ms)
	}

	sc_start4(src, target, SC_ELECTROCUTE, rate, skill_lv, final_matk, 0, 0, duration);

}