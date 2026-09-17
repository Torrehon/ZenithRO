// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "waterball.hpp"

#include <config/core.hpp>

#include "map/pc.hpp"
#include "map/skill.hpp" // Necesario para skill_attack y BF_MAGIC
#include "map/status.hpp"

SkillWaterBall::SkillWaterBall() : SkillImpl(WZ_WATERBALL) {
}

// Forzamos el comportamiento de 1 solo hit, ignorando la lógica antigua de Water Ball
void SkillWaterBall::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	skill_attack(BF_MAGIC, src, src, target, getSkillId(), skill_lv, tick, flag);
}

void SkillWaterBall::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// Daño inicial al impactar la burbuja (Aumentado para mayor impacto)
	// Ratio: 60% por nivel (300% MATK a lvl 5)
	base_skillratio += (skill_lv * 17);
}

void SkillWaterBall::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// 1. Calculamos el MATK base del Wizard
	int32 base_matk = status_get_matk_max(src);

	// 2. Escalamos el MATK según el nivel de skill (20% a 100%)
	// Nivel 1: (base * 20) / 100
	// Nivel 5: (base * 100) / 100
	int32 final_matk = (base_matk * (20 * skill_lv)) / 100;

	// 3. Fórmula de probabilidad (4% Drown por nivel, 2% Silence por nivel)
	int rate = 4 * skill_lv;
	int duration = 10000;
	
	map_session_data* sd = BL_CAST(BL_PC, src);
	
	// --- INICIO CUSTOM: Hexer Soul / Mimic Soul ---
	// Si es un jugador y tiene Hexer Soul O Mimic Soul...
	if (sd != nullptr && (pc_checkskill(sd, WZ_HEXERSOUL) > 0 || pc_checkskill(sd, RG_MIMIC) > 0)) {
		rate *= 2;               // Buf 1: Doble de probabilidad
		final_matk *= 2;         // Buf 2: +100% de la porción de MATK (el doble)
		duration += 10000;       // Buf 3: 10 segundos extra (pasa de 10000 a 20000 ms)
	}
	// --- FIN CUSTOM ---

	// Aplicamos el estado SC_DROWN, pasando el MATK escalado en val2
	sc_start4(src, target, SC_DROWN, rate, skill_lv, final_matk, 0, 0, duration);
	sc_start4(src, target, SC_SILENCE, rate/2, skill_lv, final_matk, 0, 0, duration);
}