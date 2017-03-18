open Expr

       
       (* liste des variables utilisée dans l'expression *)
let liste_var expr =
  let l = ref [] in
  let rec aux expr =
    match expr with
    | Const (x) -> l := x :: !l
    | Conj (exp1,exp2) -> aux exp1 ; aux exp2
    | Disj (exp1, exp2) -> aux exp1 ; aux exp2
    | Xor (exp1, exp2) -> aux exp1 ; aux exp2
    | Impl (exp1, exp2) -> aux exp1 ; aux exp2
    | Equiv (exp1, exp2) -> aux exp1 ; aux exp2
    | Not (exp) -> aux exp
  in
  aux expr;
  !l

(* fonction pour transformer l'expression pour enlever les implications et les équivalences *)
let rec transform_expr expr =
  match expr with
  | Const (x) -> Const x
  | Conj (exp1, exp2) -> Conj ((transform_expr exp1), (transform_expr exp2))
  | Disj (exp1, exp2) -> Disj ((transform_expr exp1), (transform_expr exp2))
  | Xor (exp1, exp2) -> begin
      let exp1t = transform_expr exp1 in
      let exp2t = transform_expr exp2 in
      Disj ((Conj (exp1t, (Not (exp2t)))), (Conj ((Not exp1t), exp2t)))
    end     
  | Impl (exp1, exp2) -> begin
      let exp1t = transform_expr exp1 in
      let exp2t = transform_expr exp2 in
      Disj ((Not exp1t), exp2t)
    end
  | Equiv (exp1, exp2) ->
     transform_expr (Conj(Impl(exp1, exp2), Impl(exp1, exp2)))
  | Not(exp) -> Not(transform_expr (exp))

let maxi tab =
  let rec aux t m =
    match t with
    | [] -> m
    | tete :: queue -> aux queue (max tete m)
  in
  aux tab (List.hd tab)

(* La fameuse transformation de Tseitin qui prend une expression 
et retourne une autre en CNF *)

(* Il y a une erreur comme quoi le pattern n'est pas exhautif. Mais on a pris  soin de retirer justement les cas qui ne sont pas traité dans le match donc tout est bon *)
let rec tseitin expr =
  (* numéro de la variable à choisir pour créer une nouvelle variable dans les formueles *)
  let i = ref ((maxi (liste_var expr)) + 1)  in
  (*On  fait les transformations données dans les diapos *)
  let formule = ref [Const(!i)] in
  let rec transform_sous_formule p varp =
    match p with
    | Const(x) -> formule :=  Disj(Not(Const(varp)), Const(x)) :: Disj(Const(varp), Not(Const(x))) :: !formule
    | Not(p1) ->
       begin
         i := !i + 1;
         formule := Disj(Not(Const(varp)),Not(Const(!i))) :: Disj(Const(varp), Const(!i)) :: !formule;
         transform_sous_formule p1 !i
       end
    | Disj(p1,p2) ->
       begin
         i := !i + 2;
         formule := Disj(Not(Const(varp)), Disj(Const(!i - 1), Const(!i))) :: Disj(Const(varp), Not(Const(!i-1))) :: Disj(Const(varp), Not(Const(!i))) :: ! formule;
         transform_sous_formule p1 (!i - 1);
         transform_sous_formule p2 !i
       end
    | Conj(p1,p2) ->
       begin
         i := !i + 2;
         formule := Disj(Not(Const(varp)), Const(!i - 1)) :: Disj(Not(Const(varp)), Const(!i)) :: Disj(Const(varp), Disj(Not(Const(!i - 1)), Not(Const(!i)))) :: !formule;
         transform_sous_formule p1 (!i - 1);
         transform_sous_formule p2 !i
       end
  in
  transform_sous_formule (transform_expr expr) !i;
  (*let rec reduit l = match l with
    | x1 :: x2 :: [] -> Conj(x1, x2)
    | t :: q -> Conj(t, reduit(q))
  in
  reduit !formule*)
  (!formule, !i)

let tseitin_bdd expr =
  let result, i = tseitin expr in
  let rec reduit = function
    | x1 :: x2 :: [] -> Conj(x1, x2)
    | t :: q -> Conj(t, reduit(q))
  in
  reduit result
