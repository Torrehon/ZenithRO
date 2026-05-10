#include "shadowslash.hpp"
#include <config/core.hpp>
#include "map/clif.hpp"
#include "map/map.hpp"
#include "map/status.hpp"
#include "map/unit.hpp"

SkillShadowSlash::SkillShadowSlash() : WeaponSkillImpl(NJ_KIRIKAGE) {}

void SkillShadowSlash::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Ratio base: 15% por nivel
	int32 ratio = (20 * skill_lv);
	const status_change *sc = status_get_sc(src);

	// 1. BONO POR SIGILO (Solo el daño extra)
	if (sc && sc->getSCE(SC_HIDING)) {
		ratio += 50;
	}

	// 2. LÓGICA DEL DOBLE HIT (Solo si lleva Huuma Shuriken)
	const map_session_data *sd = BL_CAST(BL_PC, src);
	if (sd && sd->weapontype1 == W_HUUMA && wd != nullptr) {
		const_cast<Damage*>(wd)->div_ = 2;
	}

	base_skillratio += ratio;
}

void SkillShadowSlash::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	status_change *sc = status_get_sc(src);

	// 1. Salto (Gap Closer)
	if( !map_flag_gvg2(src->m) && !map_getmapflag(src->m, MF_BATTLEGROUND) ) {
		int16 x, y;
		map_search_freecell(target, 0, &x, &y, 1, 1, 0);
		if (unit_movepos(src, x, y, 0, 0)) {
			clif_blown(src);
		}
	}

	// 2. EJECUTAR DAÑO
	WeaponSkillImpl::castendDamageId(src, target, skill_lv, tick, flag);

	// 3. COMBO SOLO DESDE HIDING
	// Guardamos la activación del combo solo si atacó oculto
	if (sc && sc->getSCE(SC_HIDING)) {
		status_change_end(src, SC_HIDING);
		sc_start(src, src, SC_NJ_COMBO, 100, skill_lv, 10000);
	}
}