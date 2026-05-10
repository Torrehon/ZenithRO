#include "improviseddefense.hpp"
#include "map/pc.hpp"
#include <config/core.hpp>
#include "map/status.hpp"

SkillImprovisedDefense::SkillImprovisedDefense() : SkillImpl(NJ_TATAMIGAESHI) {
}

void SkillImprovisedDefense::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// 1. Ratio Base
	base_skillratio += 10 * skill_lv;

	// 2. Bonus de STR (+1% por cada punto) - Usando tu método nativo de status.hpp
	base_skillratio += status_get_str(src);
		
	// 3. Condición de Huuma: Daño x2 Y 2 Hits
	const map_session_data *sd = BL_CAST(BL_PC, src);
	if (sd && sd->weapontype1 == W_HUUMA && wd != nullptr) {

		// Dividimos ese nuevo daño total en 2 impactos visuales
		const_cast<Damage*>(wd)->div_ = 2;
	}

#ifdef RENEWAL
	base_skillratio *= 2;
#endif
}

void SkillImprovisedDefense::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	if (skill_unitsetting(src,getSkillId(),skill_lv,src->x,src->y,0))
		sc_start(src,src,skill_get_sc(getSkillId()),100,skill_lv,skill_get_time2(getSkillId(),skill_lv));
}

// 4. Efecto Secundario: 30% de causar Stun
void SkillImprovisedDefense::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// Copiamos la lógica de Bash: directo al grano.
	// 3000 = 30% de probabilidad.
	status_change_start(src, target, SC_STUN, 3000, skill_lv, 0, 0, 0, skill_get_time2(getSkillId(), skill_lv), SCSTART_NONE);
}