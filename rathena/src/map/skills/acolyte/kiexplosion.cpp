// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "kiexplosion.hpp"

#include <config/core.hpp>

SkillKiExplosion::SkillKiExplosion() : SkillImpl(MO_BALKYOUNG) {
}

void SkillKiExplosion::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	// Mantenemos el blewcount en 0 para que no empuje a los enemigos fuera del área
	dmg.blewcount = 0;
}

void SkillKiExplosion::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	base_skillratio += 700;
#else
	base_skillratio += 300; // Daño base (100) + 300 = 400% total en Pre-Renewal
#endif
}