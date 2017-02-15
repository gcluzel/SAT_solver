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

let rec transfo e =
  match e with
    Const a -> Var a
  | Conj(e1,e2) -> If ((transfo e1),(transfo e2), Zero)
  | Disj(e1,e2) -> If ((transfo e1),Un,(transfo e2))
  | Xor(e1,e2) -> let tmp=transfo e2 in (If ((transfo e1), (If (tmp, Zero, Un)), tmp))
  | Not(e1) -> If ((transfo e1), Zero, Un)
  | Impl(e1,e2) -> If ((transfo e1),(transfo e2),Un)
  | Equiv(e1,e2) -> let tmp = transfo e2 in If ((transfo e1),tmp, (If (tmp, Zero, Un)))
