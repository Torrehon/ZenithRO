// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "finalstrike.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"
#include "map/map.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"
#include "map/unit.hpp"

SkillFinalStrike::SkillFinalStrike() : WeaponSkillImpl(NJ_ISSEN) {}

void SkillFinalStrike::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const map_session_data *sd = BL_CAST(BL_PC, src);
	const status_change *sc = status_get_sc(src);

	int32 ratio = 0;

	// --- INICIO CUSTOM: Kensei Soul vs Mimic Soul ---
	bool is_kensei = (sd && pc_checkskill(sd, NJ_KENSEISOUL) > 0);
	bool is_mimic  = (sd && pc_checkskill(sd, RG_MIMIC) > 0);

	if (is_mimic) {
		// Rogue con Mimic: Daño base de 500% + 50% por nivel
		ratio = 500 + (50 * skill_lv);

		// Si se usa bajo el estado de Close Confine, aumenta el daño final un 50%
		if (sc && sc->getSCE(SC_CLOSECONFINE)) {
			ratio += ratio / 2; // Aumento del 50%
		}
	} else {
		// Fórmula original del Ninja / Kensei
		ratio = 500 + (50 * skill_lv);

		// Escalado con STR: Cada punto de STR añade 2% adicional
		ratio += (status_get_str(src) * 2);

		// Lógica Zantetsuken Ready
		if (sc && sc->getSCE(SC_ZANTETSU)) {
			if (skill_lv == 10) {
				ratio *= 2; // Nivel 10: Dobla todo el daño final
			} else {
				ratio += 200; // Resto de niveles: Aumenta ratio en 200%
			}
		}
	}
	// --- FIN CUSTOM ---

	base_skillratio += ratio;
}

void SkillFinalStrike::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	int16 x, y;
	int16 dir = map_calc_dir(src, target->x, target->y);

	int16 i = 2; // Move 2 cells (From target)

	if (dir > 0 && dir < 4)
		x = -i;
	else if (dir > 4)
		x = i;
	else
		x = 0;
	if (dir > 2 && dir < 6)
		y = -i;
	else if (dir == 7 || dir < 2)
		y = i;
	else
		y = 0;

	status_change *sc = status_get_sc(src);
	map_session_data *sd = BL_CAST(BL_PC, src);

#ifdef RENEWAL
	// Doesn't have slide effect in GVG
	if (skill_check_unit_movepos(5, src, target->x + x, target->y + y, 1, 1)) {
		clif_blown(src);
		clif_spiritball(src);
	}
	skill_attack(BF_MISC, src, src, target, getSkillId(), skill_lv, tick, flag);
	status_set_hp(src, umax(status_get_max_hp(src) / 100, 1), 0);
	
	// CONSUMIR MARCA ZANTETSU
	if (sc && sc->getSCE(SC_ZANTETSU)) {
		status_change_end(src, SC_ZANTETSU);
	}

	// --- INICIO CUSTOM: Consumir Close Confine para el Rogue ---
	if (sd && pc_checkskill(sd, RG_MIMIC) > 0 && sc && sc->getSCE(SC_CLOSECONFINE)) {
		status_change_end(src, SC_CLOSECONFINE);
	}
	// --- FIN CUSTOM ---
#else
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);

	status_change_end(src, SC_HIDING);
	status_change_end(src, SC_NEN);
	// CONSUMIR MARCA ZANTETSU
	if (sc && sc->getSCE(SC_ZANTETSU)) {
		status_change_end(src, SC_ZANTETSU);
	}

	// --- INICIO CUSTOM: Consumir Close Confine para el Rogue ---
	if (sd && pc_checkskill(sd, RG_MIMIC) > 0 && sc && sc->getSCE(SC_CLOSECONFINE)) {
		status_change_end(src, SC_CLOSECONFINE);
	}
	// --- FIN CUSTOM ---

	// Doesn't have slide effect in GVG
	if (skill_check_unit_movepos(5, src, target->x + x, target->y + y, 1, 1)) {
		clif_blown(src);
		clif_spiritball(src);
	}
#endif
}
