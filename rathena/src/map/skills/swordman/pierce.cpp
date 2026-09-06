// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "pierce.hpp"

#include "map/status.hpp"
#include "map/pc.hpp" // Añadimos pc.hpp para poder leer la pasiva de Lancer Soul

SkillPierce::SkillPierce() : WeaponSkillImpl(KN_PIERCE) {
}

void SkillPierce::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const status_data* tstatus = status_get_status_data(target);

	// Custom: Small y Medium = 2 hits, Large = 3 hits
	int hits = (tstatus != nullptr && tstatus->size >= SZ_BIG) ? 3 : 2;

	dmg.div_ = (dmg.div_ > 0 ? hits : -hits);
}

void SkillPierce::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	const status_change* sc = status_get_sc(src);

	// 1. Ratio Base por golpe individual (A Nivel 10 = 180% por hit)
	int ratio_per_hit = 100 + (8 * skill_lv);

	// 2. Ajustamos el ratio base de rAthena por golpe individual.
	// rAthena se encarga automáticamente de multiplicarlo por dmg.div_ (1, 2 o 3 hits según tamaño).
	base_skillratio += (ratio_per_hit - 100);

	// 3. Mantenemos el multiplicador de Charging Pierce (x2)
	if (sc && sc->getSCE(SC_CHARGINGPIERCE_COUNT) && sc->getSCE(SC_CHARGINGPIERCE_COUNT)->val1 >= 10)
		base_skillratio *= 2;
}

void SkillPierce::modifyHitRate(int16& hit_rate, const block_list* src, const block_list* target, uint16 skill_lv) const {
	// Se mantiene el aumento de precisión base que ya tenía la habilidad
	hit_rate += hit_rate * 5 * skill_lv / 100;
}

