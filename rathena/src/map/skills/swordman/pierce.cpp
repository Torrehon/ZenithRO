// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "pierce.hpp"

#include "map/status.hpp"
#include "map/pc.hpp" // Añadimos pc.hpp para poder leer la pasiva de Lancer Soul

SkillPierce::SkillPierce() : WeaponSkillImpl(KN_PIERCE) {
}

void SkillPierce::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const status_data* tstatus = status_get_status_data(target);

	// rAthena lee los tamaños así: 0 (Small), 1 (Medium), 2 (Large).
	// Si el tamaño es 2, da 3 hits. Si es cualquier otro, da 2 hits.
	int hits = (tstatus->size == 2) ? 3 : 2;

	dmg.div_= (dmg.div_ > 0 ? hits : -hits);
}

void SkillPierce::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	const status_change* sc = status_get_sc(src);
	const status_data* tstatus = status_get_status_data(*target);

	// 1. Identificamos cuántos golpes vamos a dar 
	int hits = (tstatus != nullptr && tstatus->size == 2) ? 3 : 2;


	// 2. Da 180% por hit a nivel 10.
	int ratio_per_hit = 100 + (8 * skill_lv);

	// 3. Multiplicamos el daño por la cantidad de golpes
	int total_ratio = ratio_per_hit * hits;

	// 4. Ajustamos el ratio base de rAthena
	base_skillratio += (total_ratio - 100);

	// Mantenemos Charging Pierce
	if (sc && sc->getSCE(SC_CHARGINGPIERCE_COUNT) && sc->getSCE(SC_CHARGINGPIERCE_COUNT)->val1 >= 10)
		base_skillratio *= 2;
}

void SkillPierce::modifyHitRate(int16& hit_rate, const block_list* src, const block_list* target, uint16 skill_lv) const {
	// Se mantiene el aumento de precisión base que ya tenía la habilidad
	hit_rate += hit_rate * 5 * skill_lv / 100;
}

