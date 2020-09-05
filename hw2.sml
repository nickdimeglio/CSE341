(* Dan Grossman, Coursera PL, HW2 Provided Code *)

datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove


(* Problem 1 *)

fun filter (xs, y) = 
    case xs of
	[] => []
      | x::xs' => if x = y
		  then    filter(xs', y)
		  else x::filter(xs', y)


fun all_except_option (s, strs) =
    let val ans = filter(strs, s)
    in if ans = strs 
       then NONE 
       else SOME(ans) end


fun get_substitutions1 (subs, s) =
    case subs of
	[] => []
      | sub::subs' => case all_except_option(s, sub) of
			  NONE =>     get_substitutions1(subs', s)
		       | SOME i => i@get_substitutions1(subs', s)


fun get_substitutions2 (subs, s) =
    let fun recursive_helper (subs, acc) =
	case subs of
	    [] => acc
	  | sub::subs' => case all_except_option(s, sub) of
			      NONE =>   recursive_helper(subs', acc)
			    | SOME i => recursive_helper(subs', i@acc) 
    in
	recursive_helper(subs, [])
    end


fun similar_names (subs, name) =
    case name of
	{first=x, middle=y, last=z} =>
	let fun modnames (ns) = 
		case ns of
		    [] => []
		 | n::ns' => {first=n, middle=y, last=z}::modnames(ns')
	in
	    name::modnames(get_substitutions1(subs, x))
	end


(* Problem 2 *)

fun card_color (suit, rank) = 
    case suit of
	Clubs    => Black
      | Spades   => Black
      | Diamonds => Red
      | Hearts   => Red


fun card_value (suit, rank) = 
    case rank of
	Ace  => 11 
      | King => 10
      | Queen => 10
      | Jack => 10
      | Num i => i  

fun filter_one (cs, c) = 
    case cs of
	[] => []
      | x::cs' => if x = c
		  then cs'
		  else x::filter_one(cs', c)

fun remove_card (cs, c, e) =
    let val ans = filter_one(cs, c)
    in 
	if ans = cs
	then raise e
	else ans 
    end


fun all_same_color cs =
    case cs of
	[] => true
      | c::[] => true
      | c1::c2::cs' => card_color c1 = card_color c2 andalso all_same_color(c2::cs')	


fun sum_cards cs =
    let fun local_sum (cs, acc) =
	    case cs of
		[] => acc
	      | c::cs' => local_sum(cs', acc + card_value c)
    in
	local_sum(cs, 0)
    end


fun score (cs, goal) =
    let 
	val sum = sum_cards(cs)
	val prelim =
	    if sum > goal 
	    then (sum - goal) * 3 
	    else goal - sum
    in
	if all_same_color cs 
	then prelim div 2 
	else prelim
    end


fun officiate (cards, moves, goal) =
    let fun next_move (helds, cards, moves) =
	case moves of
	    [] => score(helds, goal)
	  | (Discard c)::moves' => next_move(remove_card(helds, c, IllegalMove), cards, moves')
	  | Draw::moves' => case cards of
				[] => score(helds, goal)
			      | c::cards' => if sum_cards(c::helds) > goal
					     then score(c::helds, goal)
					     else next_move(c::helds, cards', moves')	
    in
	next_move([], cards, moves)
    end
