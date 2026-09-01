// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "shieldboomerang.hpp"

#include <config/core.hpp>
#include "map/pc.hpp"    // Necesario para pc_checkskill
#include "map/skill.hpp" // Necesario para las constantes de las skills
#include "map/status.hpp" // Necesario para status_get_status_data

SkillShieldBoomerang::SkillShieldBoomerang() : WeaponSkillImpl(CR_SHIELDBOOMERANG) {
}

void SkillShieldBoomerang::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// Ratio base normal de Shield Boomerang
	base_skillratio += 50 * skill_lv;

	const map_session_data* sd = BL_CAST(BL_PC, src);
	
	// --- INICIO CUSTOM: Guardian Soul / Mimic Soul (Daño por peso de escudo) ---
	if (sd && (pc_checkskill(sd, CR_GUARDIANSOUL) > 0 || pc_checkskill(sd, RG_MIMIC) > 0)) {
		int16 index = sd->equip_index[EQI_HAND_L];

		if (index >= 0 && sd->inventory_data[index] != nullptr && sd->inventory_data[index]->type == IT_ARMOR) {
			
			int shield_weight = sd->inventory_data[index]->weight;
			int refine_rate = sd->inventory.u.items_inventory[index].refine;
			
			for (int i = 0; i < MAX_SLOTS; i++) {
				int card_id = sd->inventory.u.items_inventory[index].card[i];
				
				if (card_id > 0) {
					auto card_data = itemdb_search(card_id);
					
					if (card_data != nullptr) {
						shield_weight += card_data->weight; 
					}
				}
			}

			int weight_ratio = (shield_weight * (10 + refine_rate*2)) / 100;

			base_skillratio += weight_ratio;
		}
	}

	// --- INICIO CUSTOM: Templar Soul (Daño por VIT) ---
	if (sd && pc_checkskill(sd, CR_GUARDIANSOUL) > 0) {
		base_skillratio += status_get_vit(src);
	}
	// --- FIN CUSTOM ---
}

// void SkillShieldBoomerang::modifyElement(const Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv, int32& element, int32 flag) const {
// #ifdef RENEWAL
	// // flag 1 means the element should be calculated for damage only
	// if (flag & 1)
		// element = ELE_NEUTRAL;
// #endif
// }