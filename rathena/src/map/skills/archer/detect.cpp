// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "detect.hpp"
#include "map/status.hpp"
#include "map/pc.hpp"     
#include "map/clif.hpp"

// --- INICIO CUSTOM: Función de looteo a distancia (100% Segura y Adaptada) ---
static int detecting_greed_sub(block_list* bl, va_list ap) {
	block_list* src = va_arg(ap, block_list*);
	map_session_data* sd = BL_CAST(BL_PC, src);
	flooritem_data* fitem = (flooritem_data*)bl;

	// Seguridad básica
	if (!sd || !fitem || fitem->cleartimer == INVALID_TIMER)
		return 0;

	// 1. Protección Anti-Robo (Actualizada)
	// Comprobamos la propiedad del objeto usando solo char_id.
	// Si el objeto pertenece a alguien que no eres tú, el halcón lo ignora respetando el delay.
	if (fitem->first_get_charid > 0 && fitem->first_get_charid != sd->status.char_id) {
		return 0; 
	}

	// 2. Metemos el objeto directamente al inventario
	// En tu versión de rAthena, la variable se llama 'item' a secas
	struct item tmp_item = fitem->item;
	int result = pc_additem(sd, &tmp_item, tmp_item.amount, LOG_TYPE_PICKDROP_PLAYER);

	// pc_additem devuelve 0 si fue un éxito (si no tienes sobrepeso o inventario lleno).
	if (result == 0) {
		// 3. Borramos el objeto visualmente para todos los jugadores.
		// El asterisco convierte el puntero en referencia. El nullptr indica a todos en el área.
		clif_clearflooritem(*fitem, nullptr);

		// 4. Borramos el objeto del mapa legalmente para no corromper la cuadrícula.
		map_clearflooritem(bl);
	}

	return 0;
}
// --- FIN CUSTOM ---

SkillDetect::SkillDetect() : SkillImpl(HT_DETECTING) {
}

void SkillDetect::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	int32 i = skill_get_splash(getSkillId(), skill_lv);
	
	// Efecto original: Revelar personajes ocultos
	map_foreachinallarea( status_change_timer_sub,
		src->m, x-i, y-i, x+i,y+i,BL_CHAR,
		src,nullptr,SC_SIGHT,tick);
		
	// Efecto original: Revelar trampas ocultas
	skill_reveal_trap_inarea(src, i, x, y);

	// --- INICIO CUSTOM: HALCÓN RECOLECTOR ---
	map_session_data* sd = BL_CAST(BL_PC, src);
	if (sd) {
		// En lugar de skill_greed, usamos nuestra nueva función que no tiene límite de distancia.
		// Seguirá estando limitada y segura porque map_foreachinallarea solo escanea 
		// la zona exacta (x, y) donde aterrizó el halcón.
		map_foreachinallarea(detecting_greed_sub, src->m, x - i, y - i, x + i, y + i, BL_ITEM, src);
	}
	// --- FIN CUSTOM ---
}