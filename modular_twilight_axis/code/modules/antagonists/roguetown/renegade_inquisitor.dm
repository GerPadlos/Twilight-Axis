/datum/antagonist/renegade_inquisitor
	name = "Renegade Inquisitor"
	roundend_category = "renegade inquisitors"
	antagpanel_category = "Renegade Inquisitor"
	job_rank = ROLE_RENEGADE_INQUISITOR
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "renegade_inquisitor"
	confess_lines = list(
		"PSYDON SPEAKS THROUGH ME!",
		"I HAVE SEEN THE TRUE PATH!",
		"THE CROSS GUIDES MY HAND!",
	)
	rogue_enabled = TRUE
	has_tempo = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_favor_flags = STORYTELLER_FAVOR_BANDIT
	override_candidatereq = TRUE
	storyteller_min_players = 20
	storyteller_slot_scaling = 1
	storyteller_slot_default_cap = 1

/datum/antagonist/renegade_inquisitor/on_gain()
	. = ..()
	if(owner)
		owner.special_role = "Renegade Inquisitor"
		forge_objectives()
		finalize_renegade()
		RegisterSignal(owner.current, COMSIG_TORTURE_PERFORMED, PROC_REF(on_torture))
		RegisterSignal(SSdcs, COMSIG_GLOB_ROLE_CONVERTED, PROC_REF(on_convert))

/datum/antagonist/renegade_inquisitor/on_removal()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_TORTURE_PERFORMED)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ROLE_CONVERTED)
	. = ..()

/datum/antagonist/renegade_inquisitor/proc/on_torture(datum/source, mob/living/torturer, mob/living/victim)
	SIGNAL_HANDLER
	if(!owner || !owner.current)
		return
	var/mob/living/carbon/human/H = owner.current
	if(!H.mind || !H.mind.renegade_progress)
		return
	H.mind.renegade_progress.torture_count++
	to_chat(H, span_notice("The cross shudders with pleasure. Another sinner has been broken. ([H.mind.renegade_progress.torture_count] total)"))

/datum/antagonist/renegade_inquisitor/proc/on_convert(datum/source, mob/living/converter, mob/living/converted, role)
	SIGNAL_HANDLER
	if(!owner || !owner.current)
		return
	var/mob/living/carbon/human/H = owner.current
	if(!H.mind || !H.mind.renegade_progress)
		return
	if(converter != H)
		return
	H.mind.renegade_progress.convert_count++
	to_chat(H, span_notice("The cross thrums with approval. Another soul has been claimed for the Allfather. ([H.mind.renegade_progress.convert_count] total)"))

/datum/antagonist/renegade_inquisitor/proc/forge_objectives()
	var/datum/objective/ascend/O = new()
	O.owner = owner
	objectives += O

/datum/antagonist/renegade_inquisitor/proc/finalize_renegade()
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/inquisitorcombat.ogg', 60, FALSE, pressure_affected = FALSE)
	var/mob/living/carbon/human/H = owner.current
	H.verbs |= /mob/proc/haltyell_exhausting
	ADD_TRAIT(H, TRAIT_OUTLANDER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_OUTLAW, TRAIT_GENERIC)
	to_chat(H, span_alertsyndie("I am a RENEGADE INQUISITOR!"))
	to_chat(H, span_boldwarning("During a distant mission, you found a holy cross of Psydon. The Allfather speaks to you now, granting you strength beyond the church's dogma. You are hunted by your former brothers, yet you walk a higher path—one of ascension. Perform rituals, complete the cross's tasks, and rise to divine power."))
