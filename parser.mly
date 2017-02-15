%{
(* --- pr�ambule: ici du code Caml --- *)

open Expr   (* rappel: dans expr.ml: 
             type expr = Const of int | Add of expr*expr | Mull of expr*expr *)

%}
/* description des lex�mes, ceux-ci sont d�crits (par vous) dans lexer.mll */

%token <int> INT       /* le lex�me INT a un attribut entier */                
%token CONJ DISJ XOR IMPL EQUIV NOT VNOT
%token LPAREN RPAREN
%token EOL             /* retour � la ligne */

%left EQUIV                            
%left IMPL
%left XOR
%left DISJ
%left CONJ
  /* associativit� gauche: a+b+c, c'est (a+b)+c */
%nonassoc VNOT
%nonassoc NOT  /* un "faux token", correspondant au "-" unaire */

%start main             /* "start" signale le point d'entr�e: */
                        /* c'est ici main, qui est d�fini plus bas */
%type <Expr.expr> main     /* on _doit_ donner le type associ� au point d'entr�e */

%%
    /* --- d�but des r�gles de grammaire --- */
                            /* � droite, les valeurs associ�es */


main:                       /* <- le point d'entr�e (cf. + haut, "start") */
    expr EOL                { $1 }  /* on veut reconna�tre un "expr" */
;
expr:			    /* r�gles de grammaire pour les expressions */
  | INT                     { Const $1 }
  | LPAREN expr RPAREN      { $2 } /* on r�cup�re le deuxi�me �l�ment */
  | expr CONJ expr          { Conj($1,$3) }
  | expr DISJ expr          { Disj($1,$3) }
  | expr XOR expr           { Xor($1,$3) }
  | expr EQUIV expr         { Equiv($1,$3) }
  | expr IMPL expr          { Impl($1,$3) }
  | NOT expr %prec NOT      { Not($2) }
  | VNOT INT                { Not(Const $2) }
;

