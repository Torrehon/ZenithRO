// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "spellbreaker.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillSpellBreaker::SkillSpellBreaker() : SkillImpl(SA_SPELLBREAKER) {
}

void SkillSpellBreaker::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	status_data* tstatus = status_get_status_data(*target);
	status_change *tsc = status_get_sc(target);
	map_session_data* sd = BL_CAST( BL_PC, src );
	map_session_data* dstsd = BL_CAST( BL_PC, target );

	int32 sp;
	if (dstsd && tsc && tsc->getSCE(SC_MAGICROD)) {
		// If target enemy player has Magic Rod, then 20% of your SP is transferred to that player
		sp = status_percent_damage(target, src, 0, -20, false);
		status_heal(target, 0, sp, 2);
	}
	else {
		struct unit_data* ud = unit_bl2ud(target);
		if (!ud || ud->skilltimer == INVALID_TIMER)
			return; //Nothing to cancel.
		
		int32 hp = 0;
		
		// --- INICIO CUSTOM: Probabilidad contra Inmunidad ---
		if (status_has_mode(tstatus, MD_STATUSIMMUNE)) {
			int fail_chance = 90; // Oficial: 90% de fallar (10% de éxito)
			
			if (sd && pc_checkskill(sd, SA_ARCSOUL) > 0) {
				fail_chance = 75; // Custom: 75% de fallar (25% de éxito)
			}
			
			if (rnd_chance(fail_chance, 100)) {
				if (sd) clif_skill_fail( *sd, getSkillId() );
				return;
			}
		}
		// --- FIN CUSTOM ---

		// --- INICIO CUSTOM: Soul of the Arcanist (Spell Breaker Daño) ---
		if (sd && pc_checkskill(sd, SA_ARCSOUL) > 0) {
			status_data* sstatus = status_get_status_data(*src);
			
			// 1. Calculamos el MATK base fluctuando entre mínimo y máximo
			int32 base_matk = sstatus->matk_min;
			if (sstatus->matk_max > sstatus->matk_min) {
				base_matk += rnd() % (sstatus->matk_max - sstatus->matk_min + 1);
			}
			
			// 2. Establecemos el daño al 500% del MATK
			hp = base_matk * 5; 

			// 3. Aplicamos el estado Silence (100% probabilidad, 10000 ms = 10 seg)
			sc_start(src, target, SC_SILENCE, 100, skill_lv, 10000);
		} 
		else {
			// Comportamiento original si no tiene la pasiva
#ifdef RENEWAL
			if (!status_has_mode(tstatus, MD_STATUSIMMUNE)) // Reemplaza al 'else' original para evitar errores de sintaxis
#endif
			if (skill_lv >= 5 && (!dstsd || map_flag_vs(target->m))) //HP damage only on pvp-maps when against players.
				hp = tstatus->max_hp / 50; //Siphon 2% HP at level 5
		}
		// --- FIN CUSTOM ---

		clif_skill_nodamage(src, *target, getSkillId(), skill_lv);
		unit_skillcastcancel(target, 0);
		sp = skill_get_sp(ud->skill_id, ud->skill_lv);
		status_zap(target, 0, sp);
		// Recover some of the SP used
		status_heal(src, 0, sp * (25 * (skill_lv - 1)) / 100, 2);

		// --- INICIO CUSTOM: Daño y Curación ---
		if (hp > 0) {
			// Evitamos que el daño puro mate al objetivo directamente para no causar errores con status_zap.
			// Lo dejamos a 1 HP como máximo, absorbiendo toda esa vida.
			if (hp >= tstatus->hp) {
				hp = tstatus->hp - 1;
			}

			if (hp > 0) {
				clif_damage(*src, *target, tick, 0, 0, hp, 0, DMG_NORMAL, 0, false);
				status_zap(target, hp, 0); // Quita la vida al enemigo
				
				// El Sage recupera el 50% del daño final infligido
				status_heal(src, hp / 2, 0, 2); 
			}
		}
		// --- FIN CUSTOM ---
	}
}