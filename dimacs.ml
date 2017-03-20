open Expr

(* Prend une expression CNF et la convertit en un format dimacs *)
let cnf_to_dimacs expr i fichier =       
  let file = open_out (fichier ^ ".cnf") in
  output_string file ("p cnf "^ (string_of_int i) ^ " " ^ (string_of_int (List.length expr)) ^ "\n");
  let rec ecrire_clause = function
    | Disj(x, y) -> ecrire_clause x; ecrire_clause y
    | Const(x) -> output_string file (string_of_int x ^ " ")
    | Not(Const(x)) -> output_string file (string_of_int (-x) ^ " ")
    | _ -> failwith "Not in CNF"
  in
  let rec ecrire = function
    | [] -> ()
    | t :: q -> ecrire_clause t; output_string file "0 \n"; ecrire q
  in
  ecrire expr; close_out file;;
