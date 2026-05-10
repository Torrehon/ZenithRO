// src/map/skills/heavyshot.hpp
#pragma once

#include "../skill_impl.hpp"

class SkillHeavyShot : public WeaponSkillImpl
{
public:
	SkillHeavyShot();

	void calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const override;
};