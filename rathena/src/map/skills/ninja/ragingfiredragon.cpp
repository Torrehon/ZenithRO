// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "ragingfiredragon.hpp"

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp" // Necesario para SC_BURNING y sc_start

SkillRagingFireDragon::SkillRagingFireDragon() : SkillImpl(NJ_BAKUENRYU) {
}

void SkillRagingFireDragon::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);

	// Nueva fórmula custom de daño: 100% + 80% * Skill Level
	base_skillratio += 80 * skill_lv;
	if(sd && sd->spiritcharm_type == CHARM_TYPE_FIRE && sd->spiritcharm > 0)
		base_skillratio += 100 * sd->spiritcharm;
}

void SkillRagingFireDragon::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	//Place units around target
	clif_skill_nodamage(src, *target, getSkillId(), skill_lv);
	skill_unitsetting(src, getSkillId(), skill_lv, target->x, target->y, 0);
}

void SkillRagingFireDragon::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	flag|=1;//Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

// --- SOUL OF THE KUJI / MIMIC SOUL: 30% Burning al nivel 10 ---
void SkillRagingFireDragon::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	int32 base_matk = status_get_matk_max(src);
	
	map_session_data* sd = BL_CAST(BL_PC, src);

	// Si tiene Soul of the Kuji O Mimic Soul
	if (sd != nullptr && (pc_checkskill(sd, NJ_KUJISOUL) > 0 || pc_checkskill(sd, RG_MIMIC) > 0)) {
		if (skill_lv == 5) {
			sc_start4(src, target, SC_BURNING, 30, skill_lv, base_matk, 0, 0, 10000);
		}
	}
}