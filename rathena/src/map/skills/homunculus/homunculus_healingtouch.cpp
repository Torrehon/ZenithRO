// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "homunculus_healingtouch.hpp"

#include "map/battle.hpp"
#include "map/clif.hpp"
#include "map/mob.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"
#include "map/homunculus.hpp" // Necesario para leer homun_data y hom_checkskill

// --- CUSTOM: Escáner de área para Healing Wind ---
static int skill_healingwind_sub(block_list* bl, va_list ap) {
	block_list* src = va_arg(ap, block_list*);
	homun_data* hd = va_arg(ap, homun_data*);
	int heal_amount = va_arg(ap, int);
	int regen_time = va_arg(ap, int);

	bool is_valid = false;

	// Filtro: Solo curar al Homúnculo, al Master y a las Plantas invocadas
	if (bl->id == hd->id) {
		is_valid = true; // El propio Homúnculo (hd ya es un block_list)
	} 
	else if (hd->master && bl->id == hd->master->id) {
		is_valid = true; // El Alchemist / Master (hd->master ya es un block_list)
	} 
	else if (bl->type == BL_MOB) {
		mob_data* md = (mob_data*)bl;
		// Verificar que sea del Master y que sea de la raza Planta (Bio Cannibalize)
		if (hd->master && md->master_id == hd->master->id && md->status.race == RC_PLANT) {
			is_valid = true;
		}
	}

	if (is_valid) {
		status_change* tsc = status_get_sc(bl);
		status_data* sstatus = status_get_status_data(*bl);
		int final_heal = heal_amount;

		// Respetamos mecánicas oficiales de inmunidad o anti-curas
		if (status_isimmune(bl) || (bl->type == BL_MOB && (status_get_class(bl) == MOBID_EMPERIUM || status_get_class_(bl) == CLASS_BATTLEFIELD))) {
			final_heal = 0;
		}

		if (tsc != nullptr && !tsc->empty()) {
			if (tsc->getSCE(SC_BERSERK) || tsc->getSCE(SC_SATURDAYNIGHTFEVER)) {
				final_heal = 0; // Berserk no permite ser curado
			}
		}

		status_change_end(bl, SC_BITESCAR);

		// Ejecutar la curación si es mayor a 0
		if (final_heal > 0) {
			clif_skill_nodamage(src, *bl, HLIF_HEAL, final_heal, 1);
			status_heal(bl, final_heal, 0, 0);
		}

		// Aplicar estado Regen si Brain Surgery está aportando su buff
		if (regen_time > 0 && final_heal > 0) {
			// SC_REGEN aplicará una cura pasiva por segundo durante el tiempo estipulado
			sc_start(src, bl, SC_SLOWPOISON, 100, 1, regen_time); 
		}
	}
	return 1;
}

SkillHealingTouch::SkillHealingTouch() : SkillImpl(HLIF_HEAL) {
}

void SkillHealingTouch::castendNoDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	homun_data* hd = BL_CAST(BL_HOM, src);
	if (!hd) return; // Seguridad

	// Nivel de Brain Surgery del homúnculo
	uint16 brain_lv = hom_checkskill(hd, HLIF_BRAIN);

	// 1. Calculamos la fórmula estándar de Heal (usando las stats de la Lif)
	int32 base_heal = skill_calc_heal(src, src, getSkillId(), skill_lv, true);
	
	// 2. Aplicamos la regla Custom: La cura en área es la mitad
	int32 heal_amount = base_heal / 2;

	// 3. Bono de Brain Surgery (4% extra por nivel)
	if (brain_lv > 0) {
		heal_amount += (heal_amount * (4 * brain_lv)) / 100;
	}

	// 4. Tiempo de Regen (12 segundos * Skill Level en milisegundos)
	int regen_time = (brain_lv > 0) ? (12000 * brain_lv) : 0;

	// Rango dinámico por nivel: Lv1=1(3x3), Lv2=2(5x5), Lv3=3(7x7), etc.
	int splash_range = skill_lv;

	// Disparamos el área: escanea todo alrededor de la Lif (src) dentro del splash_range
	map_foreachinrange(skill_healingwind_sub, src, splash_range, BL_PC|BL_HOM|BL_MOB, src, hd, heal_amount, regen_time);
}