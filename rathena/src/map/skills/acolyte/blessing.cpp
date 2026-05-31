// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "blessing.hpp"

#include "../../map.hpp"
#include "../../party.hpp"
#include "../../pc.hpp"
#include "../../skill.hpp" // <-- Añade esto por si skill_area_sub lo necesita

SkillBlessing::SkillBlessing() : SkillImpl(AL_BLESSING)
{
}

void SkillBlessing::castendNoDamageId(block_list *src, block_list *bl, uint16 skill_lv, t_tick tick, int32& flag) const
{
	map_session_data *sd = BL_CAST(BL_PC, src); // Añadimos al Caster (Priest)
	map_session_data *dstsd = BL_CAST(BL_PC, bl);
	status_change *tsc = status_get_sc(bl);
	sc_type type = skill_get_sc(getSkillId());

// --- INICIO CUSTOM: AoE Blessing (Soul of the Saint) ---
	// Si el Priest tiene la pasiva, está en party, y NO es un rebote de área (!(flag & 1))
	if (sd && pc_checkskill(sd, PR_SAINTSOUL) > 0 && sd->status.party_id > 0 && !(flag & 1))
	{
		// Si el objetivo también es de nuestra party, desatamos el área de 9x9 (radio 4) desde él
		if (dstsd != nullptr && sd->status.party_id == dstsd->status.party_id) {
			party_foreachsamemap(skill_area_sub, dstsd, 4, src, getSkillId(), skill_lv, tick, flag|BCT_PARTY|1, skill_castend_nodamage_id);
			return; // Detenemos aquí, el loop se encargará de bufar al objetivo principal.
		}
	}
// --- FIN CUSTOM ---

	clif_skill_nodamage(src, *bl, getSkillId(), skill_lv);
	if (dstsd != nullptr && tsc && tsc->getSCE(SC_CHANGEUNDEAD))
	{
		status_data* tstatus = status_get_status_data(*bl);
		if (tstatus->hp > 1)
			skill_attack(BF_MISC, src, src, bl, getSkillId(), skill_lv, tick, flag);
		return;
	}
	sc_start(src, bl, type, 100, skill_lv, skill_get_time(getSkillId(), skill_lv));
}