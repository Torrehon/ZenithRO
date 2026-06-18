// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "throwhuumashuriken.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"
#include "map/pc.hpp"      
#include "map/status.hpp" 

SkillThrowHuumaShuriken::SkillThrowHuumaShuriken() : SkillImplRecursiveDamageSplash(NJ_HUUMA) {
}

void SkillThrowHuumaShuriken::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	base_skillratio += -150 + 250 * skill_lv;
#else
	base_skillratio += 50 + 150 * skill_lv;
#endif

	// --- MEJORA KENSEI SOUL ---
	// Comprobamos si el atacante es un jugador y tiene la pasiva aprendida
	const map_session_data* sd = BL_CAST(BL_PC, src);
	
	if (sd != nullptr && pc_checkskill(sd, NJ_KENSEISOUL) > 0) {
		// Obtenemos los stats del jugador
		int str_bonus = status_get_str(src);
		int dex_bonus = status_get_dex(src);
		
		// Sumamos 1% de ratio por cada punto de STR y DEX
		base_skillratio += (str_bonus + dex_bonus);
	}
	// --- DETECCIÓN DE HAKAI (+300% Daño) ---
	if (target != nullptr) {
		const status_change* tsc = status_get_sc(target);
		if (tsc && tsc->getSCE(SC_HAKAI)) {
			base_skillratio += 300;
		}
	}
	// --------------------------------------
}

void SkillThrowHuumaShuriken::splashSearch(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 flag) const {
#ifdef RENEWAL
	clif_skill_damage( *src, *target,tick, status_get_amotion(src), 0, DMGVAL_IGNORE, 1, getSkillId(), skill_lv, DMG_SINGLE );
#endif
	SkillImplRecursiveDamageSplash::splashSearch(src, target, skill_lv, tick, flag);
}