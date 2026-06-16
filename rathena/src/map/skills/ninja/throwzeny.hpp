#pragma once

// Volvemos al include original, WeaponSkillImpl ya vive aquí dentro
#include "../skill_impl.hpp" 

class SkillThrowZeny : public WeaponSkillImpl {
public:
	SkillThrowZeny();

	void calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const override;
	void castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const override;
};