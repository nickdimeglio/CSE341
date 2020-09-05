(* Homework 1 *)

fun is_older (date1:int*int*int, date2:int*int*int) = 
    (* multiply each date part by the max of the next part *)
    let val d1val = (#1 date1 * 403) + (#2 date1 * 31) + #3 date1
	val d2val = (#1 date2 * 403) + (#2 date2 * 31) + #3 date2
    in  d1val < d2val end					    


fun number_in_month (ds:(int*int*int) list, m:int) = 
    if null ds then 0 else
    if #2 (hd ds) = m 
    then 1 + number_in_month(tl ds, m)
    else     number_in_month(tl ds, m)


fun number_in_months (ds:(int*int*int) list, ms:int list) = 
    if null ms orelse null ds then 0
    else number_in_month(ds, hd ms) + number_in_months(ds, tl ms)


fun dates_in_month (ds:(int*int*int) list, m:int) = 
    if null ds then [] else
    if #2 (hd ds) = m 
    then (hd ds)::dates_in_month(tl ds, m)
    else dates_in_month(tl ds, m)
							  

fun dates_in_months (ds:(int*int*int) list, ms:int list) = 
    if null ms orelse null ds then []
    else dates_in_month(ds, hd ms)::dates_in_months(ds, tl ms)


fun get_nth (strings: string list, n: int) =
    if n = 1 then hd strings
    else get_nth(tl strings, n - 1)


fun date_to_string (d: int*int*int) =
    let val months = ["January", "February", "March", "April", "May", "June", "July", "August", 
		      "September", "October", "November", "December"]
    in get_nth(months, #2 d) ^ " " ^ Int.toString(#3 d) ^ ", " ^ Int.toString(#1 d) end


fun number_before_reaching_sum (sum: int, ns: int list) =
    let fun  next_sum(s, p, rest) =
	if s + (hd rest) >= sum then p
	else next_sum(s + (hd rest), p + 1, tl rest) 
    in next_sum(0, 0, ns) end


fun what_month (d: int) =
    let val months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in number_before_reaching_sum(d, months) + 1 end


fun month_range (d1: int, d2: int) =
    if d2 < d1 then [] else
    let fun  add_next_day(cd: int) =
	     if cd = d2 then [what_month(cd)]@[]
	     else [what_month(cd)]@add_next_day(cd + 1) 
    in add_next_day(d1) end


fun oldest (ds:(int*int*int) list) = 
    if null ds then NONE else
    let fun checkrest(dates) =
	    if null (tl dates) then (hd dates) else
	    if is_older(hd (tl dates), hd dates) then checkrest(tl dates)
	    else checkrest (hd dates::(tl (tl dates)))	    
    in
	SOME(checkrest(ds))
    end
