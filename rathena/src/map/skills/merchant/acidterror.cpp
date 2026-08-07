// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "acidterror.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"
#include "map/skill.hpp"  // Necesario para leer la estructura de skill_unit
#include "map/map.hpp"    // Necesario para el escáner map_foreachinrange
#include "map/battle.hpp" // Necesario para battle_check_target

// --- INICIO CUSTOM CALLBACKS ---

// 1. Radar de Fuego: Busca unidades de Demonstration en el suelo
static int check_demonstration_cb(block_list* bl, va_list ap) {
	skill_unit* su = reinterpret_cast<skill_unit*>(bl);
	// Si el bloque es una habilidad y su ID de grupo es Demonstration, damos luz verde (1)
	if (su && su->group && su->group->skill_id == AM_DEMONSTRATION) {
		return 1;
	}
	return 0;
}

// 2. Detonador AoE: Aplica el impacto a todo lo que pille en la zona
static int acidterror_splash_cb(block_list* bl, va_list ap) {
	block_list* src = va_arg(ap, block_list*);
	uint16 skill_id = (uint16)va_arg(ap, int);
	uint16 skill_lv = (uint16)va_arg(ap, int);
	t_tick tick = va_arg(ap, t_tick);
	int32 flag = va_arg(ap, int32);

	// Solo ataca si la entidad en el área es un enemigo válido
	if (battle_check_target(src, bl, BCT_ENEMY) > 0) {
		skill_attack(BF_MAGIC, src, src, bl, skill_id, skill_lv, tick, flag);
	}
	return 1;
}

// --- FIN CUSTOM CALLBACKS ---


SkillAcidTerror::SkillAcidTerror() : SkillImpl(AM_ACIDTERROR) {
}

void SkillAcidTerror::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	const map_session_data* sd = BL_CAST(BL_PC, src);

	base_skillratio += -100 + 200 * skill_lv;
	if (sd && pc_checkskill(sd, AM_LEARNINGPOTION))
		base_skillratio += 100; // !TODO: What's this bonus increase?
#else
	// Pre-Renewal: 100% base + 40% por nivel
	// Nivel 1: +40  (140% total)
	// Nivel 5: +200 (300% total)
	base_skillratio += 40 * skill_lv;
#endif
}

void SkillAcidTerror::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	map_session_data* sd = BL_CAST(BL_PC, src);
	bool aoe_reaction = false;

	// --- INICIO CUSTOM: Reacción en cadena ---
	// Si el jugador tiene aprendida la Soul of the Apothecary
	if (sd && pc_checkskill(sd, AM_APOTHECARY) > 0) {
		
		// Escaneamos un radio de 2 casillas (área 5x5) buscando habilidades (BL_SKILL)
		// Si la función devuelve > 0, significa que hay al menos 1 Demonstration cerca
		if (map_foreachinrange(check_demonstration_cb, target, 2, BL_SKILL) > 0) {
			aoe_reaction = true;
		}
	}

	// Si hay reacción, ejecutamos el ataque en área. Si no, ataque normal.
	if (aoe_reaction) {
		// Ejecuta el splash en un radio de 2 casillas (área 5x5) a todos los personajes/monstruos (BL_CHAR)
		map_foreachinrange(acidterror_splash_cb, target, 2, BL_CHAR, src, (int)getSkillId(), (int)skill_lv, tick, flag);
		
		// Efecto visual opcional para que se note la gran explosión química (1996 es un buen boom)
		clif_specialeffect(target, 1996, AREA);
	} else {
		// Comportamiento normal (Single Target)
		skill_attack(BF_MAGIC, src, src, target, getSkillId(), skill_lv, tick, flag);
	}
	// --- FIN CUSTOM ---
}

void SkillAcidTerror::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	sc_start2(src,target,SC_BLEEDING,(skill_lv*3),skill_lv,src->id,skill_get_time2(getSkillId(),skill_lv));
#ifdef RENEWAL
	if (skill_break_equip(src,target, EQP_ARMOR, (1000 * skill_lv + 500) - 1000, BCT_ENEMY))
#else
	if (skill_break_equip(src,target, EQP_ARMOR, 50*skill_get_time(getSkillId(),skill_lv), BCT_ENEMY))
#endif
		clif_emotion( *target, ET_HUK );
}