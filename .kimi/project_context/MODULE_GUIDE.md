# Руководство по модульной системе

## Философия

Проект Twilight Axis — форк от Azure Peak. Чтобы облегчить будущие обновления от апстрима и избежать конфликтов слияний, **весь новый код должен добавляться в `modular_twilight_axis/`** вместо прямого изменения `code/`.

## Две модульных папки

| Папка | Назначение | Кто поддерживает |
|-------|-----------|------------------|
| `modular_twilight_axis/` | Код проекта Twilight Axis | Команда Twilight Fortress |
| `modular/` | Сторонние модули, портированные с других форков (Neu_Food, Neu_Farming, Creechers) | Сообщество / портирующий |

> **Правило:** Новые фичи проекта добавляются **только** в `modular_twilight_axis/`.

## Структура модуля

Каждый модуль в `modular_twilight_axis/` может быть организован одним из двух способов:

### Способ A: Тематический модуль (для крупных фич)
```
modular_twilight_axis/firearms/
├── code/
│   ├── _firearms.dm
│   ├── pistol.dm
│   └── musket.dm
├── icons/
│   └── firearms.dmi
└── sound/
    └── gunshot.ogg
```

### Способ B: Плоская структура `code/` (для мелких правок)
```
modular_twilight_axis/code/modules/mob/living/carbon/human/energystamina.dm
modular_twilight_axis/code/datums/status_effects/rogue/debuff.dm
modular_twilight_axis/code/game/area/basingrove.dm
```

Путь внутри `modular_twilight_axis/code/` должен **максимально повторять** путь в `code/`, чтобы было очевидно, какой оригинальный файл переопределяется.

## Как добавить новый файл

1. **Создай файл** в правильном месте `modular_twilight_axis/...`.
2. **Добавь `#include`** в `roguetown.dme` в секцию модульных включений **в самом конце**, перед `// END_INCLUDE`.
   ```dm
   #include "modular_twilight_axis\code\modules\mob\living\carbon\human\energystamina.dm"
   ```
3. **Компилируй** через `BUILD.cmd`.
4. **Проверь**, что модуль загружается (проверь DreamMaker Output на ошибки).

## Как переопределить proc

DM позволяет переопределять proc'ы простым объявлением с тем же путём типа. Если в `code/modules/mob/living/carbon/energystamina.dm` есть:

```dm
/mob/living/stamina_add(added as num, emote_override, force_emote = TRUE)
```

То в `modular_twilight_axis/code/modules/mob/living/carbon/human/energystamina.dm` можно написать:

```dm
/mob/living/stamina_add(added as num, emote_override, force_emote = TRUE)
	// новая логика
```

DM исполнит версию из последнего `#include` в `.dme`. Поскольку модульные включения идут в конце `roguetown.dme`, модульный proc **всегда побеждает** оригинальный.

> **Важно:** Если нужно вызвать оригинальный proc, используй `..()`, но для полных переопределений (как `stamina_add`) оригинал может быть полностью заменён.

## Где что размещать

| Что добавляешь | Куда класть |
|---------------|-------------|
| Новый предмет / оружие / одежда | `modular_twilight_axis/code/game/objects/...` + `icons/` |
| Новый моб / NPC | `modular_twilight_axis/code/modules/mob/living/...` |
| Новый скилл | `modular_twilight_axis/code/datums/skills/...` |
| Новый статус-эффект | `modular_twilight_axis/code/datums/status_effects/...` |
| Новая профессия | `modular_twilight_axis/code/modules/jobs/...` |
| Новая область (area) | `modular_twilight_axis/code/game/area/...` |
| Новый спелл | `modular_twilight_axis/code/modules/spells/...` |
| Новый реагент / еда | `modular_twilight_axis/code/modules/reagents/...` |
| Лор-контент (расы, боги, языки) | `modular_twilight_axis/lore/...` |

## Иконки и звуки

- Иконки размещай в `modular_twilight_axis/icons/` (или в подпапке модуля).
- Звуки — в `modular_twilight_axis/sound/`.
- В коде ссылайся на них относительно корня:
  ```dm
  icon = 'modular_twilight_axis/icons/my_feature.dmi'
  ```

## Чего НЕ делать

- **Не редактируй `code/` напрямую**, если можно обойтись модулем.
- **Не добавляй `#include` в середину `roguetown.dme`** — только в конец, в блок модульных файлов.
- **Не создавай циклических зависимостей** между `modular_twilight_axis/` и `code/`.
- **Не клади в `modular/` новый код проекта** — это папка для портированных модов.

## Примеры из проекта

- **Artillery:** `modular_twilight_axis/awful_artillery/` — полноценный модуль с code/, icons/, sound/
- **Stamina override:** `modular_twilight_axis/code/modules/mob/living/carbon/human/energystamina.dm` — переопределение `stamina_add`
- **Lore:** `modular_twilight_axis/lore/` — расы, языки, боги, профессии
- **Church classes:** `modular_twilight_axis/church_classes/` — новые классы для церкви
