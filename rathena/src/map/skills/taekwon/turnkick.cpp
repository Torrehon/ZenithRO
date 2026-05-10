// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "turnkick.hpp"

#include "map/clif.hpp"
#include "map/pc.hpp"     // Para poder leer al jugador (BL_CAST y pc_checkskill)
#include "map/status.hpp"

SkillTurnKick::SkillTurnKick() : SkillImpl(TK_TURNKICK) {
}

void SkillTurnKick::modifyDamageData(Damage& dmg, const block_list& src, const block_list& target, uint16 skill_lv) const {
	dmg.blewcount = 0; // El objetivo principal no sale volando, solo los del área
}

void SkillTurnKick::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Fórmula base: 150% + 50% * lvl.
	// Como base_skillratio empieza en 100, le sumamos 50 para el 150% base.
	base_skillratio += 50 + 50 * skill_lv;
}

void SkillTurnKick::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// En lugar de depender de la etiqueta BF_MISC, simplemente miramos la ID.
	// Si el objetivo (target->id) no es el objetivo principal al que pateamos (skill_area_temp[1])...
	if (target->id != skill_area_temp[1]) {
		// Probabilidad 10000 = 100%. Duración: 3000 ms (3 segundos)
		sc_start(src, target, SC_STUN, 10000, skill_lv, 3000);
		clif_specialeffect(target, EF_SPINEDBODY, AREA);
		sc_start(src, target, SC_NOACTION, 10000, 1, 3000);
	}
}

void SkillTurnKick::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	// Parte activa: Ataque al objetivo principal.
	skill_area_temp[1] = target->id;

	if (skill_attack(BF_WEAPON, src, src, target, getSkillId(), skill_lv, tick, flag))
		map_foreachinallrange(skill_area_sub, target,
						skill_get_splash(getSkillId(), skill_lv), BL_MOB,
						src, getSkillId(), skill_lv, tick, flag | BCT_ENEMY | 1,
						skill_castend_nodamage_id); // Manda a los enemigos del área a castendNoDamageId
}

void SkillTurnKick::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	// Parte pasiva: El área.
	if (skill_area_temp[1] != target->id) { // Si no es el objetivo principal...
		
		// 1. Siempre empujamos a los enemigos del área
		skill_blown(src, target, skill_get_blewcount(getSkillId(), skill_lv), -1, BLOWN_NONE);
		
		// 2. Comprobamos la pasiva
		const map_session_data *sd = BL_CAST(BL_PC, src);
		if (sd && pc_checkskill(sd, TK_SHATTER) > 0) {
			// --- INICIO: Shattering Kicks ---
			// Mandamos un ataque físico puro y limpio (BF_WEAPON).
			// Como hemos cambiado la validación de applyAdditionalEffects, el Stun y la animación entrarán igualmente.
			skill_attack(BF_WEAPON, src, src, target, getSkillId(), skill_lv, tick, flag);
			// --- FIN: Shattering Kicks ---
		} else {
			// Comportamiento original si no tiene la pasiva: solo aplica los efectos (Stun/NoAction) sin calcular daño
			skill_additional_effect(src, target, getSkillId(), skill_lv, BF_MISC, ATK_DEF, tick);
		}
	}
}