/*
CONTAINS:
CIG PACKET
ZIPPO


*/
/obj/item/weapon/cigpacket/proc/update_icon()
	return

/obj/item/weapon/cigpacket/update_icon()
	src.icon_state = text("cigpacket[]", src.cigcount)
	src.desc = text("There are [] cigs\s left!", src.cigcount)
	return

/obj/item/weapon/cigpacket/attack_hand(mob/user as mob)
	if(user.r_hand == src || user.l_hand == src)
		if(src.cigcount == 0)
			user << "\red You're out of cigs, shit! How you gonna get through the rest of the day..."
			return
		else
			src.cigcount--
			var/obj/item/clothing/mask/cigarette/W = new /obj/item/clothing/mask/cigarette(user)
			if(user.hand)
				user.l_hand = W
			else
				user.r_hand = W
			W.layer = 20
			user.update_clothing()
	else
		return ..()
	src.update_icon()
	return


#define ZIPPO_LUM 2

/obj/item/weapon/zippo/attack_self(mob/user)
	if(user.r_hand == src || user.l_hand == src)
		if(!src.lit)
			src.lit = 1
			src.icon_state = "zippoon"
			src.item_state = "zippoon"
			for(var/mob/O in viewers(user, null))
				O.show_message("\red Without even breaking stride, [user] flips open and lights the [src] in one smooth movement.", 1)

			user.ul_SetLuminosity(user.luminosity + ZIPPO_LUM)
			spawn(0)
				process()
		else
			src.lit = 0
			src.icon_state = "zippo"
			src.item_state = "zippo"
			for(var/mob/O in viewers(user, null))
				O.show_message("\red You hear a quiet click, as [user] shuts off the [src] without even looking at what they're doing. Wow.", 1)

			user.ul_SetLuminosity(user.luminosity - ZIPPO_LUM)
	else
		return ..()
	return
/obj/item/weapon/zippo/lighter/attack_self(mob/user)
	if(user.r_hand == src || user.l_hand == src)
		if(!src.lit)
			src.lit = 1
			src.icon_state = "lighteron"
			src.item_state = "zippoon"
			for(var/mob/O in viewers(user, null))
				O.show_message("\red [user] lights the [src].", 1)

			user.ul_SetLuminosity(user.luminosity + ZIPPO_LUM)
			spawn(0)
				process()
		else
			src.lit = 0
			src.icon_state = "lighter"
			src.item_state = "zippo"
			for(var/mob/O in viewers(user, null))
				O.show_message("\red [user] shuts the [src] off", 1)

			user.ul_SetLuminosity(user.luminosity - ZIPPO_LUM)
	else
		return ..()
	return

/obj/item/weapon/zippo/process()

	while(src.lit)
		var/turf/location = src.loc

		if(istype(location, /mob/))
			var/mob/M = location
			if(M.l_hand == src || M.r_hand == src)
				location = M.loc
		if (istype(location, /turf))
			location.hotspot_expose(SPARK_TEMP, 5)
		sleep(10)


/obj/item/weapon/zippo/pickup(mob/user)
	if(lit)
		src.ul_SetLuminosity(0)
		user.ul_SetLuminosity(user.luminosity + ZIPPO_LUM)



/obj/item/weapon/zippo/dropped(mob/user)
	if(lit)
		user.ul_SetLuminosity(user.luminosity - ZIPPO_LUM)
		src.ul_SetLuminosity(ZIPPO_LUM)