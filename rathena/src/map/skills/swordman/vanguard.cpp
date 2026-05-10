#include "vanguard.hpp"
#include "map/clif.hpp"
#include "map/pc.hpp"
#include "map/status.hpp" 
#include "map/skill.hpp"

SkillVanguard::SkillVanguard() : SkillImpl(SM_VANGUARD)
{
}

void SkillVanguard::castendNoDamageId(block_list *src, block_list *bl, uint16 skill_lv, t_tick tick, int32& flag) const
{
	map_session_data* sd = BL_CAST(BL_PC, src);

	if (sd != nullptr) {
		// 1. Leemos la duración (Duration1) quitando el "2" de la función
		//int32 duration = skill_get_time(getSkillId(), skill_lv);
		int32 duration = 60000;
		// 2. Aplicamos el estado. 
		// IMPORTANTE: Solo enviamos 'skill_lv' en val1 para que status.cpp haga la matemática.
		int32 i = sc_start(src, bl, SC_GUARD_STANCE, 100, skill_lv, duration);
		
		// 3. Enviamos la animación al cliente
		clif_skill_nodamage(src, *bl, getSkillId(), skill_lv, i);
	}
}