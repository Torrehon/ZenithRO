// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "powerup.hpp"

#include "map/clif.hpp"
#include "map/status.hpp"

SkillPowerUp::SkillPowerUp() : SkillImpl(NPC_POWERUP) {
}

void SkillPowerUp::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	int32 bonus_atk = 0;
	int32 bonus_hit = 0;
	switch(skill_lv) {
		case 1: bonus_atk = 25;  bonus_hit = 20; break;
		case 2: bonus_atk = 50;  bonus_hit = 40; break;
		case 3: bonus_atk = 75;  bonus_hit = 60; break;
		case 4: bonus_atk = 100; bonus_hit = 80; break;
		case 5:
		default: bonus_atk = 150; bonus_hit = 100; break;
	}
	clif_skill_nodamage(src,*target,getSkillId(),skill_lv,
		sc_start2(src,target,skill_get_sc(getSkillId()),100,bonus_atk,bonus_hit,skill_get_time(getSkillId(), skill_lv)));
}
