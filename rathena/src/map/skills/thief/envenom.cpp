// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "envenom.hpp"

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillEnvenom::SkillEnvenom() : WeaponSkillImpl(TF_POISON) {
}
void SkillEnvenom::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Como base_skillratio ya es 100, a nivel 10 sumamos 200 (Total: 300%)
	int32 ratio = (20 * skill_lv);

	// Verificamos si el objetivo YA está envenenado
	const status_change *tsc = status_get_sc(target);
	if (tsc && tsc->getSCE(SC_POISON)) {
		// Sumamos 100 extra (Total: 400%)
		ratio += 100; 
	}

	base_skillratio += ratio;
}

void SkillEnvenom::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	map_session_data *sd = BL_CAST(BL_PC, src);
	
	// Probabilidad: 20% + 2% por nivel de skill
	int chance = 20 + (2 * skill_lv);
	
	if (!sc_start2(src, target, SC_POISON, chance, skill_lv, src->id, skill_get_time2(getSkillId(), skill_lv)) && sd)
		clif_skill_fail(*sd, getSkillId());
}