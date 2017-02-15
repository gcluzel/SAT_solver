open Expr

type tree = Leaf of bool
	  | Node of int*tree*tree
type exprif = Var of int
	    | If of exprif*exprif*exprif
	    | Zero
	    | Un
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
  | If(e1,Un,Zero) -> e1
  | If(e1,e2,e3) -> let e1p=simpl e1 and e3p=simpl e3 and e2p=simpl e2 in begin
		    match (e1p,e2p,e3p) with
		      (_,Zero,Zero) -> Zero
		    | (_,Un,Un) -> Un
		    | (_,Un,Zero)-> e1p
		    | (Un,_,_) -> e2p
		    | (Zero,_,_) -> e3p
		    | _ -> If(simpl e1,e2p,e3p)
						      end
  | If(Zero, e2, e3)-> simpl e3
  | If(Un, e2, e3) -> simpl e2
  | _ -> e

(*Fonction auxiliaire pour construire le BDD : l'exploration est abandonnée plus tôt si la simplification renvoie Zero ou Un : il n'y a plus rien à explorer !*)
let rec construire_bdd_aux e n =
  match e with
    Zero -> Leaf false
  | Un -> Leaf true
  | _ -> Node (n,construire_bdd_aux (simpl (fixer e n Zero)) (n+1),construire_bdd_aux (simpl (fixer e n Un)) (n+1))

(*On appelle juste sur la première variable.*)
let construire_bdd e =
  construire_bdd_aux e 0
