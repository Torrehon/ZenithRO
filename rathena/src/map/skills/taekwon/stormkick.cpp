// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "stormkick.hpp"

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillStormKick::SkillStormKick() : SkillImpl(TK_STORMKICK) {
}

void SkillStormKick::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// base_skillratio ya trae 100 por defecto. Sumamos 50 para empezar en 150%.
	base_skillratio += 50 + 30 * skill_lv;

	// --- INICIO: Shattering Kicks (Daño extra) ---
	const map_session_data *sd = BL_CAST(BL_PC, src);
	if (sd && pc_checkskill(sd, TK_SHATTER) > 0) {
		base_skillratio += 100; // Añade 100% al ratio final
	}
	// --- FIN: Shattering Kicks ---
}

// --- INICIO: Shattering Kicks (Efecto Ceguera) ---
void SkillStormKick::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	const map_session_data *sd = BL_CAST(BL_PC, src);
	
	if (sd && pc_checkskill(sd, TK_SHATTER) > 0) {
		int chance = 6 * skill_lv; // 6% por nivel de skill
		// skill_get_time2 saca la duración del estado directamente de tu base de datos (skill_db)
		sc_start(src, target, SC_BLIND, chance, skill_lv, skill_get_time2(getSkillId(), skill_lv));
	}
}
// --- FIN: Shattering Kicks ---

void SkillStormKick::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 &flag) const {
	clif_skill_nodamage(src, *target, getSkillId(), skill_lv);
	skill_area_temp[1] = 0;
	// Ejecuta el daño en área nativo de rAthena sin alterar nada
	map_foreachinshootrange(skill_attack_area, src,
						skill_get_splash(getSkillId(), skill_lv), BL_CHAR | BL_SKILL,
						BF_WEAPON, src, src, getSkillId(), skill_lv, tick, flag, BCT_ENEMY);
}