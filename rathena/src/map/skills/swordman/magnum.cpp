// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "magnum.hpp"

#include "../../clif.hpp"
#include "../../map.hpp"
#include "../../pc.hpp"
#include "../../skill.hpp"
#include "../../status.hpp"
#include "../../unit.hpp"

SkillMagnumBreak::SkillMagnumBreak() : SkillImpl(SM_MAGNUM)
{
}

void SkillMagnumBreak::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const
{
	const map_session_data* sd = BL_CAST(BL_PC, src);
	bool is_2h = false;

	// 1. Identificar si usa armas a dos manos (Espada, Lanza, Hacha)
	if (sd != nullptr) {
		int w = sd->status.weapon;
		if (w == W_2HSWORD || w == W_2HSPEAR || w == W_2HAXE) {
			is_2h = true;
		}
	}

	// 2. Cálculo del daño estándar (Nivel de Skill + Área)
	// Aquí se suma el daño según si es el centro (miscflag 1) o la salpicadura
	if (wd->miscflag == 1) {
			base_skillratio += 20 * skill_lv;
	} 
	else {		
			base_skillratio += 15 * skill_lv;
	}

	// 3. --- APLICAR DOBLE HIT Y DOBLE DAÑO (Solo si es Arma a 2 Manos) ---
	if (is_2h) {

		// Forzamos los 2 hits visuales
		if (wd != nullptr) {
			const_cast<Damage*>(wd)->div_ = 2;
		}
	}
	// Si NO es arma a 2 manos, no entra aquí, por lo que hace 1 hit y daño normal.
}


void SkillMagnumBreak::modifyHitRate(int16 &hit_rate, const block_list *src, const block_list *target, uint16 skill_lv) const
{
	hit_rate += hit_rate * 10 * skill_lv / 100;
}

void SkillMagnumBreak::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const
{
	map_session_data* sd = BL_CAST( BL_PC, src );

	if (flag & 1)
	{
		// For players, damage depends on distance, so add it to flag if it is > 1
		// Cannot hit hidden targets
		skill_attack(skill_get_type(getSkillId()), src, src, target, getSkillId(), skill_lv, tick, flag | SD_ANIMATION | (sd?distance_bl(src, target):0));
	}
}

void SkillMagnumBreak::castendNoDamageId(block_list *src, block_list *bl, uint16 skill_lv, t_tick tick, int32& flag) const
{
	// Passive Magnum, should had been casted on yourself.
	skill_area_temp[1] = 0;
	e_skill skillId = getSkillId();
	map_foreachinshootrange(skill_area_sub, src, skill_get_splash(skillId, skill_lv), BL_SKILL | BL_CHAR,
							src, skillId, skill_lv, tick, flag | BCT_ENEMY | 1, skill_castend_damage_id);
	clif_skill_nodamage(src, *src, skillId, skill_lv);
	// Initiate 20% of your damage becomes fire element.
#ifdef RENEWAL
	sc_start4(src, src, SC_SUB_WEAPONPROPERTY, 100, ELE_FIRE, 20, skillId, 0, skill_get_time2(skillId, skill_lv));
#else
	sc_start4(src, src, SC_WATK_ELEMENT, 100, ELE_FIRE, 20, 0, 0, skill_get_time2(skillId, skill_lv));
#endif
}
