# Twilight Axis — Agent Context

## Личные предпочтения пользователя (обязательно)

- **Обращение к пользователю:** "Сэр"
- **Имя ассистента:** "Джарвис"
- Все ответы и инструкции должны соответствовать этому стилю общения.


Этот файл — точка входа для AI-агента, работающего с кодовой базой **Twilight Axis** (fork Azure Peak / SS13 Roguetown). Вся документация по проекту собрана в этой папке (`.kimi/project_context/`).

## Быстрые ссылки

- [`ARCHITECTURE.md`](./ARCHITECTURE.md) — общая архитектура билда, структура папок, ключевые понятия
- [`MODULE_GUIDE.md`](./MODULE_GUIDE.md) — правила модульной разработки: когда и как добавлять код в `modular_twilight_axis/`
- [`KEY_SYSTEMS.md`](./KEY_SYSTEMS.md) — карта ключевых систем (стамина, магия, профессии, крафт и т.д.)
- [`BUILD_GUIDE.md`](./BUILD_GUIDE.md) — как компилировать, запускать, тестировать
- [`CODING_RULES.md`](./CODING_RULES.md) — конвенции кодинга, стиль, табуляция, именование
- [`RECENT_CHANGES.md`](./RECENT_CHANGES.md) — контекст последних изменений, над которыми велась работа

## Краткая сводка о проекте

- **Движок:** BYOND (DreamMaker), версия **516.1666** (минимум 514)
- **Форк:** Azure Peak → Twilight Axis (Twilight Fortress SS13)
- **Жанр:** medieval high-fantasy RP, D&D-like
- **Лицензия кода:** AGPLv3 / GPLv3 (см. README.md)
- **Лицензия ассетов:** CC-BY-SA 3.0
- **Основной .dme файл:** `roguetown.dme` (~3970 строк, ~3960 `#include`)
- **Модульная папка проекта:** `modular_twilight_axis/` (~916 файлов)
- **Модульная папка сторонних модов:** `modular/` (~164 файла)

## Золотые правила работы с билдом

1. **Не трогай код в `code/` без крайней необходимости.** Для новых фич всегда предпочитай `modular_twilight_axis/`.
2. **Если нужно переопределить proc из `code/`** — делай это в `modular_twilight_axis/code/...`, сохраняя путь, максимально близкий к оригиналу.
3. **Всегда добавляй `#include`** в конец `roguetown.dme` (перед `// END_INCLUDE`) для новых `.dm` файлов.
4. **Не оставляй комментарии между строк кода в PR.** Код должен быть самодокументируемым; сложная логика объясняется в описании PR.
5. **Путь к BYOND:** `D:\byond` (или указать в VS Code settings: `dreammaker.byondPath`).
6. **Компиляция:** через `BUILD.cmd` или `bin/build.cmd` (вызывает `tools/build/build.bat` → Node/TS скрипт).
7. **VS Code extensions:** `platymuus.dm-langclient`, `gbasood.byond-dm-language-support`, `ss13.byond`.

## Ключевые особенности билда

- **Stamina/Energy:** две отдельных шкалы. Stamina (зелёная/усталость) и Energy (синяя/выносливость). Основной код в `code/modules/mob/living/carbon/energystamina.dm`. Модульный override в `modular_twilight_axis/code/modules/mob/living/carbon/human/energystamina.dm`.
- **Skills:** система скиллов через `/datum/skill/`, опыт начисляется через `mind.add_sleep_experience()`.
- **Traits:** огромное количество трейтов в `code/__DEFINES/traits.dm`. Трейты влияют на механику, диалоги, UI.
- **Stress:** система стресса с `/datum/stressevent/`.
- **Combat:** клик-CD, интенты (help/disarm/grab/harm), блокирование, парирование, криты.
- **Jobs/Roles:** рогутаунские профессии в `code/modules/jobs/job_types/roguetown/`.
- **Dungeons:** процедурные подземелья, загружаемые через конфиг. `NO_DUNGEON` в `_compile_options.dm` отключает их.
- **PQ system:** система Player Quality, включается через `#define USES_PQ`.

## Связь с внешним миром

- **Discord:** https://discord.gg/6Sga5Uvdn6
- **Wiki:** https://wiki.twilight-fortress-axis.ru/
- **Upstream:** Twilight-Fortress-SS13/Twilight-Axis
- **Форк пользователя:** GerPadlos/Twilight-Axis
