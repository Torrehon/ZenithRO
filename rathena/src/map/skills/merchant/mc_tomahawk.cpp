#include "mc_tomahawk.hpp"
#include <map/pc.hpp>

// Usamos el nombre oficial registrado
SkillMcTomahawk::SkillMcTomahawk() : WeaponSkillImpl(MC_TOMAHAWK) {
}

void SkillMcTomahawk::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);
	
	base_skillratio = 100 + (20 * skill_lv);
	
	if (sd) {
		base_skillratio += (pc_checkskill(sd, AM_AXEMASTERY) * 10);
	}
}

void SkillMcTomahawk::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	if (rnd() % 100 < (skill_lv * 4)) {
		status_change_start(src, target, SC_CURSE, 10000, skill_lv, 0, 0, 0, 10000, SCSTART_NONE);
	}
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);
}