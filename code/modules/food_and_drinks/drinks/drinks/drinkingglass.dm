

/obj/item/reagent_containers/food/drinks/drinkingglass
	name = "drinking glass"
	desc = "Your standard drinking glass."
	icon_state = "glass_empty"
	amount_per_transfer_from_this = 10
	volume = 50
	materials = list(MAT_GLASS=500)
	max_integrity = 20
	spillable = TRUE
	resistance_flags = ACID_PROOF
	obj_flags = UNIQUE_RENAME

	drop_sound = 'sound/items/handling/drinkglass_drop.ogg'
	pickup_sound =  'sound/items/handling/drinkglass_pickup.ogg'

/obj/item/reagent_containers/food/drinks/drinkingglass/on_reagent_change(changetype)
	cut_overlays()
	if(reagents.reagent_list.len)
		var/datum/reagent/R = reagents.get_master_reagent()
		if(!renamedByPlayer)
			name = R.glass_name
			desc = R.glass_desc
		if(R.glass_icon_state)
			icon_state = R.glass_icon_state
		else
			var/mutable_appearance/reagent_overlay = mutable_appearance(icon, "glassoverlay")
			icon_state = "glass_empty"
			reagent_overlay.color = mix_color_from_reagents(reagents.reagent_list)
			add_overlay(reagent_overlay)
	else
		icon_state = "glass_empty"
		renamedByPlayer = FALSE //so new drinks can rename the glass

//Shot glasses!//
//  This lets us add shots in here instead of lumping them in with drinks because >logic  //
//  The format for shots is the exact same as iconstates for the drinking glass, except you use a shot glass instead.  //
//  If it's a new drink, remember to add it to Chemistry-Reagents.dm  and Chemistry-Recipes.dm as well.  //
//  You can only mix the ported-over drinks in shot glasses for now (they'll mix in a shaker, but the sprite won't change for glasses). //
//  This is on a case-by-case basis, and you can even make a separate sprite for shot glasses if you want. //

/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass
	name = "shot glass"
	desc = "A shot glass - the universal symbol for bad decisions."
	icon_state = "shotglass"
	gulp_size = 15
	amount_per_transfer_from_this = 15
	possible_transfer_amounts = list()
	volume = 15
	materials = list(MAT_GLASS=100)

/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass/on_reagent_change(changetype)
	cut_overlays()

	if (gulp_size < 15)
		gulp_size = 15
	else
		gulp_size = max(round(reagents.total_volume / 15), 15)

	if (reagents.reagent_list.len > 0)
		var/datum/reagent/largest_reagent = reagents.get_master_reagent()
		name = "filled shot glass"
		desc = "The challenge is not taking as many as you can, but guessing what it is before you pass out."

		if(largest_reagent.shot_glass_icon_state)
			icon_state = largest_reagent.shot_glass_icon_state
		else
			icon_state = "shotglassclear"
			var/mutable_appearance/shot_overlay = mutable_appearance(icon, "shotglassoverlay")
			shot_overlay.color = mix_color_from_reagents(reagents.reagent_list)
			add_overlay(shot_overlay)


	else
		icon_state = "shotglass"
		name = "shot glass"
		desc = "A shot glass - the universal symbol for bad decisions."
		return

/obj/item/reagent_containers/food/drinks/drinkingglass/filled/Initialize()
	. = ..()
	on_reagent_change(ADD_REAGENT)

/obj/item/reagent_containers/food/drinks/drinkingglass/filled/soda
	name = "Soda Water"
	list_reagents = list(/datum/reagent/consumable/sodawater = 50)

/obj/item/reagent_containers/food/drinks/drinkingglass/filled/cola
	name = "Space Cola"
	list_reagents = list(/datum/reagent/consumable/space_cola = 50)

/obj/item/reagent_containers/food/drinks/drinkingglass/filled/nuka_cola
	name = "Nuka Cola"
	list_reagents = list(/datum/reagent/consumable/nuka_cola = 50)
	price = 7

/obj/item/reagent_containers/food/drinks/drinkingglass/filled/syndicatebomb
	name = "Syndicat Bomb"
	list_reagents = list(/datum/reagent/consumable/ethanol/syndicatebomb = 50)

/obj/item/reagent_containers/food/drinks/drinkingglass/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg)) //breaking eggs
		var/obj/item/reagent_containers/food/snacks/egg/E = I
		if(reagents)
			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, "<span class='notice'>[src] is full.</span>")
			else
				to_chat(user, "<span class='notice'>You break [E] in [src].</span>")
				reagents.add_reagent(/datum/reagent/consumable/eggyolk, 5)
				qdel(E)
			return
	else
		..()

/obj/item/reagent_containers/food/drinks/drinkingglass/attack(obj/target, mob/user)
	if(user.a_intent == INTENT_HARM && ismob(target) && target.reagents && reagents.total_volume)
		target.visible_message("<span class='danger'>[user] splashes the contents of [src] onto [target]!</span>", \
						"<span class='userdanger'>[user] splashes the contents of [src] onto [target]!</span>")
		log_combat(user, target, "splashed", src)
		reagents.reaction(target, TOUCH)
		reagents.clear_reagents()
		return
	..()

/obj/item/reagent_containers/food/drinks/drinkingglass/afterattack(obj/target, mob/user, proximity)
	. = ..()
	if((!proximity) || !check_allowed_items(target,target_self=1))
		return

	else if(reagents.total_volume && user.a_intent == INTENT_HARM)
		user.visible_message("<span class='danger'>[user] splashes the contents of [src] onto [target]!</span>", \
							"<span class='notice'>You splash the contents of [src] onto [target].</span>")
		reagents.reaction(target, TOUCH)
		reagents.clear_reagents()
		return

//gs13 Big Glup Cups

/obj/item/reagent_containers/food/drinks/flask/paper_cup
	name = "paper cup"
	icon = 'GainStation13/icons/obj/paper_cups.dmi'
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50)
	volume = 50
	reagent_flags = OPENCONTAINER
	spillable = TRUE
	container_HP = 5

	pickup_sound = 'sound/items/handling/cardboardbox_pickup.ogg'
	drop_sound = 'sound/items/handling/cardboardbox_drop.ogg'

/obj/item/reagent_containers/food/drinks/flask/paper_cup/small
	name = "Small Gulp Cup"
	desc = "A paper cup. It can hold up to 50 units. It's not very strong."
	icon_state = "small"
	materials = list(MAT_PLASTIC=200)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/drinks/flask/paper_cup/medium
	name = "Medium Gulp Cup"
	desc = "It's a paper cup, but you wouldn't call it 'medium' though. It can hold up to 75 units. It's not very strong."
	icon_state = "medium"
	volume = 75
	materials = list(MAT_PLASTIC=300)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/food/drinks/flask/paper_cup/big
	name = "Big Gulp Cup"
	desc = "A huge paper cup, a normal person would struggle to drink it all in one sitting. It can hold up to 120 units. It's not very strong."
	icon_state = "big"
	volume = 120
	materials = list(MAT_PLASTIC=500)
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/drinks/flask/paper_cup/extra_big
	name = "Extra Big Gulp Cup"
	desc = "A comically large paper cup. It can hold up to 160 units. It's not very strong."
	icon_state = "extra_big"
	volume = 160
	materials = list(MAT_PLASTIC=600)
	w_class = WEIGHT_CLASS_BULKY

/obj/item/reagent_containers/food/drinks/flask/paper_cup/super_extra_big
	name = "Super Extra Big Gulp Cup"
	desc = "Its called a paper 'cup', but it looks more like an oversized bucket to you. It can hold up to 250 units. It's not very strong."
	icon_state = "super_extra_big"
	volume = 250
	materials = list(MAT_PLASTIC=1000)
	w_class = WEIGHT_CLASS_HUGE
