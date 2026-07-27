// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "lightningstrikeofdestruction.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp" // Necesario para sc_start y SC_ELECTROCUTE

SkillLightningStrikeOfDestruction::SkillLightningStrikeOfDestruction() : SkillImpl(NJ_RAIGEKISAI) {
}

void SkillLightningStrikeOfDestruction::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);

	// Nueva fórmula custom de daño: 100% + 80% * Skill Level
	base_skillratio += 80 * skill_lv;

	// Se mantiene el bono de daño si el Ninja usa Charms de viento
	if(sd && sd->spiritcharm_type == CHARM_TYPE_WIND && sd->spiritcharm > 0)
		base_skillratio += 20 * sd->spiritcharm;
}

// Lógica de casteo para que el área de daño (Unit) se genere sobre el objetivo
void SkillLightningStrikeOfDestruction::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	clif_skill_nodamage(target, *target, getSkillId(), skill_lv);
	skill_unitsetting(src, getSkillId(), skill_lv, target->x, target->y, 0);
}

void SkillLightningStrikeOfDestruction::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	//Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	flag |= 1;

	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

// --- SOUL OF THE KUJI / MIMIC SOUL: 30% Electrocute al nivel 5 ---
void SkillLightningStrikeOfDestruction::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {

    int32 base_matk = status_get_matk_max(src);
	
	map_session_data* sd = BL_CAST(BL_PC, src);
	// Comprobamos que el usuario tiene Kuji Soul o Mimic Soul aprendida
	if (sd != nullptr && (pc_checkskill(sd, NJ_KUJISOUL) > 0 || pc_checkskill(sd, RG_MIMIC) > 0)) {
		// Comprobamos el nivel de la habilidad
		if (skill_lv == 5) {
			sc_start4(src, target, SC_ELECTROCUTE, 30, skill_lv, base_matk, 0, 0, 10000);
		}
	}
}