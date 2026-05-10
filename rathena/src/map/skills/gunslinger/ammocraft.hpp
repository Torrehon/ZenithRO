// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#pragma once

#include "../skill_impl.hpp"
#include "../../battle.hpp"

class SkillAmmoCraft : public SkillImpl {
public:
	// Asegúrate de que esto NO tenga nada entre los paréntesis
	SkillAmmoCraft(); 
	
	void castendNoDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const override;
};