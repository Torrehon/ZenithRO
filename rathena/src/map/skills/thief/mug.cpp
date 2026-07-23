// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "mug.hpp"

#include <common/random.hpp>

#include "map/battle.hpp"
#include "map/clif.hpp"
#include "map/mob.hpp"
#include "map/pc.hpp"

SkillMug::SkillMug() : SkillImpl(RG_STEALCOIN) {
}

void SkillMug::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// El ratio base en rAthena es 100 (100%).
	// Fórmula: 100% * Skill Level
	// Lv 1 = 100% (+0), Lv 2 = 200% (+100), Lv 5 = 500% (+400)
	base_skillratio += (skill_lv - 1) * 100;
}

void SkillMug::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	// 1. Ejecutamos el ataque físico siempre (funciona en PVE, PVP, contra Jefes, etc.)
	battle_weapon_attack(src, target, tick, flag);

	// 2. Lógica del efecto secundario: Robo de Zeny
	map_session_data* sd = BL_CAST(BL_PC, src);
	mob_data *dstmd = BL_CAST(BL_MOB, target);

	// Si el que ataca no es un jugador o el objetivo no es un monstruo, terminamos aquí.
	if (sd == nullptr || dstmd == nullptr)
		return;

	// Si el monstruo es un Boss o es Inmune a estados (MVPs), terminamos aquí.
	if (status_bl_has_mode(target, MD_BOSS) || status_bl_has_mode(target, MD_STATUSIMMUNE))
		return;

	// Si el monstruo ya fue robado previamente, terminamos aquí.
	if (dstmd->state.steal_coin_flag)
		return;

	// --- Cálculo de Probabilidad (Rate sobre 1000) ---
	int32 rate = 20 * skill_lv;
	rate += (sd->battle_status.dex / 2) * 10;

	// Tirada de éxito
	if (!rnd_chance_official(rate, 1000)) {
		return; 
	}

	// Marcamos al monstruo para que no vuelva a dar Zeny
	dstmd->state.steal_coin_flag = 1;

	// --- Cálculo de Cantidad de Zeny ---
	int32 target_lv = status_get_lv(target);
	int32 amount = rnd_value(8 * target_lv, 10 * target_lv);
	amount += (skill_lv * target_lv) / 10;

	// Bono Luk
	int32 luk_bonus = (amount * sd->battle_status.luk) / 100;
	amount += luk_bonus;

	if (amount <= 0)
		return;

	// Entregamos el Zeny al jugador
	pc_getzeny(sd, amount, LOG_TYPE_STEAL);

	// Mostramos la cantidad de Zeny robada visualmente
	clif_skill_nodamage(src, *target, getSkillId(), amount);
}