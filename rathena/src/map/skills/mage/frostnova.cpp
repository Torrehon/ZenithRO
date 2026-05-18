// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "frostnova.hpp"

#include <config/core.hpp>

#include "map/pc.hpp"
#include "map/status.hpp"

// Heredamos de la clase que gestiona el Splash alrededor de un TargetID
SkillFrostNova::SkillFrostNova() : SkillImplRecursiveDamageSplash(WZ_FROSTNOVA) {
}

void SkillFrostNova::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	base_skillratio += 10 * skill_lv;
#else
	base_skillratio += (75 + skill_lv * 10);
#endif
}

void SkillFrostNova::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	map_session_data* sd = BL_CAST(BL_PC, src);

	sc_start(src, target, SC_FREEZE, (sd != nullptr) ? skill_lv * 5 + 33 : skill_lv * 3 + 35, skill_lv, skill_get_time2(getSkillId(), skill_lv));
}