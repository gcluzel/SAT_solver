open Expr

type tree = Leaf of bool
	  | Node of int*tree*tree
type exprif = Var of int
	    | If of exprif*exprif*exprif
	    | Zero
	    | Un

let rec afficher_bdd arbre =
  match arbre with
    Node (n,a1,a2) -> print_string "("; afficher_bdd a1; print_string " - ";print_int n;print_string " - "; afficher_bdd a2; print_string ")"
  | Leaf true -> print_string "(Vrai)"
  | Leaf false -> print_string "(Faux)"

(*Il faut faire la transformation en forme INF
a = if a then 1 else 0
a/\b = if a then b else 0
a\/b = if a then 1 else b
a xor b = if a then (if b then 0 else 1) else b
not a = if a then 0 else 1
a=>b = if a then b else 1
a<=>b = if a then b else (if b then 0 else 1)*)
(*Transfo e transforme l'expression e pour la mettre sous forme INF*)
		
let rec transfo e =
  match e with
    Const a -> Var a
  | Conj(e1,e2) -> If ((transfo e1),(transfo e2), Zero)
  | Disj(e1,e2) -> If ((transfo e1),Un,(transfo e2))
  | Xor(e1,e2) -> let tmp=transfo e2 in (If ((transfo e1), (If (tmp, Zero, Un)), tmp))
  | Not(e1) -> If ((transfo e1), Zero, Un)
  | Impl(e1,e2) -> If ((transfo e1),(transfo e2),Un)
  | Equiv(e1,e2) -> let tmp = transfo e2 in If ((transfo e1),tmp, (If (tmp, Zero, Un)))

(*Fixer prend un exprif et donne à la variable n soit la valeur Zero soit la valeur Un*)
let rec fixer e n bool =
  match e with
    Var p when n=p -> bool
  | Var p -> Var p
  | If (e1,e2,e3) -> If(fixer e1 n bool,fixer e2 n bool, fixer e3 n bool)
  | Zero -> Zero
  | Un -> Un

(*Simpl reconnait différents cas dans un exprif et le simplifie (par exemple si on a if a then 1 else 1 on peut remplacer tout ça par 1 tout simplement*)
let rec simpl e =
  match e with
    If(e1,Zero, Zero) -> Zero
  | If(e1,Un,Un) -> Un
  | If(e1,Un,Zero) -> simpl e1
  | If(Zero, e2, e3)-> simpl e3
  | If(Un, e2, e3) -> simpl e2
  | If(e1,e2,e3) -> let e1p=simpl e1 and e3p=simpl e3 and e2p=simpl e2 in begin
									 match (e1p,e2p,e3p) with (* Dès qu'on a simplifié e2 et e3 il faut refaire les tests, sinon on risque de rater des simplifications *)
									   (_,Zero,Zero) -> Zero
									 | (_,Un,Un) -> Un
									 | (_,Un,Zero)-> e1p
									 | (Un,_,_) -> e2p
									 | (Zero,_,_) -> e3p
									 | _ -> If(e1p,e2p,e3p)
								       end
  | _ -> e

(*Fonction auxiliaire pour construire le BDD : l'exploration est abandonnée plus tôt si la simplification renvoie Zero ou Un : il n'y a plus rien à explorer !*)
let rec construire_bdd_aux e n =
  match e with
    Zero -> Leaf false
  | Un -> Leaf true
  | _ -> Node (n,construire_bdd_aux (simpl (fixer e n Zero)) (n+1),construire_bdd_aux (simpl (fixer e n Un)) (n+1))

(*On appelle juste sur la première variable.*)
let construire_bdd e =
  construire_bdd_aux (transfo e) 1