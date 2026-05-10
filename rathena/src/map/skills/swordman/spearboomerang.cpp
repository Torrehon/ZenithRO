// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "spearboomerang.hpp"

#include "map/pc.hpp"     
#include "map/itemdb.hpp" 

SkillSpearBoomerang::SkillSpearBoomerang() : WeaponSkillImpl(KN_SPEARBOOMERANG) {
}

void SkillSpearBoomerang::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// 1. Ratio base de la skill (100% base + 50% por nivel)
	base_skillratio += 50 * skill_lv;

	// 2. Cálculo del daño adicional según el peso (Solo si tiene la pasiva Lancer Soul)
	const map_session_data* sd = BL_CAST(BL_PC, src);
	
	// Añadimos pc_checkskill para validar que conoce la habilidad
	if (sd != nullptr && pc_checkskill(sd, KN_LANCERSOUL) > 0) {
		int16 index = sd->equip_index[EQI_HAND_R];

		if (index >= 0 && sd->inventory_data[index] != nullptr && sd->inventory_data[index]->type == IT_WEAPON) {
			
			int weapon_weight = sd->inventory_data[index]->weight;
			
			for (int i = 0; i < MAX_SLOTS; i++) {
				int card_id = sd->inventory.u.items_inventory[index].card[i];
				
				if (card_id > 0) {
					auto card_data = itemdb_search(card_id);
					
					if (card_data != nullptr) {
						weapon_weight += card_data->weight; 
					}
				}
			}

			// Aplicamos tu cálculo final (dividido entre 4)
			base_skillratio += (weapon_weight / 4);
		}
	}
}