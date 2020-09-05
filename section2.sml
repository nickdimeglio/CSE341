(* PL Section 2 Notes *)


(* Data Types *)

exception ListLengthMismatch

datatype mytype = TwoInts of int * int
       | Str of string
       | Pizza


datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Ace | King | Queen | Jack | Num of int

type card = suit * rank 


(* card -> string *)

fun stamp_duty(c: card) = 
    if #1 c = Spades andalso #2 c = Ace
    then "Pay up" else "Carry on"

fun sum_list xs =
    case xs of
	[] => 0
     | x::xs' => x + sum_list xs'

fun append (xs, ys) =
    case xs of
	[] => ys
      | x::xs' => x :: append(xs', ys) 

fun zip (xs) =
    case xs of
	([], [], []) => []
      | (a::ls1, b::ls2, c::ls3) => (a, b, c)::zip(ls1, ls2, ls3)
      | _  => raise ListLengthMismatch

fun unzip (xs) =
    case xs of
	[] => ([], [], [])
     |  (a, b, c)::xs' =>  let val (l1, l2, l3) = unzip(xs')
			   in 
			       (a::l1, b::l2, c::l3) 
			   end


