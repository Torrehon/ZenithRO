#include "holysmite.hpp"
#include "../../pc.hpp"
#include "../../status.hpp"
#include "../../clif.hpp"

SkillHolySmite::SkillHolySmite() : WeaponSkillImpl(AL_HOLYSMITE) {
}

void SkillHolySmite::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	clif_specialeffect(target, 152, AREA); // Tu cruz sagrada
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag); // El daño normal
}

void SkillHolySmite::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	base_skillratio += 30 * skill_lv;
	base_skillratio += status_get_str(src);
}

void SkillHolySmite::modifyDamageData(Damage& wd, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, &src);
	if (sd && pc_checkskill(sd, AL_ZEALOT) > 0) {
		wd.damage *= 2; 
		wd.div_ = 2;
	}
}