#pragma once

#include "../skill_impl.hpp"

class SkillMcTomahawk : public WeaponSkillImpl {
public:
	SkillMcTomahawk();
	virtual void calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const override;
	virtual void castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const override;
};