// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "bomb.hpp"

#include <config/core.hpp>

#include <algorithm> // Añadido para std::min
#include "map/pc.hpp"
#include "map/status.hpp" // Añadido para leer e infligir estados alterados

SkillBomb::SkillBomb() : SkillImpl(AM_DEMONSTRATION) {
}

void SkillBomb::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	//Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	flag|=1;

	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

void SkillBomb::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// base_skillratio empieza en 100 por defecto.
	if (skill_lv == 5) {
		base_skillratio += 150; // 100 + 150 = 250%
	} else {
		// Nivel 1: 10 + 10 = +20 (120%)
		// Nivel 2: 10 + 20 = +30 (130%)
		// Nivel 3: 10 + 30 = +40 (140%)
		// Nivel 4: 10 + 40 = +50 (150%)
		base_skillratio += 10 + (10 * skill_lv);
	}
}
void SkillBomb::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	skill_attack(BF_MAGIC, src, src, target, getSkillId(), skill_lv, tick, flag);
}
void SkillBomb::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
#ifdef RENEWAL
	skill_break_equip(src,target, EQP_WEAPON, 300 * skill_lv, BCT_ENEMY);
#else
	skill_break_equip(src,target, EQP_WEAPON, 100*skill_lv, BCT_ENEMY);
#endif

	// --- INICIO CUSTOM: Chemical Burn (Soul of the Apothecary) ---
	map_session_data* sd = BL_CAST(BL_PC, src);
	
	if (sd && (pc_checkskill(sd, AM_APOTHECARY) > 0 || pc_checkskill(sd, RG_MIMIC) > 0)) {
		
		status_change* sc = status_get_sc(target);
		int32 current_stacks = 0;

		// Si el enemigo ya tiene Chemical Burn, obtenemos cuántos stacks tiene
		if (sc && sc->getSCE(SC_CHEMBURN)) {
			current_stacks = sc->getSCE(SC_CHEMBURN)->val1;
		}

		// Sumamos 1 stack por cada "tick" de daño del fuego, hasta un máximo de 10
		int32 new_stacks = std::min(10, current_stacks + 1);

		// Aplicamos o refrescamos el estado al ENEMIGO (target)
		// rate = 100%, val1 = new_stacks, duración = 20000ms (20s)
		sc_start(src, target, SC_CHEMBURN, 100, new_stacks, 20000);
	}
	// --- FIN CUSTOM ---
}