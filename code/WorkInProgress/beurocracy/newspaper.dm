// CONTAINS:
// the newpaper item

/obj/item/weapon/newspaper
	name = "Newspaper"
	icon = 'beurocracy.dmi'
	icon_state = "newspaper"
	throwforce = 0.2
	w_class = 1.0
	throw_speed = 3
	throw_range = 15

	var/see_face = 1
	var/body_parts_covered = HEAD
	var/protective_temperature = T0C + 10
	var/heat_transfer_coefficient = 0.99
	var/gas_transfer_coefficient = 1
	var/permeability_coefficient = 0.99
	var/siemens_coefficient = 0.80

	var/list/pages
	var/current_page = 1

/obj/item/weapon/newspaper/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/item/weapon/newspaper/attack_ai(var/mob/living/silicon/ai/user as mob)
	if(!pages || pages.len == 0)
		usr << "The newspaper is blank."
		return

	if (get_dist(src, user.current) < 2)
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[][]</TT></BODY></HTML>", src.name, pages[current_page], generate_navbar()), "window=newspaper")
		onclose(usr, "newspaper")
	else
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[][]</TT></BODY></HTML>", src.name, Ellipsis(pages[current_page]), generate_navbar()), "window=newspaper")
		onclose(usr, "newspaper")
	return

/obj/item/weapon/newspaper/attack_hand(user as mob)
	..()
	examine()

/obj/item/weapon/newspaper/proc/generate_navbar()
	var/T = "<div style='padding:1em'>"

	if(current_page > 1)
		T += "<div style='float:left'><a href='<A href='?src=\ref[src];back=1'>Back</a>"

	if(current_page < pages.len)
		T += "<div style='float:left'><a href='<A href='?src=\ref[src];next=1'>Next</a>"

	T += "<div>[num2text(current_page)] / [num2text(pages.len)]</div></div>"
	return T

/obj/item/weapon/newspaper/examine()
	set src in view()
	..()

	if(!pages || pages.len == 0)
		usr << "The newspaper is blank."
		return

	if (!( istype(usr, /mob/living/carbon/human) || istype(usr, /mob/dead) || istype(usr, /mob/living/silicon) ))
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[][]</TT></BODY></HTML>", src.name, Ellipsis(pages[current_page]), generate_navbar()), "window=newspaper")
		onclose(usr, "newspaper")
	else
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[][]</TT></BODY></HTML>", src.name, pages[current_page], generate_navbar()), "window=newspaper")
		onclose(usr, "newspaper")
	return
