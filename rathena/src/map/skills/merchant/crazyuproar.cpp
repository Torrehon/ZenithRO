// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "crazyuproar.hpp"

#include "map/clif.hpp"
#include "map/party.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillCrazyUproar::SkillCrazyUproar() : StatusSkillImpl(MC_LOUD) {
}

// Eliminamos los #ifdef RENEWAL para activarlo en Pre-Renewal
void SkillCrazyUproar::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	map_session_data *sd = BL_CAST(BL_PC, src);

	// Si no tiene party o si es la repetición del bucle, se lo aplica al objetivo
	if (sd == nullptr || sd->status.party_id == 0 || (flag & 1)) {
		StatusSkillImpl::castendNoDamageId(src, target, skill_lv, tick, flag);
	} else if (sd) {
		// Si tiene party y es el primer casteo, busca a la party en el mismo mapa y les replica la skill
		party_foreachsamemap(skill_area_sub, sd, skill_get_splash(getSkillId(), skill_lv), src, getSkillId(), skill_lv, tick, flag | BCT_PARTY | 1, skill_castend_nodamage_id);
	}
}