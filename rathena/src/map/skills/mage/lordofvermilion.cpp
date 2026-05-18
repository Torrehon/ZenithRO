// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "lordofvermilion.hpp"

#include <config/core.hpp>

#include "map/pc.hpp"
#include "map/status.hpp"

SkillLordOfVermilion::SkillLordOfVermilion() : SkillImpl(WZ_VERMILION) {
}

void SkillLordOfVermilion::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	//Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	flag |= 1;

	skill_unitsetting(src, getSkillId(),skill_lv,x,y,0);
}

void SkillLordOfVermilion::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	
	// 1. Usamos const_cast para quitar el estado de 'solo lectura' (const)
	// Así la función pc_checkskill no se quejará de los tipos.
	map_session_data* sd = const_cast<map_session_data*>(BL_CAST(BL_PC, src));

#ifdef RENEWAL
	// ¡Asegúrate de que aquí YA NO haya ningún "const map_session_data* sd..."!
	if(sd)
		base_skillratio += 300 + skill_lv * 100;
	else
		base_skillratio += 20 * skill_lv - 20; //Monsters use old formula
#else
	base_skillratio += 20 * skill_lv - 20;
#endif

	// --- SOUL OF THE MAGUS: Multiplicador Total ---
	if (sd != nullptr && pc_checkskill(sd, WZ_MAGUSSOUL) > 0) {
		
		// 1. Calculamos el ratio de daño total real (Añadiendo el 100% base)
		int32 total_ratio = 100 + base_skillratio;
		
		// 2. Aplicamos el aumento del +15% de daño real (multiplicativo)
		total_ratio = (total_ratio * 115) / 100;
		
		// 3. Devolvemos la variable al formato "extra" que rAthena espera
		base_skillratio = total_ratio - 100;
	}
}

void SkillLordOfVermilion::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// 1. Calculamos el MATK base del Wizard
	int32 base_matk = status_get_matk_max(src);

	// 2. Escalamos el MATK según el nivel de skill (20% a 100%)
	int32 final_matk = (base_matk * (20 * skill_lv)) / 100;

	// 3. Fórmula de probabilidad:
	int rate = 4 * skill_lv;
	int duration = 10000;
	
	// Aquí 'src' NO es const, así que el BL_CAST funciona directo y sin problemas
	map_session_data* sd = BL_CAST(BL_PC, src);
	
	// Si es un jugador y tiene un nivel de WZ_HEXERSOUL mayor a 0...
	if (sd != nullptr && pc_checkskill(sd, WZ_HEXERSOUL) > 0) {
		rate *= 2;               // Buf 1: Doble de probabilidad
		final_matk *= 2;         // Buf 2: +100% de la porción de MATK (el doble)
		duration += 10000;       // Buf 3: 10 segundos extra
	}

	sc_start4(src, target, SC_ELECTROCUTE, rate, skill_lv, final_matk, 0, 0, duration);
	sc_start(src,target,SC_BLIND,min(4*skill_lv,40),skill_lv,skill_get_time2(getSkillId(),skill_lv));
}