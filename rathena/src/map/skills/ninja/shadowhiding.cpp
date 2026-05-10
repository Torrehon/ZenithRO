#include "shadowhiding.hpp"
#include "map/clif.hpp"
#include "map/status.hpp"

SkillShadowHiding::SkillShadowHiding() : SkillImpl(KO_YAMIKUMO) {
}

void SkillShadowHiding::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	status_change *tsc = status_get_sc(target);

	// Si el Ninja ya está en Hiding, lo sacamos (Toggle)
	if (tsc && tsc->getSCE(SC_HIDING)) {
		status_change_entry *tsce = tsc->getSCE(SC_HIDING);
		// Si el Hiding que tiene puesto es el de esta skill (u otro), lo quitamos
		status_change_end(target, SC_HIDING);
		clif_skill_nodamage(src, *target, getSkillId(), -1, 1);
		return;
	}

	// Si no está oculto, lo ocultamos con el Hiding estándar
	// Ponemos probabilidad 100% (10000)
	if (sc_start(src, target, SC_HIDING, 10000, skill_lv, skill_get_time(getSkillId(), skill_lv))) {
		clif_skill_nodamage(src, *target, getSkillId(), -1, 1);
	}
}
