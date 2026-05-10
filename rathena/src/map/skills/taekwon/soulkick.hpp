#pragma once

#include "../skill_impl.hpp"
#include "../../battle.hpp"

// Cambiamos MagicSkillImpl por SkillImpl
class SkillSoulKick : public SkillImpl {
public:
	SkillSoulKick();

	void castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const override;
};