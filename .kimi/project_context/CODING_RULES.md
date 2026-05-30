# Правила кодинга и конвенции

## Стиль отступов

- **Табуляция** для отступов (не пробелы).
- Размер таба в редакторе: **4 пробела** (для отображения).
- `.editorconfig` в корне проекта задаёт:
  ```ini
  indent_style = tab
  indent_size = 4
  ```

## Форматирование

```dm
/proc/my_proc(var/mob/living/user)
	if(!user)
		return
	
	var/some_value = 10
	for(var/i in 1 to some_value)
		user.do_something(i)
```

- **Пробелы вокруг операторов:** `a + b`, `x == y`
- **Без пробела перед скобками вызова:** `proc_name(args)`
- **Пробел после запятых:** `list(a, b, c)`

## Именование

| Сущность | Стиль | Пример |
|----------|-------|--------|
| Переменные / поля | snake_case | `max_stamina`, `last_fatigued` |
| Proc'ы | snake_case | `stamina_add()`, `calculate_energy()` |
| Типы / датумы | PascalCase | `/datum/skill/misc/athletics` |
| Трейты | UPPER_SNAKE_CASE | `TRAIT_INFINITE_STAMINA` |
| Дефайны | UPPER_SNAKE_CASE | `CLICK_CD_MELEE`, `WILLPOWER_MODIFIER` |
| Глобальные переменные | snake_case с префиксом | `GLOB.tod` |

## Комментарии

- **Не оставляй комментарии между строк кода в PR.**
- Если нужно пояснить логику — делай это в описании PR.
- Внутри кода комментарии допустимы только для временных FIXME / TODO:
  ```dm
  // FIXME: временный костыль, убрать после рефактора боя
  ```

## Принципы DM

### Переопределение proc'ов

```dm
/mob/living/stamina_add(added as num, emote_override, force_emote = TRUE)
	// модульная реализация
```

DM позволяет объявлять proc с тем же путём типа повторно — последняя версия побеждает.

### Вызов родителя

```dm
/mob/living/carbon/human/my_proc()
	..()  // вызов родительского proc'а
	// дополнительная логика
```

### Предикаты (ранние return'ы)

```dm
/mob/living/proc/my_proc()
	if(HAS_TRAIT(src, TRAIT_SOMETHING))
		return TRUE
	
	// основная логика
```

### Типизация аргументов

```dm
/proc/my_proc(mob/living/user, obj/item/I, amount as num)
```

## Работа с трейтами

```dm
if(HAS_TRAIT(src, TRAIT_MY_TRAIT))
	// логика

ADD_TRAIT(src, TRAIT_MY_TRAIT, TRAIT_SOURCE)
REMOVE_TRAIT(src, TRAIT_MY_TRAIT, TRAIT_SOURCE)
```

## Работа со скиллами

```dm
mind.add_sleep_experience(/datum/skill/misc/athletics, amount, show_xp = TRUE)
var/skill_level = get_skill_level(/datum/skill/misc/athletics)
```

## Работа с балун-алертами

```dm
balloon_alert(user, "Текст")
balloon_alert_to_viewers(self_message, viewer_message, range)
filtered_balloon_alert(filter_trait, message, x_offset, y_offset)
```

## Структура PR

См. `.github/PULL_REQUEST_TEMPLATE.md`:

1. **About The Pull Request** — краткое описание изменений.
2. **Testing Evidence** — скриншоты, видео или описание тестов.
3. **Why It's Good For The Game** — обоснование.
4. **Changelog** (`:cl:`) — список изменений для игроков.

## Защита от null и runtime при спавне (критически важно)

**Урок из инцидента с Renegade Inquisitor:** краш/рантайм при спавне из-за отсутствия проверок на `null` в `after_spawn` и `pre_equip`.

### Обязательные проверки в job/outfit коде

```dm
// ❌ Неправильно — runtime если H.dna ещё не создан
var/race = H.dna.species

// ✅ Правильно — безопасный доступ с fallback
var/race = H.dna?.species || "Unknown"
```

```dm
// ❌ Неправильно — runtime если H.mind = null
H.mind.person_knows_me(MF)

// ✅ Правильно — проверяем перед использованием
if(H.mind)
    H.mind.person_knows_me(MF)
```

```dm
// ❌ Неправильно — input() может вернуть null если игрок закрыл окно
var/weapon_choice = input(H, "Choose", "Title") as anything in weapons
switch(weapon_choice)  // null не попадёт ни в один case

// ✅ Правильно — дефолтное значение при отмене
var/weapon_choice = input(H, "Choose", "Title") as anything in weapons
if(!weapon_choice)
    weapon_choice = "Default Option"
switch(weapon_choice)
```

### Правило: проверяй в цепочке спавна

При спавне моба следующие вещи могут быть `null`:

| Что | Когда null | Где проверять |
|-----|-----------|---------------|
| `H.mind` | Rare, но возможно при latejoin edge cases | `after_spawn`, `pre_equip` |
| `H.dna` | До полной инициализации `create_character` | `pre_equip`, outfit procs |
| `H.client` | В `after_spawn` (key ещё не передан) | Не полагаться на `client` в `after_spawn` |
| `owner.current` | При `on_removal` если моб уже удалён | `on_removal()` антаг датумов |

### Правило: защищай `UnregisterSignal`

```dm
// ❌ Неправильно — runtime если owner.current = null
UnregisterSignal(owner.current, COMSIG_SOME_SIGNAL)

// ✅ Правильно
if(owner?.current)
    UnregisterSignal(owner.current, COMSIG_SOME_SIGNAL)
```

## Запрещено

- **Хардкод путей** — используй дефайны и константы.
- **Магические числа** — выноси в дефайны (`#define MY_CONSTANT 42`).
- **Дублирование кода** — если логика повторяется, вынеси в proc/датум.
- **Смешение ответственности** — UI, логика и данные должны быть разделены.
- **Изменение `code/` без причины** — всегда предпочитай `modular_twilight_axis/`.
