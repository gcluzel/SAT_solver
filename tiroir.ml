let tiroir n =
  let sortie = ref "(" in
  let rec aux1 p =
    match p with
    | 0 -> sortie:= !sortie ^ ") "
    | _ -> 
       begin
	 sortie := !sortie ^ "(";
	 for t = 1 to (n-1) do
	   sortie := !sortie ^ string_of_int ((n+1)*(p-1) + t) ^ " \\/ "
	 done;
	 sortie := !sortie ^ string_of_int ((n+1)*(p-1) + n) ^ ")";
         if p <> 1 then (sortie := !sortie ^ " /\\ ") else ();
         aux1 (p-1)
       end
  in
  aux1 (n+1);
  sortie := !sortie ^ "=> (";
  for t = 1 to n do
    sortie := !sortie ^ "(";
    for p = 1 to (n+1) do
      sortie := !sortie ^ "(";
      for q = 1 to (n+1) do
        sortie := !sortie ^ "(" ^ string_of_int ((p-1)*(n+1)+ t) ^ " \\/ " ^ string_of_int ((q-1)*(n+1)+t) ^ ") ";
        if q <> (n+1) then sortie := !sortie ^ "/\\ " else sortie := !sortie ^ ") "
      done;
      if p <> (n+1) then sortie := !sortie ^ "/\\ " else sortie := !sortie ^ ") "
    done;
    if t <> n then sortie := !sortie ^ "/\\ " else sortie := !sortie ^ ") 0"
  done;
  let file = open_out "tiroir.form" in
  output_string file !sortie;
  close_out file
