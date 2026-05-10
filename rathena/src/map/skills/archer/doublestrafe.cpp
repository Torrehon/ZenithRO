// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "doublestrafe.hpp"
#include <algorithm> // Necesario para std::min
#include "map/pc.hpp"
#include "map/status.hpp"

SkillDoubleStrafe::SkillDoubleStrafe() : WeaponSkillImpl(AC_DOUBLE) {
}

void SkillDoubleStrafe::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// Fórmula original: 100% (base) + 10% por nivel extra (a nv 10 = 190% por hit)
	base_skillratio += 10 * (skill_lv - 1);

	// --- INICIO CUSTOM: MOMENTUM ---
	const status_change* sc = status_get_sc(src);
	if (sc && sc->getSCE(SC_MOMENTUM)) {
		// val1 almacena el número actual de stacks. Lo multiplicamos por 4%
		base_skillratio += sc->getSCE(SC_MOMENTUM)->val1 * 4;
	}
	// --- FIN CUSTOM ---
}

void SkillDoubleStrafe::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// 1. Ejecutamos el impacto y daño de Double Strafe original
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);

	// 2. Lógica de Momentum
	map_session_data* sd = BL_CAST(BL_PC, src);
	
	// IMPORTANTE: Asegúrate de que 1025 es la ID de tu skill en skill_db.yml
	if (sd && pc_checkskill(sd, 1025) > 0) { 
		
		status_change* sc = status_get_sc(src);
		int32 current_stacks = 0;

		// Si ya tiene el buff activo, obtenemos cuántos stacks tiene
		if (sc && sc->getSCE(SC_MOMENTUM)) {
			current_stacks = sc->getSCE(SC_MOMENTUM)->val1;
		}

		// Sumamos 1 stack, asegurándonos de que nunca pase de 10
		int32 new_stacks = std::min(10, current_stacks + 1);

		// Calculamos la duración: (12 - número de stacks) * 1000 milisegundos
		t_tick duration = (12 - new_stacks) * 1000;

		// Refrescamos o iniciamos el estado con la nueva duración y stacks
		sc_start4(src, src, SC_MOMENTUM, 100, new_stacks, 0, 0, 0, duration);
	}
}