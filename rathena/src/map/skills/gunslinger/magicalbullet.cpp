// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "magicalbullet.hpp"

#include "map/clif.hpp"
#include "map/status.hpp"

SkillMagicalBullet::SkillMagicalBullet() : SkillImpl(GS_MAGICALBULLET) {
}

void SkillMagicalBullet::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	status_change *tsc = status_get_sc(target);
	
	// ¡AQUÍ ESTÁ LA CLAVE! 
	// Nos saltamos el skill_get_sc() y le asignamos directamente el SC de tu código original.
	sc_type type = SC_MBULLET; 
	
	status_change_entry *tsce = (tsc) ? tsc->getSCE(type) : nullptr;

	// Toggle OFF: Si ya lo tiene, se lo quitamos.
	// (Aunque el flag Toggleable a veces lo intercepta antes, ponerlo aquí asegura que funcione visualmente y sin bugs).
	if (tsce) {
		clif_skill_nodamage(src, *target, getSkillId(), skill_lv, status_change_end(target, type));
		return;
	}

	// Toggle ON: Lo encendemos usando el -1 (infinito) que tenías originalmente.
	clif_skill_nodamage(src, *target, getSkillId(), skill_lv, sc_start(src, target, type, 100, skill_lv, -1));
}