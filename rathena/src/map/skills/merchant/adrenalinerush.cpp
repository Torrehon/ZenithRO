// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "adrenalinerush.hpp"

#include "map/clif.hpp"
#include "map/homunculus.hpp"
#include "map/map.hpp"
#include "map/mob.hpp"
#include "map/party.hpp"
#include "map/pc.hpp"
#include "map/script.hpp"
#include "map/status.hpp"

static int skill_adrenaline_slaves_sub(block_list* bl, va_list ap) {
	mob_data* md = BL_CAST(BL_MOB, bl);
	if (md && md->master_id > 0) {
		uint32 master_id = va_arg(ap, uint32);
		block_list* src = va_arg(ap, block_list*);
		uint16 skill_id = (uint16)va_arg(ap, int);
		uint16 skill_lv = (uint16)va_arg(ap, int);
		t_tick duration = va_arg(ap, t_tick);

		if (md->master_id == master_id) {
			sc_start2(src, md, skill_get_sc(skill_id), 100, skill_lv, 0, duration);
			clif_specialeffect(md, EF_HASTEUP, AREA);
		}
	}
	return 0;
}

SkillAdrenalineRush::SkillAdrenalineRush() : SkillImpl(BS_ADRENALINE) {
}

void SkillAdrenalineRush::castendNoDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	map_session_data* sd = BL_CAST(BL_PC, src);
	map_session_data* dstsd = BL_CAST(BL_PC, target);

	if (sd == nullptr || sd->status.party_id == 0 || (flag & 1)) {
		int32 weapontype = skill_get_weapontype(getSkillId());
		if (!weapontype || !dstsd || pc_check_weapontype(dstsd, weapontype)) {
			clif_skill_nodamage(target, *target, getSkillId(), skill_lv,
				sc_start2(src, target, skill_get_sc(getSkillId()), 100, skill_lv, (src == target) ? 1 : 0, skill_get_time(getSkillId(), skill_lv)));
		}
	} else if (sd) {
		party_foreachsamemap(skill_area_sub,
			sd,skill_get_splash(getSkillId(), skill_lv),
			src,getSkillId(),skill_lv,tick, flag|BCT_PARTY|1,
			skill_castend_nodamage_id);
	}

	// --- INICIO CUSTOM: Propagar SC_ADRENALINE a Homúnculo e Invocaciones del Alquimista ---
	if (sd && (src == target || !(flag & 1))) {
		t_tick duration = skill_get_time(getSkillId(), skill_lv);
		if (sd->hd) {
			sc_start2(src, sd->hd, skill_get_sc(getSkillId()), 100, skill_lv, 0, duration);
			clif_specialeffect(sd->hd, EF_HASTEUP, AREA);
		}
		map_foreachinrange(skill_adrenaline_slaves_sub, src, AREA_SIZE, BL_MOB, sd->id, src, (int)getSkillId(), (int)skill_lv, duration);
	}
	// --- FIN CUSTOM ---
}

