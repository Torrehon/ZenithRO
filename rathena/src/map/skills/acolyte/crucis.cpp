#include "crucis.hpp"
#include <config/core.hpp>
#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"
#include "map/skill.hpp"

SkillCrucis::SkillCrucis() : SkillImpl(AL_CRUCIS) {
}

// 1. Dibuja la cruz visual y lanza el daño mágico en área
void SkillCrucis::castendNoDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	clif_skill_nodamage(src, *target, getSkillId(), skill_lv);
	
	skill_area_temp[1] = 0;
	map_foreachinshootrange(skill_attack_area, src,
		skill_get_splash(getSkillId(), skill_lv), splash_target(src),
		BF_MAGIC, src, src, getSkillId(), skill_lv, tick, flag, BCT_ENEMY);
}

// 2. Aplica el 100% de Reducción de DEF a cada enemigo golpeado
void SkillCrucis::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	sc_start(src, target, skill_get_sc(getSkillId()), 100, skill_lv, skill_get_time(getSkillId(), skill_lv));
}