// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "mug.hpp"

#include <common/random.hpp>

#include "map/battle.hpp"
#include "map/clif.hpp"
#include "map/mob.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

// HEREDAMOS DE WeaponSkillImpl EN LUGAR DE SkillImpl
SkillMug::SkillMug() : WeaponSkillImpl(RG_STEALCOIN) {
}

void SkillMug::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// Ratio base de Mug: 100% + escalado por nivel de skill
	base_skillratio += (skill_lv - 1) * 100;

	// ROBO DE ZENY: Se ejecuta durante el cálculo de la habilidad (antes del daño fatal)
	block_list *mutable_src = const_cast<block_list*>(src);
	block_list *mutable_target = const_cast<block_list*>(target);

	map_session_data* sd = BL_CAST(BL_PC, mutable_src);
	mob_data *dstmd = BL_CAST(BL_MOB, mutable_target);

	if (sd != nullptr && dstmd != nullptr && mutable_target != nullptr) {
		// Si el monstruo es un Boss o es Inmune a estados (MVPs), o ya fue robado, salimos.
		if (!status_bl_has_mode(mutable_target, MD_BOSS) && !status_bl_has_mode(mutable_target, MD_STATUSIMMUNE) && !dstmd->state.steal_coin_flag) {
			
			// --- Cálculo de Probabilidad (Rate sobre 1000) ---
			int32 rate = 20 * skill_lv;
			rate += (sd->battle_status.dex / 2) * 10;

			// Tirada de éxito
			if (rnd_chance_official(rate, 1000)) {
				// Marcamos al monstruo para que no vuelva a dar Zeny
				dstmd->state.steal_coin_flag = 1;

				// --- Cálculo de Cantidad de Zeny ---
				int32 target_lv = status_get_lv(mutable_target);
				int32 amount = rnd_value(3 * target_lv, 5 * target_lv);
				amount += (skill_lv * target_lv) / 20;

				// Bono Luk
				int32 luk_bonus = (amount * sd->battle_status.luk) / 100;
				amount += luk_bonus;

				if (amount > 0) {
					// Entregamos el Zeny al jugador
					pc_getzeny(sd, amount, LOG_TYPE_STEAL);

					// Mostramos la cantidad de Zeny robada visualmente
					clif_skill_nodamage(mutable_src, *mutable_target, getSkillId(), amount);
				}
			}
		}
	}
}

void SkillMug::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// Reservado para efectos secundarios tras el impacto
}
