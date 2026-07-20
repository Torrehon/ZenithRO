// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "homunculus_avoid.hpp"

#include "map/clif.hpp"
#include "map/status.hpp"
#include "map/mob.hpp"        // Necesario para leer mob_data (Plantas)
#include "map/pc.hpp"         // Necesario para BL_CAST
#include "map/homunculus.hpp" // Necesario para leer homun_data

// --- CUSTOM: Escáner para dar velocidad a las Plantas ---
static int skill_avoid_plants_sub(block_list* bl, va_list ap) {
	block_list* src = va_arg(ap, block_list*);
	homun_data* hd = va_arg(ap, homun_data*);
	sc_type type = (sc_type)va_arg(ap, int);
	uint16 skill_lv = (uint16)va_arg(ap, int);
	int time = va_arg(ap, int);

	if (bl->type == BL_MOB) {
		mob_data* md = (mob_data*)bl;
		// Verificar que el mob pertenezca al Master y sea de la raza Planta
		if (hd->master && md->master_id == hd->master->id && md->status.race == RC_PLANT) {
			// Aplicar el estado de velocidad
			sc_start(src, bl, type, 100, skill_lv, time);
			// Mostrar la animación de la skill sobre la planta para confirmar visualmente
			clif_skill_nodamage(src, *bl, HLIF_AVOID, skill_lv, 1);
		}
	}
	return 1;
}

SkillAvoid::SkillAvoid() : SkillImpl(HLIF_AVOID) {
}

void SkillAvoid::castendNoDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	homun_data* hd = BL_CAST(BL_HOM, src);
	if (!hd) return; // Seguridad

	sc_type type = skill_get_sc(getSkillId());
	int time = skill_get_time(getSkillId(), skill_lv);

	// Master
	sc_start(src, target, type, 100, skill_lv, time);
	// Homunculus
	clif_skill_nodamage(src, *src, getSkillId(), skill_lv, sc_start(src, src, type, 100, skill_lv, time));

	// --- CUSTOM: Escanear todo el mapa en busca de Plantas del Master ---
	// Pasamos (int)type para asegurar compatibilidad con va_list
	map_foreachinmap(skill_avoid_plants_sub, src->m, BL_MOB, src, hd, (int)type, (int)skill_lv, time);
}