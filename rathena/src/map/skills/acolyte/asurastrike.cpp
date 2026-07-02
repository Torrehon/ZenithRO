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
	// INICIALIZAMOS x e y a 0 AQUÍ PARA EVITAR EL WARNING
	int16 x = 0, y = 0, i = 3; // Move 3 cells (From caster)
	int16 dir = map_calc_dir(src,target->x,target->y);

#ifdef RENEWAL
	map_session_data* sd = BL_CAST(BL_PC, src);

	if (sd && sd->spiritball_old > 5)
		flag |= 1; // Give +100% damage increase
#endif
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);

	// CUSTOM: Consume solo el 50% del SP actual en lugar de todo.
	int32 current_sp = status_get_sp(src);
	status_set_sp(src, current_sp / 2, 0);

	status_change_end(src, SC_EXPLOSIONSPIRITS);
	status_change_end(src, SC_BLADESTOP);

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

	// Calculamos el SP que se va a consumir (el 50% del actual)
	int32 sp_consumido = sstatus->sp / 2;
	
	// Forma correcta de obtener el nivel en rAthena:
	int32 base_level = status_get_lv(src); 

	// CUSTOM FORMULA: 100% (base) + 140% * Skill Level + (SP Consumido * Base Level) / 5
	base_skillratio += (140 * skill_lv) + ((sp_consumido * base_level) / 5);

#ifdef RENEWAL
	if (wd->miscflag&1)
		base_skillratio *= 2; // More than 5 spirit balls active
#endif
	base_skillratio = min(500000,base_skillratio); // We stop at roughly 50k SP for overflow protection
}