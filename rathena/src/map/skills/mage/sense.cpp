// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "sense.hpp"

#include "map/clif.hpp"
#include "map/mob.hpp"
#include "map/pc.hpp"

SkillSense::SkillSense() : SkillImpl(WZ_ESTIMATION) {
}

void SkillSense::castendNoDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	
	// 1. Penetración base natural del 10%
	int magic_pen = 10; 

	// 2. Comprobamos si tiene la pasiva Soul of the Magus para subirlo a 25%
	map_session_data* sd = const_cast<map_session_data*>(BL_CAST(BL_PC, src));
	if (sd != nullptr && pc_checkskill(sd, WZ_MAGUSSOUL) > 0) {
		magic_pen = 25; 
	}

	// 3. Aplicamos SC_ARCINSIGHT sobre 'src' (nosotros mismos)
	// val1 = magic_pen (10 o 25)
	// Duración = 20000 ms (20 segundos)
	sc_start4(src, src, SC_ARCINSIGHT, 10000, magic_pen, skill_lv, 0, 0, 30000);
	
	// 4. Efecto visual del casteo (416 es un pilar de luz)
	clif_specialeffect(src, 2327, AREA);
}