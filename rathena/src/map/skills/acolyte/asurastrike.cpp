// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "asurastrike.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"
#include "map/unit.hpp"

SkillAsuraStrike::SkillAsuraStrike() : WeaponSkillImpl(MO_EXTREMITYFIST) {
}

void SkillAsuraStrike::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	int16 x = 0, y = 0, i = 3; // Move 3 cells (From caster)
	int16 dir = map_calc_dir(src,target->x,target->y);

#ifdef RENEWAL
	map_session_data* sd = BL_CAST(BL_PC, src);

	if (sd && sd->spiritball_old > 5)
		flag |= 1; // Give +100% damage increase
#endif
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);

	// --- INICIO CUSTOM: Asura consume la mitad del SP actual ---
	int32 current_sp = status_get_sp(src);
	status_set_sp(src, current_sp / 2, 0);

	status_change_end(src, SC_EXPLOSIONSPIRITS);
	status_change_end(src, SC_BLADESTOP);
	status_change_end(src, SC_RELENTLESS);
	// IMPORTANTE: Ya no aplicamos el SC_EXTREMITYFIST, por lo que el jugador 
	// NO sufre la penalización de no poder regenerar SP durante 5 minutos.
	// --- FIN CUSTOM ---

	// Lógica de coordenadas para el empuje (Dash)
	if (dir > 0 && dir < 4)
		x = -i;
	else if (dir > 4)
		x = i;
	else
		x = 0;

	if (dir > 2 && dir < 6)
		y = -i;
	else if (dir == 7 || dir < 2)
		y = i;
	else
		y = 0;

	if (unit_movepos(src, src->x + x, src->y + y, 1, 1)) {
		clif_blown(src);
		clif_spiritball(src);
	}
}

void SkillAsuraStrike::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	const status_data* sstatus = status_get_status_data(*src);
	const map_session_data* sd = BL_CAST(BL_PC, src);

	// Calculamos el SP que se va a consumir (el 50% del actual)
	int32 sp_consumido = sstatus->sp / 2;
	int32 base_level = status_get_lv(src); 

	// 100% (Base de la skill) + 140% * Skill Level (Común para las 3 ramas)
	base_skillratio += (140 * skill_lv);

	// --- INICIO CUSTOM: Bifurcación de Fórmulas ---
	if (sd && pc_checkskill(sd, MO_PUGILIST) > 0) {
		// RAMA 1: PUGILIST (Escalado por STR, VIT y Stacks de Relentless)
		// Base sólida: ~110k-120k en combo sin stacks, y ~160k casteado normal con 10 stacks (-30% en combo)
		base_skillratio += (sp_consumido * 6);
		base_skillratio += (sstatus->str * 100);
		base_skillratio += (sstatus->vit * 80);
		
		const status_change* sc = status_get_sc(src);
		if (sc && sc->getSCE(SC_RELENTLESS)) {
			int stacks = sc->getSCE(SC_RELENTLESS)->val1;
			base_skillratio += (sstatus->str * stacks * 9);
		}
	} 
	else if (sd && pc_checkskill(sd, MO_ASCETIC) > 0) {
		// RAMA 2: ASCETIC (Especialista en Esferas, SP & Asura Máximo)
		base_skillratio += (sp_consumido * 16);
		
		// sd->spiritball_old guarda cuántas esferas tenía justo en el momento de castear (hasta 10 esferas)
		int spheres = sd->spiritball_old;
		base_skillratio += (sstatus->int_ * spheres * 4);
	} 
	else {
		// RAMA 3: BÁSICO (Sin almas)
		base_skillratio += (sp_consumido * 4);
	}
	// --- FIN CUSTOM ---

#ifdef RENEWAL
	if (wd->miscflag&1)
		base_skillratio *= 2; // More than 5 spirit balls active
#endif
	base_skillratio = min(500000,base_skillratio); // We stop at roughly 50k SP for overflow protection
}