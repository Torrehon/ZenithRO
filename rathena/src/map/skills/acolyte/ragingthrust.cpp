// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "ragingthrust.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"   
#include "map/pc.hpp"     
#include "map/status.hpp" 

SkillRagingThrust::SkillRagingThrust() : WeaponSkillImpl(MO_COMBOFINISH) {
}

void SkillRagingThrust::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const status_change* sc = status_get_sc(&src);

	// --- CUSTOM: 2 golpes con 10 stacks de Relentless ---
	if (sc && sc->getSCE(SC_RELENTLESS) && sc->getSCE(SC_RELENTLESS)->val1 >= 10) {
		dmg.div_ = 2; 
	}
}

void SkillRagingThrust::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	map_session_data* sd = BL_CAST(BL_PC, src);

	// Si es el golpe principal Y tiene la Soul of the Pugilist, hacemos el Área
	if (!(flag&1) && sd && pc_checkskill(sd, MO_PUGILIST) > 0) {
		
		// 1. Área
		map_foreachinshootrange(skill_area_sub, target,
			skill_get_splash(getSkillId(), skill_lv), BL_CHAR|BL_SKILL,
			src, getSkillId(), skill_lv, tick, flag|BCT_ENEMY|1,
			skill_castend_damage_id);

		// 2. Lógica de Stacks "Relentless"
		status_change* sc = status_get_sc(src);
		if (sc && sc->getSCE(SC_EXPLOSIONSPIRITS)) {
			status_change_entry* sce_relent = sc->getSCE(SC_RELENTLESS);
			int stacks = sce_relent ? sce_relent->val1 : 0;

			if (stacks < 10) {
				sc_start4(src, src, SC_RELENTLESS, 100, stacks + 1, 0, 0, 0, 60000);
				clif_specialeffect(src, 368, AREA); 
			} else {
				sc_start4(src, src, SC_RELENTLESS, 100, 10, 0, 0, 0, 60000);
			}
		}
	} else {
		// Si NO es Pugilista, o si es un enemigo salpicado, aplica daño normal
		WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);
	}
}

void SkillRagingThrust::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	const status_data* sstatus = status_get_status_data(*src);
	base_skillratio += 450 + 50 * skill_lv + sstatus->str; 
#else
	base_skillratio += 140 + 60 * skill_lv;
#endif

	if (const status_change* sc = status_get_sc(src); sc != nullptr && sc->getSCE(SC_GT_ENERGYGAIN))
		base_skillratio += base_skillratio * 50 / 100;

	// --- CUSTOM: Steel Body Combo Bonus ---
	const status_change* sc_src = status_get_sc(src);
	if (sc_src && sc_src->getSCE(SC_STEELBODY)) {
		const status_data* sstatus_src = status_get_status_data(*src);
		base_skillratio += sstatus_src->vit * 2; 
	}

	// // --- CUSTOM: Doble daño con 10 stacks de Relentless ---
	// if (sc_src && sc_src->getSCE(SC_RELENTLESS) && sc_src->getSCE(SC_RELENTLESS)->val1 >= 10) {
		// base_skillratio *= 2; 
	// }
}