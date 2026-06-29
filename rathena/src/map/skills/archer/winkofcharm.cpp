// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "winkofcharm.hpp"

#include <config/core.hpp>
#include "map/battle.hpp"
#include "map/clif.hpp"
#include "map/mob.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillWinkofCharm::SkillWinkofCharm() : SkillImpl(DC_WINKCHARM) {
}

// --- INICIO CUSTOM: División visual de los golpes (Truco Kamaitachi) ---
void SkillWinkofCharm::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, &src);
	const status_change* tsc = status_get_sc(&target);

	int hits = 1;

	// Si el objetivo tiene la marca Unnerved, da 3 hits
	if (sd && pc_checkskill(sd, BD_DISSONANT) > 0 && tsc && tsc->getSCE(SC_UNNERVED)) {
		hits = 3;
	}

	dmg.div_ = hits;
}
// --- FIN CUSTOM ---

void SkillWinkofCharm::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Daño base: 250% MATK
	base_skillratio += 150; 
}

void SkillWinkofCharm::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// 1. Lanzamos el ataque mágico (llama automáticamente a calculateSkillRatio y a modifyDamageData sin fallar por Flinch)
	skill_attack(BF_MAGIC, src, src, target, getSkillId(), skill_lv, tick, flag);

	// 2. Efecto de estado reducido a 50%
	sc_start(src, target, SC_WINKCHARM, 50, skill_lv, skill_get_time(getSkillId(), skill_lv));

	// 3. Consumo de la marca Unnerved
	const map_session_data* sd = BL_CAST(BL_PC, src);
	if (sd && pc_checkskill(sd, BD_DISSONANT) > 0) {
		status_change* tsc = status_get_sc(target);
		if (tsc && tsc->getSCE(SC_UNNERVED)) {
			// Borramos el estado para que no puedan espamear el remate
			status_change_end(target, SC_UNNERVED, INVALID_TIMER);
		}
	}
}