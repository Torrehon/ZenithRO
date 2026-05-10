#include "soulkick.hpp" // Asegúrate de que este nombre coincide con tu archivo .hpp
#include "../../pc.hpp"
#include "../../status.hpp"
#include "../../clif.hpp"
#include "../../skill.hpp"

// Cambiamos MagicSkillImpl por SkillImpl
SkillSoulKick::SkillSoulKick() : SkillImpl(TK_SKICK) {
}

void SkillSoulKick::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {


	// El daño mágico de la patada
	skill_attack(BF_MAGIC, src, src, target, getSkillId(), skill_lv, tick, flag);
}
