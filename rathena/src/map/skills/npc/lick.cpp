// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "lick.hpp"

#include "map/clif.hpp"
#include "map/status.hpp"

SkillLick::SkillLick() : SkillImpl(NPC_LICK) {
}

void SkillLick::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	status_data* tstatus = status_get_status_data(*target);
	int64 hp_drain = 0;
	int64 sp_drain = 0;

	if (tstatus) {
		// HP drain: 5% per level (5% at lv 1 to 25% at lv 5)
		hp_drain = (int64)tstatus->max_hp * (skill_lv * 5) / 100;
		if (hp_drain < 1 && tstatus->max_hp > 0)
			hp_drain = 1;

		// SP drain: 10% per level (10% at lv 1 to 50% at lv 5)
		sp_drain = (int64)tstatus->max_sp * (skill_lv * 10) / 100;
		if (sp_drain < 1 && tstatus->max_sp > 0)
			sp_drain = 1;
	}

	// Deal damage to target's HP and SP
	status_damage(src, target, hp_drain, sp_drain, 0, 0, getSkillId());

	// Heal caster with the stolen HP and SP
	if (src && (hp_drain > 0 || sp_drain > 0))
		status_heal(src, hp_drain, sp_drain, 0);

	if (target)
		clif_specialeffect(target, 1741, AREA);

	clif_skill_nodamage(src, *target, getSkillId(), skill_lv,
		sc_start(src, target, skill_get_sc(getSkillId()), (skill_lv * 20), skill_lv, skill_get_time2(getSkillId(), skill_lv)));
}
