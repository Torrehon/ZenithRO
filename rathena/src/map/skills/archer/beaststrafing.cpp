// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "beaststrafing.hpp"
#include <algorithm>
#include "map/pc.hpp"
#include "map/status.hpp"

SkillBeastStrafing::SkillBeastStrafing() : SkillImpl(HT_POWER) {
}

void SkillBeastStrafing::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// 1. Ejecutamos el impacto y daño de Power Strafe.
	// Esto llamará internamente a calculateSkillRatio antes de hacer el daño.
	skill_attack(BF_WEAPON, src, src, target, getSkillId(), skill_lv, tick, flag);

	// 2. Lógica de Finisher: Consumir Momentum
	map_session_data* sd = BL_CAST(BL_PC, src);
	status_change* sc = status_get_sc(src);
	
	// --- INICIO CUSTOM: Shooter Soul / Mimic Soul ---
	// Si el jugador tiene Soul of the Sharpshooter O Mimic Soul, y tiene stacks de Momentum activos
	if (sd && (pc_checkskill(sd, HT_SHOOTERSOUL) > 0 || pc_checkskill(sd, RG_MIMIC) > 0) && sc && sc->getSCE(SC_MOMENTUM)) { 
		// Removemos completamente el estado de Momentum, "gastando" las cargas.
		status_change_end(src, SC_MOMENTUM, INVALID_TIMER);
	}
	// --- FIN CUSTOM ---
}

void SkillBeastStrafing::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// Daño base por hit: 100% + 20% * Skill Level
	int32 hit_ratio = 100 + 20 * skill_lv;

	// --- INICIO CUSTOM: MOMENTUM + SOUL OF THE SHARPSHOOTER / MIMIC SOUL ---
	map_session_data* sd = BL_CAST(BL_PC, const_cast<block_list*>(src));
	const status_change* sc = status_get_sc(src);
	
	// Verificamos si tiene el buff activo y es un jugador
	if (sc && sc->getSCE(SC_MOMENTUM) && sd) {
		
		if (pc_checkskill(sd, HT_SHOOTERSOUL) > 0) {
			// Hunter: Aumenta un 15% por cada stack de Momentum
			hit_ratio += sc->getSCE(SC_MOMENTUM)->val1 * 15;
			
		} else if (pc_checkskill(sd, RG_MIMIC) > 0) {
			// Rogue: Aumenta un 5% por cada stack de Momentum
			hit_ratio += sc->getSCE(SC_MOMENTUM)->val1 * 5;
		}
	}
	// --- FIN CUSTOM ---

	base_skillratio = hit_ratio;
}