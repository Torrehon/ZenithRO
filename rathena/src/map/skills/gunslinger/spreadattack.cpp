// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "spreadattack.hpp"

#include "map/pc.hpp"
#include "map/status.hpp"

SkillSpreadAttack::SkillSpreadAttack() : SkillImplRecursiveDamageSplash(GS_SPREADATTACK) {
}

void SkillSpreadAttack::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, &src);
	const status_change* sc = status_get_sc(&src);

	if (sd != nullptr && pc_checkskill(sd, GS_ENFORCER) > 0 && sc != nullptr && sc->getSCE(SC_ADJUSTMENT)) {
		dmg.div_ = 2;
	}
}

void SkillSpreadAttack::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	base_skillratio += 30 * skill_lv;
#else
	base_skillratio += 30 * (skill_lv - 1);
#endif
}
