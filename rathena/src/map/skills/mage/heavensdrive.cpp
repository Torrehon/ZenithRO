// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "heavensdrive.hpp"

#include <config/core.hpp>

#include "map/status.hpp"
#include "map/clif.hpp"

SkillHeavensDrive::SkillHeavensDrive() : SkillImpl(WZ_HEAVENDRIVE) {
}

void SkillHeavensDrive::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	flag |= 1;

	// Determinamos el número de instancias según el nivel:
	// Lv 1 - 5 (Jugadores): 2 instancias (1 garantizada + 1 aleatoria)
	// Lv 6 - 10 (Combate MVP Lv 10): 3 instancias (1 garantizada + 2 aleatorias)
	// Lv > 10 (Castigo Rude Attack Lv 20): 6 instancias (1 garantizada + 5 aleatorias)
	int32 instances = 2;
	if (skill_lv > 10) {
		instances = 6;
	} else if (skill_lv > 5) {
		instances = 3;
	}

	int32 spread = 3;

	for (int32 i = 0; i < instances; i++) {
		int16 cur_x, cur_y;

		if (i == 0) {
			// La primera instancia SIEMPRE impacta exactamente en el objetivo original
			cur_x = x;
			cur_y = y;
		} else {
			// Las instancias adicionales erupcionan aleatoriamente alrededor
			cur_x = x + (rnd() % (spread * 2 + 1)) - spread;
			cur_y = y + (rnd() % (spread * 2 + 1)) - spread;
		}

		// Mostramos la animación visual de estalagmitas exactamente en la coordenada real
		clif_skill_poseffect(*src, getSkillId(), skill_lv, cur_x, cur_y, tick);

		// Creamos la unidad de daño en la misma coordenada
		skill_unitsetting(src, getSkillId(), skill_lv, cur_x, cur_y, 0);
	}
}

void SkillHeavensDrive::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	base_skillratio += 25;
#endif
    base_skillratio +=  (skill_lv * 17);
}

void SkillHeavensDrive::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	status_change_end(target, SC_SV_ROOTTWIST);
	
	// 1. Mantenemos el walkdelay original
	unit_set_walkdelay(target, tick, skill_get_time2(getSkillId(), skill_lv), 1);

	// 2. Valores Base
	int32 base_matk = status_get_matk_max(src);
	int32 final_matk = (base_matk * (20 * skill_lv)) / 100;
	
    // 3. Chance de ocurrir
	int rate = 8 * skill_lv; 
	int duration = 10000; // 10 segundos base (en milisegundos)

	// --- 4. COMPROBACIÓN: SOUL OF THE HEXER ---
	// Convertimos la entidad origen a un puntero de jugador (PC)
	map_session_data* sd = BL_CAST(BL_PC, src);
	
	// --- INICIO CUSTOM: Hexer Soul / Mimic Soul ---
	// Si es un jugador y tiene Hexer Soul O Mimic Soul...
	if (sd != nullptr && (pc_checkskill(sd, WZ_HEXERSOUL) > 0 || pc_checkskill(sd, RG_MIMIC) > 0)) {
		rate *= 2;               // Buf 1: Doble de probabilidad
		final_matk *= 2;         // Buf 2: +100% de la porción de MATK (el doble)
		duration += 10000;       // Buf 3: 10 segundos extra (pasa de 10000 a 20000 ms)
	}
	// --- FIN CUSTOM ---

	// 5. Aplicamos SC_BURIED con los valores dinámicos
	sc_start4(src, target, SC_BURIED, rate, skill_lv, final_matk, 0, 0, duration);
}