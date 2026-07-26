// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#pragma once

#include "../skill_impl.hpp"

// Clase para el Plagiarism Clásico
class SkillPlagiarismOffensive : public SkillImpl {
public:
	SkillPlagiarismOffensive();
	void castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const override; // <-- Cambiado a NoDamageId
};

// Clase para el Plagiarism de Soporte
class SkillPlagiarismSupport : public SkillImpl {
public:
	SkillPlagiarismSupport();
	void castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const override;
};