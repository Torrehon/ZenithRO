#include "desperado.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp"

SkillDesperado::SkillDesperado() : SkillImplRecursiveDamageSplash(GS_DESPERADO) {
}

void SkillDesperado::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const status_change *sc = status_get_sc(src);

	// 1. Calcular la cantidad de hits: 2 de base + 1 por cada 20 de AGI
	int hits = 2 + (status_get_agi(src) / 20);

	// 2. Calcular el daño: 100% base + 10% * Skill Level
	base_skillratio += 100 + 10 * skill_lv;

	// Mantenemos el modificador de Fallen Angel si está activo
	if (sc && sc->getSCE(SC_FALLEN_ANGEL))
		base_skillratio *= 2;

	// 3. Aplicar la cantidad de hits (div_ negativo para que no reparta ni divida el daño entre hits)
	if (wd != nullptr) {
		const_cast<Damage*>(wd)->div_ = hits;
	}
}

void SkillDesperado::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	clif_skill_nodamage(src, *target, getSkillId(), skill_lv);
	skill_castend_damage_id(src, target, getSkillId(), skill_lv, tick, flag);
}