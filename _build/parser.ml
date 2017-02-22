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

open Parsing;;
let _ = parse_error;;
# 2 "parser.mly"
(* --- préambule: ici du code Caml --- *)

open Expr   (* rappel: dans expr.ml: 
            type expr = Const of int | Conj of expr*expr | Disj of expr*expr | Xor of expr*expr | Impl of expr*expr | Equiv of expr*expr | Not of expr *)

# 23 "parser.ml"
let yytransl_const = [|
  258 (* CONJ *);
  259 (* DISJ *);
  260 (* XOR *);
  261 (* IMPL *);
  262 (* EQUIV *);
  263 (* NOT *);
  264 (* VNOT *);
  265 (* LPAREN *);
  266 (* RPAREN *);
  267 (* EOL *);
    0|]

let yytransl_block = [|
  257 (* INT *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\002\000\002\000\000\000"

let yylen = "\002\000\
\002\000\001\000\003\000\003\000\003\000\003\000\003\000\003\000\
\002\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\002\000\000\000\000\000\000\000\011\000\000\000\
\009\000\010\000\000\000\000\000\000\000\000\000\000\000\000\000\
\001\000\003\000\004\000\000\000\000\000\000\000\000\000"

let yydgoto = "\002\000\
\007\000\008\000"

let yysindex = "\006\000\
\035\255\000\000\000\000\035\255\036\255\035\255\000\000\011\255\
\000\000\000\000\021\255\035\255\035\255\035\255\035\255\035\255\
\000\000\000\000\000\000\039\255\001\255\026\255\016\255"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\029\255\041\255\043\255\251\254"

let yygindex = "\000\000\
\000\000\252\255"

let yytablesize = 54
let yytable = "\009\000\
\007\000\011\000\012\000\013\000\007\000\007\000\001\000\019\000\
\020\000\021\000\022\000\023\000\012\000\013\000\014\000\015\000\
\016\000\012\000\013\000\014\000\015\000\017\000\012\000\013\000\
\014\000\015\000\016\000\012\000\013\000\014\000\018\000\005\000\
\005\000\005\000\005\000\003\000\010\000\000\000\005\000\005\000\
\012\000\004\000\005\000\006\000\006\000\006\000\006\000\008\000\
\008\000\000\000\006\000\006\000\008\000\008\000"

let yycheck = "\004\000\
\006\001\006\000\002\001\003\001\010\001\011\001\001\000\012\000\
\013\000\014\000\015\000\016\000\002\001\003\001\004\001\005\001\
\006\001\002\001\003\001\004\001\005\001\011\001\002\001\003\001\
\004\001\005\001\006\001\002\001\003\001\004\001\010\001\003\001\
\004\001\005\001\006\001\001\001\001\001\255\255\010\001\011\001\
\002\001\007\001\008\001\009\001\004\001\005\001\006\001\005\001\
\006\001\255\255\010\001\011\001\010\001\011\001"

let yynames_const = "\
  CONJ\000\
  DISJ\000\
  XOR\000\
  IMPL\000\
  EQUIV\000\
  NOT\000\
  VNOT\000\
  LPAREN\000\
  RPAREN\000\
  EOL\000\
  "

let yynames_block = "\
  INT\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 34 "parser.mly"
                            ( _1 )
# 113 "parser.ml"
               : Expr.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 37 "parser.mly"
                            ( Const _1 )
# 120 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 38 "parser.mly"
                            ( _2 )
# 127 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 39 "parser.mly"
                            ( Conj(_1,_3) )
# 135 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 40 "parser.mly"
                            ( Disj(_1,_3) )
# 143 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 41 "parser.mly"
                            ( Xor(_1,_3) )
# 151 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 42 "parser.mly"
                            ( Equiv(_1,_3) )
# 159 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 43 "parser.mly"
                            ( Impl(_1,_3) )
# 167 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 44 "parser.mly"
                            ( Not(_2) )
# 174 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 45 "parser.mly"
                            ( Not(Const _2) )
# 181 "parser.ml"
               : 'expr))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Expr.expr)
