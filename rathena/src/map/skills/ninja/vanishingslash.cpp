#include "vanishingslash.hpp"
#include <config/core.hpp>
#include "map/clif.hpp"
#include "map/status.hpp"

SkillVanishingSlash::SkillVanishingSlash() : WeaponSkillImpl(NJ_KASUMIKIRI) {}

void SkillVanishingSlash::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// 100% por nivel
	int32 ratio = 100 * skill_lv;

	const status_change *sc = status_get_sc(src);
	
	// +200% si el combo está activo
	if (sc && sc->getSCE(SC_NJ_COMBO)) {
		ratio += 200; 
	}

	// +2% por cada punto de STR
	ratio += (status_get_str(src))*2;

	base_skillratio += ratio;
}

void SkillVanishingSlash::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	status_change *sc = status_get_sc(src);

	// 1. EJECUTAR DAÑO (Aprovecha el bono del combo)
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);

	// 2. CONSUMIR COMBO (Después del impacto)
	if (sc && sc->getSCE(SC_NJ_COMBO)) {
		status_change_end(src, SC_NJ_COMBO);
	}
}