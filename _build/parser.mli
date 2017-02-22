type token =
  | INT of (int)
  | CONJ
  | DISJ
  | XOR
  | IMPL
  | EQUIV
  | NOT
  | VNOT
  | LPAREN
  | RPAREN
  | EOL

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Expr.expr
