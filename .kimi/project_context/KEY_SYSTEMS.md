# Карта ключевых систем

## Stamina / Energy

**Описание:** Две отдельные шкалы усталости.
- **Stamina** (зелёная, "fatigue") — тратится на действия. При полном истощении накладывает эффекты усталости.
- **Energy** (синяя, "endurance") — тратится на бег. При нуле нельзя спринтить.

**Файлы:**
- Оригинал: `code/modules/mob/living/carbon/energystamina.dm`
- Модульный override: `modular_twilight_axis/code/modules/mob/living/carbon/human/energystamina.dm`
- Defines: `code/__DEFINES/traits.dm` (`TRAIT_INFINITE_STAMINA`, `TRAIT_FORTITUDE`, `TRAIT_FROZEN_STAMINA`, `TRAIT_INFINITE_ENERGY`, `TRAIT_BREADY`)

**Ключевые proc'ы:**
- `/mob/living/proc/stamina_add(added, emote_override, force_emote)`
- `/mob/living/proc/energy_add(added)`
- `/mob/living/proc/update_stamina()` — регенерация с задержкой `last_fatigued`
- `/mob/living/proc/calculate_stamina()` — `max_stamina = WILLPOWER_STARTING_STAMINA + ((STAWIL - 10) * WILLPOWER_MODIFIER)`
- `/mob/living/proc/calculate_energy()` — `max_energy = (STAWIL + athletics_skill/2) * 100`
- `/mob/living/proc/stamina_nutrition_mod(amt)` — расчёт траты голода от стамины

**Трейты-влияния:**
- `TRAIT_FORTITUDE` — урон стамине ×0.5
- `TRAIT_FROZEN_STAMINA` — нельзя восстанавливать стамину (negative added blocked)
- `TRAIT_INFINITE_STAMINA` — игнорировать стамину полностью
- `TRAIT_APRICITY` — ускоренная регенерация стамины днём
- `TRAIT_MISSING_NOSE` — замедленная регенерация (×0.5)
- `TRAIT_MONK_ROBE` — ускоренная регенерация (×1.25)

## Skills (Скиллы)

**Описание:** Система навыков с уровнями (NOVICE → APPRENTICE → JOURNEYMAN → EXPERT → MASTER → LEGENDARY). Опыт начисляется во сне (`add_sleep_experience`) или активно.

**Файлы:**
- `code/datums/skills/` — дефайны скиллов
- `code/__DEFINES/skills.dm` — константы уровней
- `code/modules/mob/living/carbon/human/skills.dm` — хранение и расчёт

**Ключевые proc'ы:**
- `/datum/mind/proc/add_sleep_experience(skill_type, amount, show_xp)`
- `/mob/living/carbon/human/proc/get_skill_level(skill_type)`

## Traits (Трейты)

**Описание:** Бинарные флаги, влияющие на механику, доступность действий, UI. Более 300 трейтов.

**Файлы:**
- `code/__DEFINES/traits.dm` — дефайны и глобальный список описаний
- `code/modules/mob/living/carbon/human/traits.dm` — применение к персонажам

## Stress (Стресс)

**Описание:** Система психологического состояния. Стрессовые события (`/datum/stressevent/`) накапливаются. Высокий стресс вызывает freak out.

**Файлы:**
- `code/datums/stress/` — события и эффекты
- `modular_twilight_axis/code/datums/stress/` — модульные стресс-события
- `code/modules/mob/living/carbon/energystamina.dm` — `freak_out()`

## Combat (Бой)

**Описание:** Ближний бой с интентами, задержками клика, блоком, парированием, критами.

**Файлы:**
- `code/__DEFINES/combat.dm` — константы (CLICK_CD_MELEE, INTENT_*, etc.)
- `code/modules/mob/living/combat/` — основная логика боя
- `code/modules/mob/living/carbon/human/human_defense.dm` — защита, броня
- `code/modules/projectiles/` — дальний бой

## Jobs / Roles (Профессии)

**Описание:** Ролевой выбор при заходе в раунд. Каждая профессия — `/datum/job/roguetown/...`

**Файлы:**
- `code/modules/jobs/job_types/roguetown/` — основные профессии
- `modular_twilight_axis/code/modules/jobs/` — модульные профессии
- `code/controllers/subsystem/rogue/role_class_handler/` — распределение ролей

## Magic / Spells (Магия)

**Описание:** Система заклинаний на основе `/obj/effect/proc_holder/spell/`. Мана, каст-тайм, компоненты.

**Файлы:**
- `code/modules/spells/` — базовая система
- `modular_twilight_axis/code/modules/spell/` — модульные спеллы
- `modular_twilight_axis/church_classes/` — церковная магия

## Crafting (Крафт)

**Описание:** Рецепты крафта через `crafting_recipe` и рогутаунские крафты.

**Файлы:**
- `code/modules/roguetown/roguecrafting/` — крафт оружия, брони, алхимия
- `code/modules/crafting/` — общие рецепты
- `modular_twilight_axis/code/modules/roguetown/` — модульный крафт

## Reagents / Chemistry (Реагенты)

**Описание:** Химическая система с метаболизмом, эффектами от реагентов.

**Файлы:**
- `code/modules/reagents/` — реагенты, реакции, метаболизм
- `code/modules/food_and_drinks/` — еда и напитки
- `modular_twilight_axis/code/modules/reagents/` — модульные реагенты
- `modular/Neu_Food/` — сторонняя система еды

## NPC / AI

**Описание:** Простые мобы и human-like NPC с AI.

**Файлы:**
- `code/modules/mob/living/simple_animal/` — простые мобы
- `code/modules/mob/living/carbon/human/npc/` — human NPC
- `code/datums/ai/` — AI датумы

## Map / Areas / Dungeons (Карта и подземелья)

**Описание:** Статические `.dmm` карты + процедурные подземелья.

**Файлы:**
- `_maps/map_files/` — основной мир
- `_maps/templates/` — шаблоны
- `_maps/dungeon_generator/` — генератор подземелий
- `code/game/area/` — области (area) с освещением, музыкой, опасностью
- `code/controllers/subsystem/rogue/regional_threat/` — региональные угрозы

## Banking / Economy (Экономика)

**Описание:** Система монет, банковских счетов, цен, торговли.

**Файлы:**
- `code/modules/banking/` — банк, счета
- `code/modules/roguetown/roguemachine/merchant/` — торговцы
- `code/modules/roguetown/roguemachine/stockpile/` — склад
- `code/modules/roguetown/roguemachine/steward/` — управляющий

## PQ (Player Quality)

**Описание:** Система очков качества игрока. Влияет на доступ к ролям.

**Файлы:**
- `code/modules/pq/` — основа системы
- Конфиг: `#define USES_PQ` в `_compile_options.dm`

## TGUI (UI)

**Описание:** Современный React-интерфейс.

**Файлы:**
- `tgui/packages/tgui/interfaces/` — компоненты интерфейсов
- `code/modules/tgui/` — DM-часть TGUI
- Сборка: `tgui-build.cmd` (Yarn PnP, без node_modules в классическом виде)
