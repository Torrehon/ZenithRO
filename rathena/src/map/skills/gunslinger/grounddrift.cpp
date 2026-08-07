// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "grounddrift.hpp"

#include <config/core.hpp>

#include "map/itemdb.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillGroundDrift::SkillGroundDrift() : SkillImpl(GS_GROUNDDRIFT) {
}

void SkillGroundDrift::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const status_data* sstatus = status_get_status_data(src);

	dmg.amotion = sstatus->amotion;
	dmg.blewcount = 0;
}

void SkillGroundDrift::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	base_skillratio += 100 + 20 * skill_lv;
#endif

	const map_session_data* sd = BL_CAST(BL_PC, src);
	const status_change* tsc = status_get_sc(target);

	// Poison Sphere: Golpear a enemigos bajo el estado Poison con esta munición aumenta su daño final en un 30%
	if (sd != nullptr && pc_checkskill(sd, GS_ENFORCER) > 0 && tsc != nullptr && (tsc->getSCE(SC_POISON) != nullptr || tsc->getSCE(SC_DPOISON) != nullptr)) {
		if (sd->equip_index[EQI_AMMO] >= 0) {
			int16 ammo_idx = sd->equip_index[EQI_AMMO];
			const item_data* ammo = sd->inventory_data[ammo_idx];
			if (ammo != nullptr && ammo->nameid == 13205) {
				base_skillratio += base_skillratio * 30 / 100;
			}
		}
	}
}

void SkillGroundDrift::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	// Ammo should be deleted right away.
	skill_unitsetting(src, getSkillId(), skill_lv, x, y, 0);
}

void SkillGroundDrift::modifyElement(const Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv, int32& element, int32 flag) const {
	element = dmg.miscflag; // element comes in flag.
}

void SkillGroundDrift::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);
	if (sd == nullptr || pc_checkskill(sd, GS_ENFORCER) <= 0)
		return;

	const status_change* sc = status_get_sc(src);
	if (sc == nullptr || !sc->getSCE(SC_MBULLET))
		return;

	uint16 ammo_id = 0;

	if (sd->equip_index[EQI_AMMO] >= 0) {
		int16 ammo_idx = sd->equip_index[EQI_AMMO];
		const item_data* ammo = sd->inventory_data[ammo_idx];
		if (ammo != nullptr) {
			ammo_id = ammo->nameid;
		}
	}

	int32 final_matk = status_get_matk_max(src);
	int32 rate = 50;
	int32 duration = 20000; // 20 segundos

	switch (ammo_id) {
		case 13203: // Flare Sphere (Fire) -> SC_BURNING (20s, 50%, 100% MATK)
			sc_start4(src, target, SC_BURNING, rate, skill_lv, final_matk, 0, 0, duration);
			break;
		case 13204: // Lightning Sphere (Wind) -> SC_ELECTROCUTE (20s, 50%, 100% MATK)
			sc_start4(src, target, SC_ELECTROCUTE, rate, skill_lv, final_matk, 0, 0, duration);
			break;
		case 13205: // Poison Sphere -> SC_POISON (20s, 50%)
			sc_start(src, target, SC_POISON, rate, skill_lv, duration);
			break;
		case 13207: // Freezing Sphere (Water) -> SC_FREEZING (20s, 50%)
			sc_start(src, target, SC_FREEZING, rate, skill_lv, duration);
			break;
		case 50021: // Tremor Sphere (Earth) -> SC_BURIED (20s, 50%, 100% MATK)
			sc_start4(src, target, SC_BURIED, rate, skill_lv, final_matk, 0, 0, duration);
			break;
		case 13206: // Dark Sphere / Blind Sphere (Shadow) -> SC_DECAY (20s, 50%, 100% MATK)
			sc_start4(src, target, SC_DECAY, rate, skill_lv, final_matk, 0, 0, duration);
			break;
		case 50022: // Light Sphere (Holy) -> SC_PENANCE (20s, 50%, 100% MATK)
			sc_start4(src, target, SC_PENANCE, rate, skill_lv, final_matk, 0, 0, duration);
			break;
		default:
			break;
	}
}
