// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "meteorstorm.hpp"

#include <config/core.hpp>

#include "map/status.hpp"

SkillMeteorStorm::SkillMeteorStorm() : SkillImpl(WZ_METEOR) {
}

void SkillMeteorStorm::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	int32 area = skill_get_splash(getSkillId(), skill_lv);
	int16 tmpx = 0, tmpy = 0;
	int16 prev_x = 0, prev_y = 0; // Guardará la posición del primer meteorito
	int32 meteors_per_wave = 2; 

	for (int32 i = 1; i <= skill_get_time(getSkillId(), skill_lv) / skill_get_unit_interval(getSkillId()); i++) {
		for (int32 j = 0; j < meteors_per_wave; j++) {
			
			// Bucle do-while: Si es el segundo meteorito (j == 1), le obligamos a 
			// generar coordenadas nuevas si cae a 3 o menos celdas del primero.
			// Añadimos un límite de 10 intentos (attempts) para evitar bucles infinitos.
			int attempts = 0;
			do {
				tmpx = x - area + rnd() % (area * 2 + 1);
				tmpy = y - area + rnd() % (area * 2 + 1);
				attempts++;
			} while (j == 1 && attempts < 10 && abs(tmpx - prev_x) <= 3 && abs(tmpy - prev_y) <= 3);

			// Si es el primer meteorito, guardamos sus coordenadas para compararlas luego
			if (j == 0) {
				prev_x = tmpx;
				prev_y = tmpy;
			}

			// Le damos 150ms de retraso por cada meteorito extra (j).
			// Así el primero cae en +0ms y el segundo en +150ms.
			int32 visual_delay = j * 150; 

			skill_unitsetting(src, getSkillId(), skill_lv, tmpx, tmpy, flag + i * skill_get_unit_interval(getSkillId()) + visual_delay);
		}
	}
}

void SkillMeteorStorm::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {


#ifdef RENEWAL
	base_skillratio += 25;
#endif
	// --- SOUL OF THE MAGUS: Multiplicador Total ---
	map_session_data* sd = const_cast<map_session_data*>(BL_CAST(BL_PC, src));
	if (sd != nullptr && pc_checkskill(sd, WZ_MAGUSSOUL) > 0) {
		
		// 1. Calculamos el ratio de daño total real (Añadiendo el 100% base)
		int32 total_ratio = 100 + base_skillratio;
		
		// 2. Aplicamos el aumento del +15% de daño real (multiplicativo)
		total_ratio = (total_ratio * 115) / 100;
		
		// 3. Devolvemos la variable al formato "extra" que rAthena espera
		base_skillratio = total_ratio - 100;
	}
}

void SkillMeteorStorm::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	sc_start(src,target,SC_STUN,(3 * skill_lv) / 2,skill_lv,skill_get_time2(getSkillId(),skill_lv));
}
