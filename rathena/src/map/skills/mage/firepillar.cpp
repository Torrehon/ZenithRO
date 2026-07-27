// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "firepillar.hpp"

#include "map/unit.hpp"
#include "map/status.hpp" // Necesario para sc_start4 y status_get_matk_max

SkillFirePillar::SkillFirePillar() : SkillImpl(WZ_FIREPILLAR) {
}

void SkillFirePillar::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	//Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	flag |= 1;

	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

void SkillFirePillar::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	base_skillratio += (skill_lv * 8);
}

void SkillFirePillar::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// 1. Mantenemos el walkdelay original (el pequeño "freno" al recibir el golpe)
	unit_set_walkdelay(target, tick, skill_get_time2(getSkillId(), skill_lv), 1);

	// 2. Calculamos el MATK base y lo escalamos (20% a 100% según skill_lv)
	int32 base_matk = status_get_matk_max(src);
	int32 final_matk = (base_matk * (10 * skill_lv)) / 100;

	// 3. Probabilidad de Burning
	int rate = 4 * skill_lv;
	int duration = 10000;

    map_session_data* sd = BL_CAST(BL_PC, src);
	
	// --- INICIO CUSTOM: Hexer Soul / Mimic Soul ---
	// Si es un jugador y tiene Hexer Soul O Mimic Soul...
	if (sd != nullptr && (pc_checkskill(sd, WZ_HEXERSOUL) > 0 || pc_checkskill(sd, RG_MIMIC) > 0)) {
		rate *= 2;               // Buf 1: Doble de probabilidad
		final_matk *= 2;         // Buf 2: +100% de la porción de MATK (el doble)
		duration += 10000;       // Buf 3: 10 segundos extra (pasa de 10000 a 20000 ms)
	}
	// --- FIN CUSTOM ---

	// 4. Aplicamos SC_BURNING (10 segundos de duración)
	// val2 lleva el MATK escalado para que el daño del tick sea coherente con el nivel
	sc_start4(src, target, SC_BURNING, rate, skill_lv, final_matk, 0, 0, duration);

}



// void SkillFirePillar::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	// const map_session_data* sd = BL_CAST(BL_PC, &src);

	// if (sd != nullptr && dmg.div_ > 0)
		// dmg.div_ *= -1; // For players, damage is divided by number of hits
// }