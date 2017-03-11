(* un type pour des expressions booléennes *)
type expr =
    Const of int
  | Conj of expr*expr
  | Disj of expr*expr
  | Xor of expr*expr
  | Impl of expr*expr
  | Equiv of expr*expr
  | Not of expr



(* fonction d'affichage *)
let rec affiche_expr e =
  let aff_aux s a b = 
      begin
	print_string "(";
	affiche_expr a;
	print_string s;
	affiche_expr b;
	print_string ")"
      end
  in
  let aff_not a =
    begin
      print_string "Not(";
      affiche_expr a;
      print_string ")"
    end
  in
  match e with
  | Const k -> print_int k
  | Conj(e1,e2) -> aff_aux "/\\" e1 e2
  | Disj(e1,e2) -> aff_aux "\\/" e1 e2
  | Xor(e1,e2) -> aff_aux "Xor" e1 e2
  | Impl(e1,e2) -> aff_aux "=>" e1 e2
  | Equiv(e1,e2) -> aff_aux "<=>" e1 e2
  | Not(e1) -> aff_not e1

(* sémantique opérationnelle à grands pas *)
let rec eval = function
  | Const k -> true
  | Conj(e1,e2) -> (eval e1) && (eval e2)
  | Disj(e1,e2) -> (eval e1) || (eval e2)
  | Xor(e1,e2) -> (eval e1) <> (eval e2)
  | Impl(e1, e2) -> not (eval e1) && (eval e2)
  | Equiv(e1,e2) -> not ((eval e1) <> (eval e2))
  | Not(e1) -> not (eval e1)

  
