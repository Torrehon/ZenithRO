// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "hammerfall.hpp"
#include <algorithm> // Necesario para std::min
#include "map/pc.hpp"
#include "map/status.hpp"

SkillHammerFall::SkillHammerFall() : SkillImplRecursiveDamageSplash(BS_HAMMERFALL) {
}

void SkillHammerFall::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// 1. Ratio Base y Vit
	base_skillratio += 20 * skill_lv;
	base_skillratio += status_get_vit(src);

	// 2. Mejoras de la Soul of the Juggernaut / Mimic Soul
	const map_session_data* sd = BL_CAST(BL_PC, src);
	if (sd) {
		bool is_jugger = (pc_checkskill(sd, BS_JUGGERNAUTSOUL) > 0);
		bool is_mimic  = (pc_checkskill(sd, RG_MIMIC) > 0);

		if (is_jugger || is_mimic) {
			// A. Aumento de daño por cargas de Savagery (+10% por carga) para ambos
			const status_change* sc = status_get_sc(src);
			if (sc && sc->getSCE(SC_SAVAGERY)) {
				base_skillratio += sc->getSCE(SC_SAVAGERY)->val1 * 10;
			}

			// B. Doble golpe con Hacha de 2 manos (EXCLUSIVO Blacksmith / Juggernaut)
			if (is_jugger && sd->status.weapon == W_2HAXE && wd != nullptr) {
				const_cast<Damage*>(wd)->div_ = 2;
			}
		}
	}
}

void SkillHammerFall::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	// 1. Ejecutamos el ataque de área original
	SkillImplRecursiveDamageSplash::castendPos2(src, x, y, skill_lv, tick, flag);

	// 2. Lógica de Savagery (1 carga por uso de la habilidad)
	map_session_data* sd = BL_CAST(BL_PC, src);
	if (sd) {
		bool is_jugger = (pc_checkskill(sd, BS_JUGGERNAUTSOUL) > 0 && pc_checkskill(sd, BS_HILTBINDING) > 0);
		bool is_mimic  = (pc_checkskill(sd, RG_MIMIC) > 0); // El Rogue solo necesita la Mimic Soul, sin Hilt Binding

		if (is_jugger || is_mimic) {
			status_change* sc = status_get_sc(src);
			int32 current_stacks = 0;

			// Si ya tiene el buff activo, obtenemos cuántos stacks tiene
			if (sc && sc->getSCE(SC_SAVAGERY)) {
				current_stacks = sc->getSCE(SC_SAVAGERY)->val1;
			}
			
			// Sumamos 1 stack, asegurándonos de que nunca pase de 10
			int32 new_stacks = std::min(10, current_stacks + 1);

			// Refrescamos o iniciamos el estado (100 = probabilidad 100%, 10 segundos)
			sc_start(src, src, SC_SAVAGERY, 100, new_stacks, 10000);
			
			// --- INICIO CUSTOM: Efecto al llegar al máximo de cargas ---
			// Si antes teníamos menos de 10, y ahora tenemos 10... ¡Boom!
			if (current_stacks < 10 && new_stacks == 10) {
				clif_specialeffect(src, 1996, AREA);
			}
			// --- FIN CUSTOM ---
		}
	}
}

void SkillHammerFall::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// 20% (2000) base + 6% (600) por nivel
	int stun_chance = 2000 + 400 * skill_lv;
	
	status_change_start(src, target, SC_STUN, stun_chance, skill_lv, 0, 0, 0, skill_get_time2(getSkillId(), skill_lv), SCSTART_NONE);
}