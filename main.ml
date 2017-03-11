open Expr
open Bdd
open Tseitin
open Dimacs
       

let compile e =
  begin
    affiche_expr e;
    print_newline();
    afficher_bdd (construire_bdd e 100);
    print_newline()
  end

(* stdin désigne l'entrée standard (le clavier) *)
(* lexbuf est le Lexing depuis un string *)

let lexbuf c = Lexing.from_channel c

(* on enchaîne les tuyaux: lexbuf est passé à Lexer.token,
   et le résultat est donné à Parser.main *)

let parse c = Parser.main Lexer.token (lexbuf c)

(* la fonction que l'on lance ci-dessous *)
let calc () =
  try
    let c = open_in Sys.argv.(1) in begin
    (* On envoie en argument un channel sur le fichier passé en argument qui doit donc contenir la formule à parser *)
      let result = parse c in
      (* Expr.affiche_expr result; print_newline (); flush stdout *)
	compile result; close_in c; end
  with _ -> (print_string "erreur de saisie\n")
;;

let calc2 () =
  (* Travail de Guillaume*)
  let nom = Sys.argv.(2) in
  let nom_fichier = String.sub nom 0 (String.index nom '.') in
  let c = open_in Sys.argv.(2) in
  let result = parse c in
  close_in c;
  let formule, i = tseitin result in
  cnf_to_dimacs formule i nom_fichier;
  print_string ("Le fichier " ^ nom_fichier ^ ".cnf a été créé \n")
;;
  
let calc3 () =
  try
    (* On parse, on construit le BDD et Tseitin pour appeler minisat dessus *)
    let c = open_in Sys.argv.(2) in
    begin
      let result = parse c in
      let t = construire_bdd result 100 in
      (*Insérer Fonction pour créer Tseitin et stocker dans un fichier*)
      let sortie_sat = "/tmp/output.txt" and minisat_command = "minisat /tmp/pb.cnf /tmp/output.txt" and res = ref 0 in
      begin 
	res := Sys.command minisat_command;
	res := Sys.command "rm /tmp/pb.cnf";
	let c = open_in sortie_sat in
	begin
	  let s = input_line c in
	  begin
	    match s with
	      "SAT" -> verif_sat t (input_line c)
	    | "UNSAT" -> verif_unsat t
	    | _ -> failwith("error")
	  end;
	  close_in c;
	end;
	 res:= Sys.command "rm /tmp/output.txt"
      end;
      close_in c;
    end
  with _ -> (print_string "erreur de saisie\n")
;;


let calc4() =
  try
    (* On parse, on construit le BDD et Tseitin pour appeler minisat dessus *)
    let c = open_in Sys.argv.(4) in
    begin
      let result = parse c in
      let t = construire_bdd result 100 in
      (*Insérer Fonction pour créer Tseitin et stocker dans un fichier*)
      let sortie_sat = "/tmp/output.txt" and minisat_command = "minisat "^Sys.argv.(3)^" /tmp/output.txt" and res = ref 0 in
      begin 
	res := Sys.command minisat_command;
	let c = open_in sortie_sat in
	begin
	  let s = input_line c in
	  begin
	    match s with
	      "SAT" -> verif_sat t (input_line c)
	    | "UNSAT" -> verif_unsat t
	    | _ -> failwith("error")
	  end;
	  close_in c;
	end;
	 res:= Sys.command "rm /tmp/output.txt"
      end;
      close_in c;
    end
  with _ -> (print_string "erreur de saisie\n")
;;
  
let _ =
  match Sys.argv.(1) with
    "-minisat" -> begin
		 match Sys.argv.(2) with
		   "-tseitin" -> calc4()
		 | _ -> calc3()
	       end
  | "-tseitin" -> calc2()
  | _ -> calc()
