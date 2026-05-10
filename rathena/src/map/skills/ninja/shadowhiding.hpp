// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#pragma once

#include "../skill_impl.hpp"

/**
 * Skill: Shadow Hiding (Yamikumo)
 * Implementada usando el estado SC_HIDING estándar para máxima compatibilidad.
 */
class SkillShadowHiding : public SkillImpl {
public:
	SkillShadowHiding();

	// Esta es la función que lanza el efecto de la skill (el Hiding)
	void castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const override;
};