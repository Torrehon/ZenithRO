// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "incagi.hpp"

#include "../../map.hpp" // <-- Añadido por seguridad
#include "../../party.hpp" // <-- Necesario para party_foreachsamemap
#include "../../pc.hpp"
#include "../../skill.hpp" // <-- Añadido por seguridad

SkillIncreaseAgi::SkillIncreaseAgi() : SkillImpl(AL_INCAGI)
{
}

void SkillIncreaseAgi::castendNoDamageId(block_list *src, block_list *bl, uint16 skill_lv, t_tick tick, int32& flag) const
{
	map_session_data *sd = BL_CAST(BL_PC, src); // Añadimos al Caster (Priest)
	map_session_data *dstsd = BL_CAST(BL_PC, bl);
	status_change *tsc = status_get_sc(bl);
	enum sc_type type = skill_get_sc(getSkillId());

// --- INICIO CUSTOM: AoE Inc Agi (Soul of the Saint / Mimic Soul) ---
	if (sd && (pc_checkskill(sd, PR_SAINTSOUL) > 0 || pc_checkskill(sd, RG_MIMIC) > 0) && sd->status.party_id > 0 && !(flag & 1))
	{
		if (dstsd != nullptr && sd->status.party_id == dstsd->status.party_id) {
			party_foreachsamemap(skill_area_sub, dstsd, 4, src, getSkillId(), skill_lv, tick, flag|BCT_PARTY|1, skill_castend_nodamage_id);
			return; 
		}
	}
// --- FIN CUSTOM ---

	clif_skill_nodamage(src, *bl, getSkillId(), skill_lv);
	if (dstsd != nullptr && tsc && tsc->getSCE(SC_CHANGEUNDEAD))
	{
		status_data *tstatus = status_get_status_data(*bl);
		if (tstatus->hp > 1)
		{
			skill_attack(BF_MISC, src, src, bl, getSkillId(), skill_lv, tick, flag);
		}
		return;
	}
	sc_start(src, bl, type, 100, skill_lv, skill_get_time(getSkillId(), skill_lv));
}