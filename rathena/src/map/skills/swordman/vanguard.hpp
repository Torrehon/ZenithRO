#pragma once

#include "map/skills/skill_impl.hpp" // Cambiado para que use la ruta raíz de inclusión

class SkillVanguard : public SkillImpl {
public:
	SkillVanguard();

	void castendNoDamageId(block_list *src, block_list *bl, uint16 skill_lv, t_tick tick, int32& flag) const override;
};
