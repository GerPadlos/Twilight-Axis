# Сборка и запуск

## Требования

- **BYOND:** версия **516.1666** (рекомендуется) или минимум **514**
  - Путь установки: `D:\byond`
  - В PATH должны быть `D:\byond\bin`
- **VS Code** (рекомендуется для разработки)
- **Git** (для клонирования и PR)

## VS Code Setup

### Обязательные extensions

| Extension | ID | Назначение |
|-----------|-----|-----------|
| DM Language Support | `platymuus.dm-langclient` | LSP, автодополнение, дебаг |
| BYOND DM Language Support | `gbasood.byond-dm-language-support` | Подсветка синтаксиса |
| DreamMaker | `ss13.byond` | Extension pack (включает два выше + дополнительные) |
| EditorConfig | `EditorConfig.EditorConfig` | Единый стиль отступов |

### Настройка пути к BYOND

В настройках VS Code (User или Workspace JSON):

```json
{
    "dreammaker.byondPath": "D:\\byond"
}
```

Если дебаг не запускается с ошибкой "Byond Path setting does not point to a DreamSeeker executable" — проверь, что `D:\byond\bin\dreamseeker.exe` существует.

### Launch configurations

Файл `.vscode/launch.json` содержит конфигурации:
- `Launch DreamSeeker` — локальный запуск клиента
- `Launch DreamDaemon` — запуск сервера
- Различные варианты с префиксами `(Local Testing)`, `(Low Memory Mode)`, `(No Dungeon)`

Все используют:
- `"type": "byond"`
- `"dmb": "${workspaceFolder}/${command:CurrentDMB}"`
- Pre-launch task: `Build All` или его вариации

## Компиляция

### Через batch-скрипты

```cmd
BUILD.cmd          # Основная сборка
bin\build.cmd      # Алиас
bin\test.cmd       # Сборка + тесты
bin\clean.cmd      # Очистка
```

`BUILD.cmd` вызывает `tools/build/build.bat`, который через Node запускает `tools/build/build.ts`.

### Через DreamMaker (ручная)

1. Открыть `roguetown.dme` в DreamMaker.
2. `Build → Compile` (или Ctrl+K).
3. Результат: `roguetown.dmb` + `roguetown.rsc` в корне.

### Флаги компиляции (`code/_compile_options.dm`)

| Флаг | Значение |
|------|----------|
| `MATURESERVER` | Включён всегда, пометка "взрослый сервер" |
| `TESTSERVER` | Отладка: редактирование inhand, доп. опции |
| `ALLOWPLAY` | Разрешить вход игроков |
| `DEBUG` | Режим отладки (кастомный обработчик ошибок) |
| `LOWMEMORYMODE` | Принудительная загрузка `roguetest.json` |
| `NO_DUNGEON` | Отключение подземелий |
| `USES_PQ` | Система Player Quality |
| `USES_TRAIT_SKILL_GATING` | Ограничение скиллов трейтами |
| `NPC_THINK_DEBUG` | Отображение мыслей NPC над головой |
| `REVIVE_GRACE` | Льготный период воскрешения (TA edit) |

Для включения/отключения флага раскомментируй/закомментируй `#define`.

## Запуск сервера

```cmd
bin\server.cmd
```

Или вручную:
```cmd
D:\byond\bin\dreamdaemon.exe roguetown.dmb -port 7777 -trusted
```

## Запуск клиента (локально)

```cmd
bin\tgui-dev.cmd    # TGUI dev server (hot reload UI)
```

Для подключения к локальному серверу:
```cmd
D:\byond\bin\dreamseeker.exe byond://localhost:7777
```

## CI / GitHub Actions

Файлы в `.github/workflows/`:

| Workflow | Назначение |
|----------|-----------|
| `ci_suite.yml` | Главный CI пайплайн |
| `run_linters.yml` | Линтеры (DreamChecker / SpacemanDMM) |
| `compile_all_maps.yml` | Компиляция всех карт |
| `run_integration_tests.yml` | Интеграционные тесты |
| `collect_data.yml` | Сбор данных для CI |
| `setup_build_artifacts.yml` | Артефакты сборки |
| `auto_changelog.yml` | Авто-генерация чейнджлогов |

**BYOND версия в CI:** `BYOND_MAJOR: 516`, `BYOND_MINOR: 1666`

## TGUI (UI)

### Сборка TGUI

```cmd
tgui-build.cmd      # Продакшен сборка
tgui-dev.cmd        # Dev server с hot reload
tgui-bench.cmd      # Бенчмарки
```

TGUI использует **Yarn PnP** (Plug'n'Play). `node_modules/` не существует в классическом виде; зависимости хранятся в `.pnp.cjs` и `.yarn/cache`.

### Структура TGUI

- `tgui/packages/tgui/` — основные компоненты
- `tgui/packages/tgui/interfaces/` — интерфейсы игры
- `tgui/packages/tgui/styles/` — стили
- `tgui/public/` — статика

## Проблемы сборки

### "BYOND debugging cannot start..."
- Проверь `dreammaker.byondPath` в VS Code settings.
- Путь должен указывать на папку BYOND (`D:\byond`), а не на `bin`.

### Ошибки компиляции после добавления модуля
- Проверь `#include` в `roguetown.dme`.
- Проверь, что путь в `#include` использует обратные слэши (`\`).
- Проверь отсутствие синтаксических ошибок в новом `.dm` файле.

### Low Memory Mode
- Если компилятор падает по памяти (ОЗУ < 8 ГБ), раскомментируй `#define LOWMEMORYMODE` в `_compile_options.dm`.
- Это загрузит уменьшенную карту `roguetest.json`.

### Карты не компилируются
- Убедись, что `.dmm` файлы не повреждены.
- Проверь версию BYOND — минимум 514.
