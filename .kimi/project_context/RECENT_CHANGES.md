# Контекст недавней работы

## PR #1072 — stamina_add refactor

**Статус:** Обновлён (force-push в `MrPadlos_Ultra_Coding`)

**Что сделано:**
- Создан модульный override `modular_twilight_axis/code/modules/mob/living/carbon/human/energystamina.dm`
- Переопределён `/mob/living/stamina_add()` — полностью заменена оригинальная реализация из `code/modules/mob/living/carbon/energystamina.dm`
- Добавлен `#include` в конец `roguetown.dme`

**Ключевые изменения логики (по сравнению с оригиналом):**

| Аспект | Оригинал | PR #1072 |
|--------|----------|----------|
| `energy_add` при стамине | `added * -1` | `added * -0.6` |
| `adjust_nutrition` | `-stamina_nutrition_mod(added)` | `-stamina_nutrition_mod(added) * 0.5` |
| Порог для heart attack | `added >= 5 && energy <= 0` | тот же |
| Балун-алерты | Есть (Winded/Drained/Fatigued) | Есть, сохранены |
| Условие heart attack в water | отсутствует | добавлено (`necra_area`) |
| `heart_attack` при stress >= 30 | отсутствует | добавлено |
| Комментарии | Были в коде | **Удалены по требованию** |

**Файлы затронутые PR:**
- `modular_twilight_axis/code/modules/mob/living/carbon/human/energystamina.dm` (создан)
- `roguetown.dme` (добавлен include)

**Ветка:** `MrPadlos_Ultra_Coding` → `Twilight-Fortress-SS13/Twilight-Axis:main`

---

## Настройка VS Code для BYOND

**Проблема:** Ошибка "BYOND debugging cannot start because your Byond Path setting does not point to a DreamSeeker executable"

**Решение:**
- Путь к BYOND: `D:\byond`
- Правильная настройка VS Code: `"dreammaker.byondPath": "D:\\byond"`
- DreamSeeker находится по `D:\byond\bin\dreamseeker.exe`
- Расширение, требующее настройку: `platymuus.dm-langclient` (предоставляет debugger type `byond`)

---

## Текущая ветка разработки

- **Локальная ветка:** `MrPadlos_Ultra_Coding` (отслеживает `origin/MrPadlos_Ultra_Coding`)
- **Удалённый репозиторий:** `origin` = `https://github.com/GerPadlos/Twilight-Axis.git`
- **Upstream:** `https://github.com/Twilight-Fortress-SS13/Twilight-Axis.git`

---

## Renegade Inquisitor — исправление краша при спавне

**Проблема:** Краш/рантайм сразу после выбора оружия при спавне за Renegade Inquisitor.

**Причина:** Отсутствие null-check'ов в критических точках спавна:
1. `renegade_inquisitor_bounty()` — `H.dna.species` без проверки `H.dna`
2. `after_spawn()` — `H.mind.person_knows_me()` без проверки `H.mind`
3. `choose_loadout()` / `pre_equip()` — `input()` возвращает `null` при закрытии окна
4. `on_removal()` — `UnregisterSignal(owner.current, ...)` без проверки `owner?.current`

**Решение:**
- `H.dna?.species || "Unknown"` — безопасный доступ
- `if(H.mind)` перед `person_knows_me()`
- `if(!weapon_choice) weapon_choice = "Default"` — fallback для `input()`
- `if(owner?.current)` перед `UnregisterSignal`

**Файлы затронутые:**
- `modular_twilight_axis/code/modules/jobs/job_types/roguetown/adventurer/types/wretch/renegade_inquisitor.dm`
- `modular_twilight_axis/code/modules/jobs/job_types/roguetown/other/renegade_inquisitor_job.dm`
- `modular_twilight_axis/code/modules/antagonists/roguetown/renegade_inquisitor.dm`
- `code/modules/jobs/jobs.dm` — добавлен "Renegade Inquisitor" в `GLOB.antagonist_positions`

**Spawn point:** 
- Привязан к Wretch landmarks (`wretch` для roundstart, `wretchlate` для latejoin) через `after_spawn` teleport.
- Fallback на `latejoin_trackers` если Wretch landmarks отсутствуют на карте (например, `roguetest.dmm`).
- Создан `obj/effect/landmark/start/renegade_inquisitor` для размещения мапперами на картах.

**Урок занесён в:** `CODING_RULES.md` → раздел "Защита от null и runtime при спавне"

---

## Что нужно помнить при дальнейшей работе

1. **Stamina/Energy** — чувствительная механика баланса. Любые изменения коэффициентов (`-0.6`, `* 0.5`) влияют на геймплей напрямую.
2. **Modular override** `stamina_add` полностью заменяет оригинал. Если апстрим изменит `code/modules/mob/living/carbon/energystamina.dm`, модульный файл НЕ автоматически подхватит изменения.
3. **Все новые правки stamina** должны идти в `modular_twilight_axis/code/modules/mob/living/carbon/human/energystamina.dm`.
4. **roguetown.dme** — при конфликтах слияния проверять, что модульные includes остаются в конце файла.
5. **Null-safety при спавне** — всегда проверяй `H.mind`, `H.dna`, `owner?.current` в `after_spawn`, `pre_equip`, `on_removal`.
