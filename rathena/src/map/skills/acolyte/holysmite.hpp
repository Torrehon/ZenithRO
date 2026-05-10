#pragma once

#include "../skill_impl.hpp"
#include "../../battle.hpp"

class SkillHolySmite : public WeaponSkillImpl {
public:
	SkillHolySmite();

	// ¡Añadimos esta línea para que el compilador sepa que la función existe!
	void castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const override;

	void calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const override;
	void modifyDamageData(Damage& wd, const block_list& src, const block_list& target, uint16 skill_lv) const override;
};