(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int 
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)


fun only_capitals strs = List.filter (fn x => Char.isUpper(String.sub(x, 0))) strs

fun longest_string1 strs = 
    foldl (fn (x, y) => if String.size(x) > String.size(y) then x else y) "" strs

fun longest_string2 strs = 
    foldl (fn (x, y) => if String.size(x) >= String.size(y) then x else y) "" strs

fun longest_string_helper comp strs = 
    foldl (fn (x, y) => if (comp(String.size(x), String.size(y))) then x else y) "" strs

fun strictly_larger (x, y) = x > y
fun not_so_strict (x, y) = x >= y

val longest_string3 = fn x => longest_string_helper strictly_larger x
val longest_string4 = fn x => longest_string_helper not_so_strict x

val longest_capitalized = longest_string1 o only_capitals

val rev_string = String.implode o List.rev o String.explode

exception NoAnswer

fun first_answer f xs =
    case xs of
	[] => raise NoAnswer
      | x::xs' => case f(x) of
		      NONE => first_answer f xs'
		    | SOME(i) => i


fun all_answers f xs =
    let fun helper ys acc =
	    case ys of
		[] => SOME(acc)
	      | NONE::ys' => NONE
	      | SOME(y)::ys' => helper ys' (y@acc)
    in
	helper (map f xs) []
    end

val count_wildcards = g (fn x => 1) (fn x => 0)

val count_wild_and_variable_lengths = g (fn x => 1) (fn x => String.size x)

fun count_some_var (str, p) = g (fn x => 0) (fn x => if str = x then 1 else 0) p


fun get_strs p =
    case p of
	Variable x        => [x]
      | TupleP ps         => List.foldl (fn (p,i) => (get_strs p)@i) [] ps
      | ConstructorP(_,p) => get_strs p
      | _                 => []


fun all_distinct strs =
    case strs of
	[] => true
      | s::strs' => (List.all (fn x => x <> s) strs') andalso all_distinct strs'


fun check_pat p =
    let val pstrs = get_strs p
    in all_distinct pstrs end
	

fun match (v, p) =
    case (v, p) of
	(_, Wildcard) => SOME []
      | (v, Variable s) => SOME [(s, v)]
      | (Unit, UnitP) => SOME([])
      | (Const x, ConstP y) => if x = y then SOME [] else NONE
      | (Tuple xs, TupleP ys) => if length xs = length ys then
				     all_answers match (ListPair.zip(xs, ys))
				 else NONE
      | (Constructor (s1, v), ConstructorP (s2, p)) => if s1 = s2 
						       then match(v, p) 
						       else NONE
      | _ => NONE     

fun first_match (v, ps) =
    SOME((first_answer (fn p => match(v, p)) ps))
	handle NoAnswer => NONE
