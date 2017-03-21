type expr =
    Const of int
  | Conj of expr*expr
  | Disj of expr*expr
  | Xor of expr*expr
  | Impl of expr*expr
  | Equiv of expr*expr
  | Not of expr


let ecrire exp= 
  let file = open_out "test/alea.form" in
  let rec affiche_expr e =
    
    let aff_aux s a b = 
      begin
	output_string file "(";
	affiche_expr a;
	output_string file s;
	affiche_expr b;
	output_string file ")"
      end
    in
    let aff_not a =
      begin
      output_string file "~(";
      affiche_expr a;
      output_string file ")"
      end
    in
    match e with
    | Const k -> output_string file (string_of_int k)
    | Conj(e1,e2) -> aff_aux " /\\ " e1 e2
    | Disj(e1,e2) -> aff_aux " \\/ " e1 e2
    | Xor(e1,e2) -> aff_aux " X " e1 e2
    | Impl(e1,e2) -> aff_aux " => " e1 e2
    | Equiv(e1,e2) -> aff_aux " <=> " e1 e2
    | Not(e1) -> aff_not e1
  in
  affiche_expr exp;
  output_string file " 0\n";
  close_out file


let alea n = Random.self_init ();
  let rec creer_formule i = match i with
    |  0 -> Const ((Random.int (2*n)) + 1)
    | _ -> begin 
	let a = Random.int 4 in 
	match a with
	| 0 -> Conj(creer_formule (i-1), creer_formule (i-1))
	| 1 -> Disj(creer_formule (i-1), creer_formule (i-1))
	| 2 -> Xor(creer_formule (i-1), creer_formule (i-1))
	| 3 -> Not(creer_formule (i-1))
        | _ -> failwith "impossible case\n"
      end
  in
  ecrire (creer_formule n)
             
                         


let _ =
  try
    alea (int_of_string Sys.argv.(1));
    print_string "Le fichier test/alea.form a ete cree.\n"
  with
    _ -> print_string "Erreur d'argument. L'argument donne doit etre un nombre.\n"
    
