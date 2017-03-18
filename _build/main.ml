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

(* stdin d�signe l'entr�e standard (le clavier) *)
(* lexbuf est le Lexing depuis un string *)

let lexbuf c = Lexing.from_channel c

(* on encha�ne les tuyaux: lexbuf est pass� � Lexer.token,
   et le r�sultat est donn� � Parser.main *)

let parse c = Parser.main Lexer.token (lexbuf c)

(* Appel de la fonction sans en option *)
let calc () =
  try
    let c = open_in Sys.argv.(1) in begin
    (* On envoie en argument un channel sur le fichier pass� en argument qui doit donc contenir la formule � parser *)
      let result = parse c in
      (* Expr.affiche_expr result; print_newline (); flush stdout *)
	compile result; close_in c; end
  with _ -> (print_string "erreur de saisie\n")
;;

let opt_tseitin (nom) =
  (* Transformation au format dimacs et stockage dans un fichier : option -tseitin. On prend le nom en option pour pouvoir se resservir de la fonction plus tard *)
  let nom_fichier = String.sub nom 0 (String.index nom '.') in
  let c = open_in Sys.argv.(2) in
  let result = parse c in
  close_in c;
  let formule, i = tseitin result in
  cnf_to_dimacs formule i nom_fichier;
  print_string ("Le fichier " ^ nom_fichier ^ ".cnf a �t� cr�� \n")
;;
  
let opt_minisat () =
  try
    (* On parse, on construit le BDD et Tseitin pour appeler minisat dessus *)
    let c = open_in Sys.argv.(2) in
    begin
      let result = parse c in
      let t = construire_bdd result 100 in
      begin
	(* On cr�e en fait un fichier temporaire sur lequel on pourra appeler minisat *)
	opt_tseitin("/tmp/pb.cnf");
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
      end;
    end
  with | e -> (print_string (Printexc.to_string e))
;;


let opt_tseitin_minisat() =
  try
    (* On parse, on construit le BDD et Tseitin pour appeler minisat dessus *)
    let c = open_in Sys.argv.(4) in
    begin
      let result = parse c in
      let t = construire_bdd result 100 in
      begin
	(* On applique l'option Tseitin qu'on stocke dans le ficihier demand� *)
	opt_tseitin(Sys.argv.(3));
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
      end;
    end
  with _ -> (print_string "erreur de saisie\n")
;;

(* On lit le nb d'arguments pour savoir quelles options a rentr�es l'utilisateur *)
let _ =
  match Sys.argv.(1) with
    "-minisat" -> begin
		 match Sys.argv.(2) with
		   "-tseitin" -> opt_tseitin_minisat()
		 | _ -> opt_minisat()
	       end
  | "-tseitin" -> opt_tseitin(Sys.argv.(2))
  | _ -> calc()
