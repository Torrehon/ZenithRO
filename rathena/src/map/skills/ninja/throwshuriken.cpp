// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "throwshuriken.hpp"

#include <config/core.hpp>
#include "map/status.hpp"
#include "map/pc.hpp"

SkillThrowShuriken::SkillThrowShuriken() : SkillImplRecursiveDamageSplash(NJ_SYURIKEN) {
}

void SkillThrowShuriken::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Ratios y cantidad de golpes (en positivo para la matemática)
	int base_ratio[10] = { 130, 80, 95, 75, 88, 75, 85, 76, 70, 65 };
	int hit_count[10] = { 1, 2, 2, 3, 3, 4, 4, 5, 6, 7 }; 
	
	// Límite de nivel
	uint16 lvl = min(skill_lv, (uint16)10); 
	
	// Tu bono de DEX (+1% por cada 10 DEX)
	int dex_bonus = status_get_dex(src) / 10;
	
	// 1. Daño real de UN solo shuriken
	int damage_por_hit = base_ratio[lvl - 1] + dex_bonus;
	
	// 2. Daño TOTAL (Concentrado para evitar que el cliente divida y no haga nada)
	int total_ratio = damage_por_hit * hit_count[lvl - 1];
	
	// 3. Aplicamos a la base
	base_skillratio += total_ratio - 100;
}

// NUEVA FUNCIÓN: Se ejecuta inmediatamente después de calcular el daño
void SkillThrowShuriken::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	map_session_data* sd = BL_CAST(BL_PC, src);

	// Si es un jugador y tiene la pasiva aprendida, aplica la marca
	if (sd != nullptr && pc_checkskill(sd, NJ_KENSEISOUL) > 0) {
		// sc_start(origen, objetivo, Estado, Probabilidad (10000 = 100%), nivel, Duración en ms)
		sc_start(src, target, SC_HAKAI, 10000, skill_lv, 10000);
	}
}