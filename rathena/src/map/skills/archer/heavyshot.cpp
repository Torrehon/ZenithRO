// src/map/skills/heavyshot.cpp
#include "heavyshot.hpp"
#include "map/status.hpp"

// Usamos 1024 directo para que coincida exactamente con la ID de la DB
SkillHeavyShot::SkillHeavyShot() : WeaponSkillImpl(AC_HEAVYSHOT) 
{
}

void SkillHeavyShot::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const 
{
	int32 ratio = 100 + (40 * skill_lv);
	ratio += status_get_luk(src) * 3;

	base_skillratio = ratio;
}