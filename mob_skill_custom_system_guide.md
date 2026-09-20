# Guía Técnica: Sistema de Variables, Targets y Condiciones Custom en rAthena

Esta guía documenta paso a paso cómo extender el motor de **rAthena** para soportar mecánicas avanzadas de jefes (MVPs) e IA de monstruos a través de `mob_skill_db.txt`, incluyendo:
1. **Bypass de rutas/muros en habilidades de desplazamiento** (`checkpath = 0`).
2. **Nuevos tipos de Target** (`attacker`, `farthest`, `nearest`, `lowesthp`).
3. **Nuevas Condiciones de activación por daño elemental** (`elementattacked`).
4. **Sistema de variables dinámicas por monstruo** (Ej: Mecánica de Overheat / Enfriamiento por Agua para RSX).
5. **Variables estáticas adicionales en `mob_skill_db.txt`**.
6. **Soporte extendido de Estados para `mystatuson/off` y `friendstatuson/off`** (`powerup`, `agiup`, `berserk`, y resolución dinámica de constantes `SC_*`).

---

## Índice de Archivos Involucrados

| Archivo | Responsabilidad |
| :--- | :--- |
| `src/map/skills/npc/changelocation.cpp` | Habilidad `NPC_MOVE_COORDINATE` / Pull de jugadores. |
| `src/map/mob.hpp` | Declaraciones de `struct s_mob_skill`, `struct mob_data`, `enum e_mob_skill_target`, `enum e_mob_skill_condition`. |
| `src/map/mob.cpp` | Lectura de base de datos (`mob_parse_row_mobskilldb`), IA activa (`mob_ai_sub_hard_activeskill`) y eventos (`mobskill_event`). |
| `src/map/battle.cpp` | Cálculo de daño y disparo de eventos al recibir impactos (`battle_damage`). |
| `db/pre-re/mob_skill_db.txt` (o `db/re/`) | Base de datos de habilidades de monstruos. |

---

## 1. Bypass de Obstáculos en `NPC_MOVE_COORDINATE` (Rude Attack Pull)

Por defecto, la skill valida si existe un camino caminable entre el monstruo y el jugador. Si hay muros o precipicios, la habilidad se cancela.

### Modificación en `src/map/skills/npc/changelocation.cpp`
Cambiar el último argumento (`checkpath`) de `1` a `0`:

```cpp
void SkillChangeLocation::castendNoDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	int16 px = target->x, py = target->y;
	// checkpath = 0 permite mover al jugador a través de obstáculos/muros
	if (!skill_check_unit_movepos(0, target, src->x, src->y, 1, 0)) {
		flag |= SKILL_NOCONSUME_REQ;
		return;
	}

	clif_skill_nodamage(src, *target, getSkillId(), skill_lv);
	clif_skill_damage( *src, *target, tick, status_get_amotion(src), 0, DMGVAL_IGNORE, 1, getSkillId(), skill_lv, DMG_SINGLE );
	clif_blown(target);

	// Si no es Boss, intercambia coordenadas
	if (status_get_class_(src) != CLASS_BOSS) {
		if (!skill_check_unit_movepos(0, src, px, py, 1, 0)) {
			flag |= SKILL_NOCONSUME_REQ;
			return;
		}

		clif_blown(src);
	}
}
```

---

## 2. Nuevos Tipos de Target (`e_mob_skill_target`)

Permite que las skills apunten al atacante real (`attacker`) en lugar del objetivo principal fijado (`target_id`), al enemigo más alejado (`farthest`), al más cercano (`nearest`), etc.

### Paso 2.1: `src/map/mob.hpp`
Añadir los nuevos targets al `enum e_mob_skill_target`:

```cpp
enum e_mob_skill_target {
	MST_TARGET	=	0,
	MST_RANDOM,	// Random Target
	MST_SELF,
	MST_FRIEND,
	MST_MASTER,
	MST_AROUND5,
	MST_AROUND6,
	MST_AROUND7,
	MST_AROUND8,
	MST_AROUND1,
	MST_AROUND2,
	MST_AROUND3,
	MST_AROUND4,
	MST_AROUND	=	MST_AROUND4,
	// --- CUSTOM TARGETS ---
	MST_ATTACKER,      // El jugador que acaba de atacar / provocó el rude attack
	MST_FARTHEST,      // El enemigo visible más lejano
	MST_NEAREST,       // El enemigo visible más cercano
	MST_LOWEST_HP,     // El enemigo visible con menor % de HP
};
```

### Paso 2.2: `src/map/mob.cpp` - Parser de Strings
En `mob_parse_row_mobskilldb`, añadir los identificadores a la tabla `target[]`:

```cpp
	static const struct {
		char str[32];
		int32 id;
	} target[] = {
		{	"target",	MST_TARGET	},
		{	"randomtarget",	MST_RANDOM	},
		{	"self",		MST_SELF	},
		{	"friend",	MST_FRIEND	},
		{	"master",	MST_MASTER	},
		// --- CUSTOM TARGETS ---
		{	"attacker",	MST_ATTACKER	},
		{	"farthest",	MST_FARTHEST	},
		{	"nearest",	MST_NEAREST	},
		{	"lowesthp",	MST_LOWEST_HP	},
		// ----------------------
		{	"around5",	MST_AROUND5	},
		{	"around6",	MST_AROUND6	},
		{	"around7",	MST_AROUND7	},
		{	"around8",	MST_AROUND8	},
		{	"around1",	MST_AROUND1	},
		{	"around2",	MST_AROUND2	},
		{	"around3",	MST_AROUND3	},
		{	"around4",	MST_AROUND4	},
		{	"around",	MST_AROUND	},
	};
```

### Paso 2.3: `src/map/mob.cpp` - Selección en IA (`mob_ai_sub_hard_activeskill`)
Dentro del bloque `switch (ms[i]->target)`:

```cpp
			switch (ms[i]->target) {
				case MST_RANDOM:
					bl = battle_getenemy(md, DEFAULT_ENEMY_TYPE(md),
						skill_get_range2(md, ms[i]->skill_id, ms[i]->skill_lv, true));
					break;
				case MST_TARGET:
					bl = map_id2bl(md->target_id);
					if (bl == nullptr && !status_has_mode(&md->status, MD_CANATTACK))
						bl = map_id2bl(md->attacked_id);
					break;
				case MST_ATTACKER:
					bl = map_id2bl(md->attacked_id);
					if (bl == nullptr)
						bl = map_id2bl(md->target_id);
					break;
				case MST_FARTHEST: {
					int32 max_dist = -1;
					block_list *farthest_bl = nullptr;
					map_foreachinallrange([](block_list *tbl, va_list ap) -> int {
						mob_data *src_md = va_arg(ap, mob_data*);
						block_list **f_bl = va_arg(ap, block_list**);
						int32 *m_dist = va_arg(ap, int32*);
						if (battle_check_target(src_md, tbl, BCT_ENEMY) > 0) {
							int32 d = distance_bl(src_md, tbl);
							if (d > *m_dist) {
								*m_dist = d;
								*f_bl = tbl;
							}
						}
						return 0;
					}, md, AREA_SIZE, BL_CHAR, md, &farthest_bl, &max_dist);
					bl = farthest_bl ? farthest_bl : map_id2bl(md->target_id);
					break;
				}
				case MST_NEAREST: {
					int32 min_dist = AREA_SIZE + 1;
					block_list *nearest_bl = nullptr;
					map_foreachinallrange([](block_list *tbl, va_list ap) -> int {
						mob_data *src_md = va_arg(ap, mob_data*);
						block_list **n_bl = va_arg(ap, block_list**);
						int32 *m_dist = va_arg(ap, int32*);
						if (battle_check_target(src_md, tbl, BCT_ENEMY) > 0) {
							int32 d = distance_bl(src_md, tbl);
							if (d < *m_dist) {
								*m_dist = d;
								*n_bl = tbl;
							}
						}
						return 0;
					}, md, AREA_SIZE, BL_CHAR, md, &nearest_bl, &min_dist);
					bl = nearest_bl ? nearest_bl : map_id2bl(md->target_id);
					break;
				}
				// ...
			}

			// Opcional: Auto-cambio de aggro tras lanzar habilidad a un objetivo especial
			if (bl && (ms[i]->target == MST_ATTACKER || ms[i]->target == MST_FARTHEST)) {
				md->target_id = bl->id;
			}
```

---

## 3. Nuevas Condiciones de Activación (`e_mob_skill_condition`)

### Paso 3.1: `src/map/mob.hpp`
Añadir las nuevas condiciones al enum:

```cpp
enum e_mob_skill_condition {
	MSC_ALWAYS	=	0x0000,
	MSC_MYHPLTMAXRATE,
	// ... (existentes)
	MSC_TRICKCASTING,
	MSC_ELEMENTATTACKED, // Activado al recibir ataque de un elemento específico
	MSC_HEAT_GTE,        // Nivel de calor >= cond2
	MSC_HEAT_LTE,        // Nivel de calor <= cond2
};
```

### Paso 3.2: `src/map/mob.cpp` - Strings de `cond1` y `cond2`
En `mob_parse_row_mobskilldb`:

```cpp
	static const struct {
		char str[32];
		int32 id;
	} cond1[] = {
		// ...
		{ "damagedgt",         MSC_DAMAGEDGT         },
		{ "trickcasting",      MSC_TRICKCASTING      },
		{ "elementattacked",   MSC_ELEMENTATTACKED   },
		{ "eleattacked",       MSC_ELEMENTATTACKED   },
		{ "heatgte",           MSC_HEAT_GTE          },
		{ "heatlte",           MSC_HEAT_LTE          },
	}, cond2[] ={
		{	"anybad",		-1				},
		{	"stone",		SC_STONE		},
		// ... (estados)
		// --- Elementos ---
		{	"neutral",		ELE_NEUTRAL		},
		{	"water",		ELE_WATER		},
		{	"earth",		ELE_EARTH		},
		{	"fire",			ELE_FIRE		},
		{	"wind",			ELE_WIND		},
		{	"poison",		ELE_POISON		},
		{	"holy",			ELE_HOLY		},
		{	"dark",			ELE_DARK		},
		{	"ghost",		ELE_GHOST		},
		{	"undead",		ELE_UNDEAD		},
		{	"allelements",	-1				},
	};
```

### Paso 3.3: `src/map/battle.cpp` - Captura de Elemento y Disparo de Evento
En la función `battle_damage`:

```cpp
	if (src != nullptr && target->type == BL_MOB && dmg_lv > ATK_BLOCK) {
		mob_data& md = *reinterpret_cast<mob_data*>(target);

		if (src != target && !status_isdead(*target)) {
			if (damage > 0) {
				mobskill_event(&md, src, tick, attack_type, damage);

				// Obtener el elemento del ataque
				int32 atk_elem = ELE_NEUTRAL;
				if (skill_id > 0) {
					atk_elem = skill_get_ele(skill_id, skill_lv);
					if (atk_elem == ELE_WEAPON || atk_elem == ELE_ENDOWED)
						atk_elem = status_get_attack_element(src);
				} else {
					atk_elem = status_get_attack_element(src);
				}

				// Disparar evento de daño elemental (pasa el ID de elemento en bits superiores)
				mobskill_event(&md, src, tick, MSC_ELEMENTATTACKED | (atk_elem << 16), damage);
			}
			if (skill_id > 0)
				mobskill_event(&md, src, tick, MSC_SKILLUSED | (skill_id << 16), damage);
		}
```

### Paso 3.4: `src/map/mob.cpp` - Evaluación en `mob_ai_sub_hard_activeskill`
```cpp
		if (ms[i]->cond1 == MSC_SKILLUSED)
			flag = ((event & 0xffff) == MSC_SKILLUSED && ((event >> 16) == c2 || c2 == 0));
		else if (ms[i]->cond1 == MSC_ELEMENTATTACKED && damage > 0)
			flag = ((event & 0xffff) == MSC_ELEMENTATTACKED && ((event >> 16) == c2 || c2 == -1));
		else if (ms[i]->cond1 == event)
			flag = 1;
		else if (event == -1) {
			switch (ms[i]->cond1) {
				// ...
				case MSC_HEAT_GTE:
					flag = (md->heat_level >= c2);
					break;
				case MSC_HEAT_LTE:
					flag = (md->heat_level <= c2);
					break;
			}
		}
```

---

## 4. Variables Dinámicas de Monstruo (Ejemplo: Mecánica de Calor de RSX)

### Paso 4.1: `src/map/mob.hpp`
Añadir variables a `struct mob_data`:

```cpp
struct mob_data {
	// ...
	int32 heat_level;        // 0 a 100
	t_tick last_heat_tick;
};
```

### Paso 4.2: `src/map/battle.cpp` - Lógica de Calor y Enfriamiento
En `battle_damage`:

```cpp
	if (src != nullptr && target->type == BL_MOB && dmg_lv > ATK_BLOCK) {
		mob_data& md = *reinterpret_cast<mob_data*>(target);

		// Ejemplo: RSX-0806 (Mob ID: 1623)
		if (md.mob_id == 1623 && !status_isdead(*target)) {
			int32 atk_elem = ELE_NEUTRAL;
			if (skill_id > 0) {
				atk_elem = skill_get_ele(skill_id, skill_lv);
				if (atk_elem == ELE_WEAPON || atk_elem == ELE_ENDOWED)
					atk_elem = status_get_attack_element(src);
			} else {
				atk_elem = status_get_attack_element(src);
			}

			if (atk_elem == ELE_WATER) {
				// Enfriamiento por ataques de AGUA
				int32 cool = (skill_id > 0) ? 15 : 5;
				md.heat_level = max(0, md.heat_level - cool);
				if (md.heat_level <= 30)
					clif_emotion(*target, ET_SWEAT);
			} else if (damage > 0) {
				// Calentamiento por otros daños
				md.heat_level = min(100, md.heat_level + 2);
				if (md.heat_level >= 90)
					clif_emotion(*target, ET_FURY);
			}
		}
	}
```

---

## 5. Ejemplos Listos para `mob_skill_db.txt`

```csv
// =========================================================================================
// Formato CSV (19 Columnas):
// MobID,DummyName,State,SkillID,SkillLv,Rate,CastTime,Delay,Cancel,Target,Cond1,Cond2,val0,val1,val2,val3,val4,Emotion,ChatID
// =========================================================================================

// 1. RUDE ATTACK: El Boss jala al atacante real a través de muros y cambia su aggro a él
1002,Poring@RudePull,any,755,1,10000,0,3000,no,attacker,rudeattacked,0,0,0,0,0,0,,

// 2. REACCIÓN ELEMENTAL: Si recibe ataque de Fuego, castea Storm Gust instantáneo
1002,Poring@FireReact,any,89,10,10000,0,5000,no,attacker,elementattacked,fire,0,0,0,0,0,,

// 3. RSX-0806 OVERHEAT COMBAT SYSTEM (ID 1623)
// Fase 1: Frío (Heat <= 30%) -> Solo ataques básicos
1623,RSX@HammerFall,any,114,5,2000,0,5000,no,target,heatlte,30,0,0,0,0,0,,

// Fase 2: Calentándose (Heat >= 35%) -> Two Hand Quicken y Fire Pillar
1623,RSX@TwoHandQuicken,any,289,10,10000,0,30000,no,self,heatgte,35,0,0,0,0,0,10,
1623,RSX@FirePillar,any,88,10,4000,0,6000,no,target,heatgte,35,0,0,0,0,0,,

// Fase 3: Sobrecalentado (Heat >= 70%) -> Power Up y Lord of Vermilion
1623,RSX@PowerUp,any,197,5,10000,0,20000,no,self,heatgte,70,0,0,0,0,0,23,
1623,RSX@LordOfVermilion,any,85,10,6000,1000,8000,yes,target,heatgte,70,0,0,0,0,0,,

// Fase 4: MELTDOWN / WIPE (Heat >= 90%) -> Berserk y Earthquake continuo
1623,RSX@Berserk,any,357,1,10000,0,60000,no,self,heatgte,90,0,0,0,0,0,28,
1623,RSX@Earthquake,any,653,10,10000,2000,5000,no,target,heatgte,90,0,0,0,0,0,28,
```

---

## 6. Soporte Extendido de Estados (`mystatuson`, `mystatusoff`, `friendstatuson`, `friendstatusoff`)

Por defecto, rAthena solo mapeaba una lista reducida de estados alterados negativos en `cond2[]` (`stone`, `freeze`, `stun`, `sleep`, `poison`, `curse`, `silence`, `confusion`, `blind`, `hiding`, `sight`, `anybad`). Al colocar un estado de buff como `powerup` o cualquier constante `SC_*`, la función `atoi()` devolvía `0`, asignando erróneamente `SC_STONE` (petrificación), por lo que las habilidades nunca se disparaban.

### Mejoras Implementadas:
1. **Inclusión nativa en `cond2[]`**: Se agregaron `powerup` (`SC_POWERUP`), `agiup` (`SC_AGIUP`) y `berserk` (`SC_BERSERK`).
2. **Comparación Case-Insensitive**: Uso de `strcmpi()` para evitar fallos por mayúsculas/minúsculas.
3. **Resolución dinámica por constantes (`script_get_constant`)**: Si el estado no está en la tabla corta, busca automáticamente `"SC_" + NOMBRE` o el nombre completo de la constante en el motor de scripts de rAthena.
4. **Corrección de `MSC_MYSTATUSOFF`**: Se corrigió el bug donde `mystatusoff` devolvía falso si el monstruo no tenía ningún estado activo (`sc.empty()`).

### Ejemplo en `mob_skill_db.txt`:
```csv
// Tao Gunka: activa NPC_POWERUP al 30% HP y spamea Hammer Fall mientras el estado esté activo
1583,Tao Gunka@NPC_POWERUP,attack,349,2,10000,0,30000,yes,self,myhpltmaxrate,30,,,,,,,
1583,Tao Gunka@BS_HAMMERFALL,attack,110,10,10000,0,1000,no,target,mystatuson,powerup,,,,,,,
```

