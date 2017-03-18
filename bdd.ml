open Expr

type tree = Leaf of bool
	  | Node of int*tree*tree
			       
type exprif = Var of int
	    | If of exprif*exprif*exprif
	    | Zero
	    | Un


(* Fonctions nécessaire pour la première structure de donnée appelée T pour faire le partage *)
let initt t =
  let n = Array.length t in
  begin
    for i=0 to n-1 do
      t.(i)<-Leaf (false);
    done;
    t.(1)<-Leaf (true);
  end

let add t node =
  let i = ref 1 in
  begin
    while t.(!i) != Leaf (false) do
      i:= (!i+1);
    done;
    t.(!i)<-node;
    !i;
  end

let var t u =
  match t.(u) with
    Node (i,l,h) -> i
  | _ -> failwith("error")

		 
let low t u =
  match t.(u) with
    Node (i,l,h) -> l
  | _ -> failwith("error")

		 
let high t u =
  match t.(u) with
    Node (i,l,h) -> h
  | _ -> failwith("error")
(* Fin de ces fonctions *)		 
		

(* Fonctions pour la seconde structure de donnée appelée H nécessaire pour faire le partage *)
let inith h =
  Hashtbl.reset h

let member h node =
  Hashtbl.mem h node

let lookup h node =
  Hashtbl.find h node

let insert h node u =
  Hashtbl.replace h node u
(* Fin de ces fonctions *)

		  
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

let mk i v0 v1 t h =
  if v0=v1 then v0
  else
    if member h (Node(i,v0,v1)) then t.(lookup h (Node(i,v0,v1)))
    else let u = add t (Node(i,v0,v1)) in
	 begin
	   insert h (Node(i,v0,v1)) u;
	   Node(i,v0,v1);
	 end
	   
	   
(*Fonction auxiliaire pour construire le BDD : l'exploration est abandonnée plus tôt si la simplification renvoie Zero ou Un : il n'y a plus rien à explorer !*)
let rec construire_bdd_aux e i t h =
  match e with
    Zero -> Leaf (false)
  | Un -> Leaf (true)
  | _ -> let v0 = construire_bdd_aux (simpl (fixer e i Zero)) (i+1) t h and v1 = construire_bdd_aux (simpl (fixer e i Un)) (i+1) t h in
	 (mk i v0 v1 t h)

(*On appelle juste sur la première variable.*)
let construire_bdd e taille =
  let t = Array.make taille (Leaf false) and h = Hashtbl.create taille in
  begin
    initt t;
    inith h;
    construire_bdd_aux (transfo e) 1 t h;
  end


let split s =
  let n = String.length s
  and res = ref []
  and pred = ref 0
  and i = ref 0
  and space = (String.get " " 0) in
  begin
    while !i<n do
      if s.[!i] = space then
	begin
	  res:= !res@[String.sub s !pred (!i - !pred)];
	  i:= !i+1;
	  pred := !i;
	end
      else
	i:= !i+1
    done;
    !res
  end

let extraire ls =
  match ls with
    [] -> failwith("ARGH : Pas assez de variables dans minisat !")
  | t::q -> let n = int_of_string t in
	    begin
	      if n<0 then (-n, false, q)
	      else (n, true, q)
	    end
	    
	   
let rec verif_sat_aux t n bool ls =
  match t with
    Leaf (true) -> print_string "OK\n"
  | Leaf (false) -> print_string "ARGH : Le ROBDD dit que minisat est un menteur !\n"
  | Node (i, fg, fd) when (i=n && bool) -> let (np,boolp,lsp)=extraire ls in
					   verif_sat_aux fd np boolp lsp
  | Node (i, fg, fd) when (i=n && bool=false) -> let (np,boolp,lsp)=extraire ls in
						 verif_sat_aux fg np boolp lsp
  | Node (i, fg, fd) when (i>n) -> let(np,boolp,lsp)=extraire ls in
				   verif_sat_aux t np boolp lsp
  | _ -> failwith("ARGH : error while reading the robdd\n")
    
let verif_sat t s =
  let sp = split s in
  let (n,bool,ls)=extraire sp in
  verif_sat_aux t n bool ls


(* Pour vérifer que ce n'est pas satisfiable, on descend jusqu'aux feuilles : s'il y en a une qui vaut Vrai alors on a un problème ! *)
let rec verif_unsat_aux t =
  match t with
    Leaf (true) -> false
  | Leaf (false) -> true
  | Node (n,fg,fd) -> (verif_unsat_aux fg) && (verif_unsat_aux fd)
	       
let verif_unsat t =
  let bool = verif_unsat_aux t in
  match bool with
    false -> print_string "ARGH\n"
  | true -> print_string "OK\n"
