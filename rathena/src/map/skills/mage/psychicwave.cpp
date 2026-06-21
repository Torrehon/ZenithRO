// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "psychicwave.hpp"

#include <config/core.hpp>

#include "map/pc.hpp"
#include "map/status.hpp"

SkillPsychicWave::SkillPsychicWave() : SkillImpl(SO_PSYCHIC_WAVE) {
}

void SkillPsychicWave::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, &src);

	// --- INICIO CUSTOM: Soul of the Arcanist (2 Hits) ---
	if (sd != nullptr && pc_checkskill(sd, SA_ARCSOUL) > 0) {
		// Si tiene la pasiva y lleva Bastón (de 1 o 2 manos) o Libro, golpea 2 veces
		if (sd->weapontype1 == W_STAFF || sd->weapontype1 == W_2HSTAFF) {
			dmg.div_ = 2;
		}
	}
	// --- FIN CUSTOM ---
}

void SkillPsychicWave::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &skillratio, int32 mflag) const {
	const status_data* sstatus = status_get_status_data(*src);

	// Ratio de daño base oficial de Psychic Wave
	skillratio += -100 + 20 * skill_lv;
	
	// (Se ha eliminado el código oficial que aumentaba el daño con las invocaciones del Sorcerer)
}

void SkillPsychicWave::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	flag|=1; // Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

void SkillPsychicWave::modifyElement(const Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv, int32& element, int32 flag) const {
	const map_session_data* sd = BL_CAST(BL_PC, &src);
	const status_change* sc = status_get_sc(&src);

	// --- INICIO CUSTOM: Soul of the Arcanist (Elemento del Endow) ---
	if (sd && pc_checkskill(sd, SA_ARCSOUL) > 0 && sc != nullptr && !sc->empty()) {
		// Comprobamos qué Endow tiene activo el Sage para heredar su elemento
		if (sc->hasSCE(SC_FIREWEAPON)) element = ELE_FIRE;
		else if (sc->hasSCE(SC_WATERWEAPON)) element = ELE_WATER;
		else if (sc->hasSCE(SC_WINDWEAPON)) element = ELE_WIND;
		else if (sc->hasSCE(SC_EARTHWEAPON)) element = ELE_EARTH;
	}
	// --- FIN CUSTOM ---
}