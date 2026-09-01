// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "smite.hpp"
#include "map/status.hpp"
#include "map/skill.hpp" // Necesario para skill_area_temp, skill_area_sub, etc.

SkillSmite::SkillSmite() : WeaponSkillImpl(CR_SHIELDCHARGE) {
}

void SkillSmite::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// Ratio base normal de Smite
	base_skillratio += 30 * skill_lv;

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

			// En rAthena C++, shield_weight viene multiplicado por 10 (ej: Escudo de peso 140 -> 1400 en C++)
			// Fórmula limpia usando shield_weight directamente:
			// +0  refino -> (1400 * 10) / 100 = +140% ratio
			// +5  refino -> (1400 * 20) / 100 = +280% ratio
			// +10 refino -> (1400 * 30) / 100 = +420% ratio
			int weight_ratio = (shield_weight * (10 + refine_rate)) / 100;

			base_skillratio += weight_ratio;
		}
	}

	// --- INICIO CUSTOM: Guardian Soul (Daño por VIT) ---
	if (sd && pc_checkskill(sd, CR_GUARDIANSOUL) > 0) {
		base_skillratio += status_get_vit(src)*2;
	}
	// --- FIN CUSTOM ---
}

void SkillSmite::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// El stun base de la habilidad se mantiene igual
	sc_start(src, target, SC_STUN, (15 + skill_lv * 5), skill_lv, skill_get_time2(getSkillId(), skill_lv));
}

// --- INICIO CUSTOM: Smite en Área (Guardian Soul / Mimic Soul) ---
void SkillSmite::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	map_session_data *sd = BL_CAST(BL_PC, src);

	// 1. Guardamos el ID del objetivo principal para no pegarle dos veces
	skill_area_temp[1] = target->id;

	// 2. ¡PRIMERO EL ÁREA! Si tiene la pasiva correspondiente, creamos el área de efecto 3x3 (radio 1)
	// Lo hacemos antes para que el objetivo principal sirva de "ancla" antes de salir volando.
	if (sd && (pc_checkskill(sd, CR_GUARDIANSOUL) > 0 || pc_checkskill(sd, RG_MIMIC) > 0)) {
		map_foreachinallrange(skill_area_sub, target, 1, BL_CHAR, src, getSkillId(), skill_lv, tick, flag | BCT_ENEMY | 1, skill_castend_nodamage_id);
	}

	// 3. Ejecutamos el golpe normal al objetivo principal (que lo empujará y aturdirá)
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);
}

void SkillSmite::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	// Esta función ahora actúa como nuestra "recepción de explosión"
	if (skill_area_temp[1] != target->id) { // Solo si NO es el objetivo principal...
		
		// Golpeamos al enemigo del área.
		WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);
	}
}
// --- FIN CUSTOM ---