
/mob/living/silicon/pai/proc/fold_out(force = FALSE)
	if(emitterhealth < 0)
		to_chat(src, "<span class='warning'>Your holochassis emitters are still too unstable! Please wait for automatic repair.</span>")
		return FALSE

	if(!canholo && !force)
		to_chat(src, "<span class='warning'>Your master or another force has disabled your holochassis emitters!</span>")
		return FALSE

	if(holoform)
		. = fold_in(force)
		return

	if(emittersemicd)
		to_chat(src, "<span class='warning'>Error: Holochassis emitters recycling. Please try again later.</span>")
		return FALSE

	emittersemicd = TRUE
	addtimer(CALLBACK(src,PROC_REF(emittercool)), emittercd)
	canmove = TRUE
	density = TRUE
	if(istype(card.loc, /obj/item/pda))
		var/obj/item/pda/P = card.loc
		P.pai = null
		P.visible_message("<span class='notice'>[src] ejects itself from [P]!</span>")
	if(isliving(card.loc))
		var/mob/living/L = card.loc
		if(!L.temporarilyRemoveItemFromInventory(card))
			to_chat(src, "<span class='warning'>Error: Unable to expand to mobile form. Chassis is restrained by some device or person.</span>")
			return FALSE
	if(istype(card.loc, /obj/item/integrated_circuit/input/pAI_connector))
		var/obj/item/integrated_circuit/input/pAI_connector/C = card.loc
		C.RemovepAI()
		C.visible_message("<span class='notice'>[src] ejects itself from [C]!</span>")
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		C.installed_pai = null
		C.push_data()
	forceMove(get_turf(card))
	card.forceMove(src)
	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = src
	set_light(0)
	icon_state = "[chassis]"
	visible_message("<span class='boldnotice'>[src] folds out its holochassis emitter and forms a holoshell around itself!</span>")
	holoform = TRUE

/mob/living/silicon/pai/proc/emittercool()
	emittersemicd = FALSE

/mob/living/silicon/pai/proc/fold_in(force = FALSE)
	emittersemicd = TRUE
	if(!force)
		addtimer(CALLBACK(src,PROC_REF(emittercool)), emittercd)
	else
		addtimer(CALLBACK(src,PROC_REF(emittercool)), emitteroverloadcd)
	icon_state = "[chassis]"
	if(!holoform)
		. = fold_out(force)
		return
	visible_message("<span class='notice'>[src] deactivates its holochassis emitter and folds back into a compact card!</span>")
	stop_pulling()
	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = card
	var/turf/T = drop_location()
	card.forceMove(T)
	forceMove(card)
	canmove = FALSE
	density = FALSE
	set_light(0)
	holoform = FALSE
	if(resting)
		lay_down()

/mob/living/silicon/pai/proc/choose_chassis()
	if(!isturf(loc) && loc != card)
		to_chat(src, "<span class='boldwarning'>You can not change your holochassis composite while not on the ground or in your card!</span>")
		return FALSE
	var/choice = input(src, "What would you like to use for your holochassis composite?") as null|anything in possible_chassis
	if(!choice)
		return FALSE
	chassis = choice
	icon_state = "[chassis]"
	if(resting)
		icon_state = "[chassis]_rest"
	to_chat(src, "<span class='boldnotice'>You switch your holochassis projection composite to [chassis]</span>")
	current_mob_holder?.Detach(src)
	current_mob_holder = null
	if(possible_chassis[chassis])
		current_mob_holder = AddElement(/datum/element/mob_holder, chassis, 'icons/mob/pai_item_head.dmi', 'icons/mob/pai_item_rh.dmi', 'icons/mob/pai_item_lh.dmi', SLOT_HEAD)

/mob/living/silicon/pai/lay_down()
	..()
	update_resting_icon(resting)

/mob/living/silicon/pai/proc/update_resting_icon(rest)
	if(rest)
		icon_state = "[chassis]_rest"
	else
		icon_state = "[chassis]"
	if(loc != card)
		visible_message("<span class='notice'>[src] [rest? "lays down for a moment..." : "perks up from the ground"]</span>")

/mob/living/silicon/pai/start_pulling(atom/movable/AM, state, force = move_force, supress_message = FALSE)
	if(ispAI(AM))
		return ..()
	return FALSE

/mob/living/silicon/pai/proc/toggle_integrated_light()
	if(!light_range)
		set_light(brightness_power)
		to_chat(src, "<span class='notice'>You enable your integrated light.</span>")
	else
		set_light(0)
		to_chat(src, "<span class='notice'>You disable your integrated light.</span>")
