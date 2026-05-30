/datum/action/cooldown/spell/smoke_veil
	name = "Smoke Veil"
	desc = "Call forth a veil of concealing smoke to cover your escape or blind your foes."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune6"
	sound = 'sound/magic/blink.ogg'
	spell_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW

	self_cast_possible = TRUE
	click_to_activate = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_AOE

	invocations = list("Obscura Psydonis!")
	invocation_type = INVOCATION_SHOUT

	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/holy
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/smoke_veil/cast(atom/cast_on)
	. = ..()
	var/turf/T = get_turf(owner)
	if(!T)
		return FALSE
	owner.visible_message(span_warning("[owner] raises their cross and a thick veil of smoke erupts around them!"))
	playsound(T, 'sound/magic/blink.ogg', 60, TRUE)
	for(var/turf/nearby in range(2, T))
		new /obj/effect/particle_effect/smoke(nearby)
	return TRUE
