// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "backstab.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"
#include "map/unit.hpp"

SkillBackStab::SkillBackStab() : WeaponSkillImpl(RG_BACKSTAP) {
}

void SkillBackStab::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, &src);

	if (sd != nullptr) {
		// --- EXCLUSIVO NIGHTBLADE: 2 hits garantizados con cualquier arma ---
		if (pc_checkskill(sd, RG_NIGHTBLADE) > 0) {
			dmg.div_ = 2;
		} 
		// Comportamiento normal (sin Nightblade): 2 hits solo si lleva daga
		else if (sd->status.weapon == W_DAGGER) {
			dmg.div_ = 2;
		}
	}
}

void SkillBackStab::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Ratio de daño unificado original para cualquier arma: 200 + 30 * Skill Level
	base_skillratio += 100 + (20 * skill_lv);


}

void SkillBackStab::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Calculamos la dirección y posición a la espalda del objetivo (estilo Renewal)
	uint8 dir = map_calc_dir(src, target->x, target->y);
	int16 x = 0, y = 0;

	if (dir > 0 && dir < 4)
		x = -1;
	else if (dir > 4)
		x = 1;

	if (dir > 2 && dir < 6)
		y = -1;
	else if (dir == 7 || dir < 2)
		y = 1;

	// Salto automático a la espalda del objetivo si la casilla es caminable (easy=1, checkpath=1)
	if (unit_movepos(src, target->x + x, target->y + y, 1, 1)) {
		status_change_end(src, SC_HIDING);

		// Rotamos al objetivo para que reciba el golpe por la espalda
		dir = (dir < 4) ? dir + 4 : dir - 4;
		unit_setdir(target, dir);

		// Actualizamos posición visual en el cliente
		clif_blown(src);
	} else {
		status_change_end(src, SC_HIDING);
	}

	// Ejecutar la aplicación de daño propia de WeaponSkillImpl (sin recursión infinita)
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);
}

void SkillBackStab::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	map_session_data* sd = BL_CAST(BL_PC, src);
	if (!sd) return;

	// --- EXCLUSIVO NIGHTBLADE: Provocar estados alterados según el arma ---
	if (pc_checkskill(sd, RG_NIGHTBLADE) > 0) {
		
		int rate = 50; // 50% de probabilidad base
		int duration = 10000; 
		
		// Usamos sd->weapontype1 para leer el tipo de arma principal equipada en la mano derecha
		switch (sd->weapontype1) {
			case W_DAGGER:
			{
				// Laceration: Pasamos el ATK (Base + Arma) del caster en la variable val2
				int32 atk = sd->battle_status.batk + sd->battle_status.rhw.atk;
				// sc_start4 nos permite pasar parámetros extendidos al gestor de estados
				sc_start4(src, target, SC_LACERATION, rate, skill_lv, atk, 0, 0, duration);
				break;
			}
			case W_1HSWORD:
			case W_2HSWORD:
				// Concussion: Reduce la defensa un 30% (o el valor definido en status.cpp para MVPs)
				sc_start(src, target, SC_CONCUSSION, rate, skill_lv, duration);
				break;
			case W_BOW:
				// Marked: Reduce velocidad de movimiento y ASPD
				sc_start(src, target, SC_MARKED, rate, skill_lv, duration);
				break;
		}
	}
}

void SkillBackStab::modifyHitRate(int16& hit_rate, const block_list* src, const block_list* target, uint16 skill_lv) const {
	// Opcional: Pequeño bono de Hit Rate basado en el nivel de la skill para compensar que pueda fallar
	hit_rate += skill_lv; 
}