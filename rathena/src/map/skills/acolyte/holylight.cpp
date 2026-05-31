// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "holylight.hpp"

#include "../../clif.hpp"
#include "../../pc.hpp"
#include "../../status.hpp"

SkillHolyLight::SkillHolyLight() : SkillImpl(AL_HOLYLIGHT) {
}

void SkillHolyLight::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	status_change_end(target, SC_P_ALTER);
	skill_attack(BF_MAGIC, src, src, target, getSkillId(), skill_lv, tick, flag);
}

void SkillHolyLight::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {

	base_skillratio += 10 * skill_lv;
}
// --- AQUÍ ESTÁ LA MAGIA DE ZEALOT ---
void SkillHolyLight::modifyDamageData(Damage& wd, const block_list& src, const block_list& target, uint16 skill_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, &src);

	// Comprobamos si el jugador tiene la pasiva Zealot
	// (Asegúrate de que PR_ZEALOT esté en tu enum de skills o usa su ID)
	if (sd && pc_checkskill(sd, AL_ZEALOT) > 0) {
		wd.damage *= 2; // Duplicamos el daño total
		wd.div_ = 2;    // El cliente mostrará "Damage + Damage" y el cartel de "2 hits"
	}
}
