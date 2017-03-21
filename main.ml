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

(* Appel de la fonction sans en option *)
let calc () =
  try
    let c = open_in Sys.argv.(1) in begin
    (* On envoie en argument un channel sur le fichier passé en argument qui doit donc contenir la formule à parser *)
      let result = parse c in
      (* Expr.affiche_expr result; print_newline (); flush stdout *)
	compile result; close_in c; end
  with _ -> (print_string "erreur de saisie\n")
;;

let opt_tseitin nom i =
  (* Transformation au format dimacs et stockage dans un fichier : option -tseitin. On prend le nom en option pour pouvoir se resservir de la fonction plus tard *)
  try
    let nom_fichier = String.sub nom 0 (String.index nom '.') in
    let c = open_in Sys.argv.(i) in
    let result = parse c in
    close_in c;
    let formule, i = tseitin result in
    cnf_to_dimacs formule i nom_fichier;
    (* print_string ("Le fichier " ^ nom_fichier ^ ".cnf a ete cree \n")*)
  with _ -> (print_string "erreur pour l'option -tseitin \n")
;;
  
let opt_minisat () =
  try
    (* On parse, on construit le BDD et Tseitin pour appeler minisat dessus *)
    let c = open_in Sys.argv.(2)
    and cp = open_in "f2bdd.cfg"
    and nom_fichier = String.sub Sys.argv.(2) 0 (String.index Sys.argv.(2) '.') in
    begin
      let result = parse c
      and taille_array = int_of_string (input_line cp) in
      begin
	(* On crée en fait un fichier temporaire sur lequel on pourra appeler minisat *)
	opt_tseitin Sys.argv.(2) 2;
	let sortie_sat = "/tmp/output.txt" and minisat_command = "minisat " ^ nom_fichier ^ ".cnf /tmp/output.txt" and res = ref 0 in
	    begin 
	      res := Sys.command minisat_command;
	      res := Sys.command ("rm " ^ nom_fichier ^ ".cnf");
	      let c = open_in sortie_sat in
	      begin
		let s = input_line c in
		begin
		  match s with
		    "SAT" -> let t = construire_bdd (tseitin_bdd result) taille_array in
			     verif_sat t (input_line c)
		  | "UNSAT" ->      let t = construire_bdd result taille_array in
				    verif_unsat t
		  | _ -> failwith("error in the result file of minisat")
		end;
		close_in c;
		close_in cp;
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
    let c = open_in Sys.argv.(3)
      and nom_fichier = String.sub Sys.argv.(3) 0 (String.index Sys.argv.(3) '.')
      and cp = open_in "f2bdd.cfg" in
    begin
      let result = parse c
      and taille_array = int_of_string (input_line cp) in
      begin
	(* On applique l'option Tseitin qu'on stocke dans le ficihier demandé *)
	opt_tseitin Sys.argv.(3) 3;
	let sortie_sat = "/tmp/output.txt" and minisat_command = "minisat " ^ nom_fichier ^ ".cnf /tmp/output.txt" and res = ref 0 in
	begin 
	  res := Sys.command minisat_command;
	  let c2 = open_in sortie_sat in
	  begin
	    let s = input_line c2 in
	    begin
	      match s with
		"SAT" -> let t = construire_bdd (tseitin_bdd result) taille_array in
			 verif_sat t (input_line c2)
	      | "UNSAT" -> let t = construire_bdd result taille_array in
			   verif_unsat t
	      | _ -> failwith("error in the result file of minisat")
	    end;
	    close_in c2;
	  end;
	  res:= Sys.command "rm /tmp/output.txt"
	end;
	close_in c;
	close_in cp;
      end;
    end
  with e -> (print_string (Printexc.to_string e))
;;

(* On lit le nb d'arguments pour savoir quelles options a rentrées l'utilisateur *)
let _ =
  match Sys.argv.(1) with
    "-minisat" -> begin
		 match Sys.argv.(2) with
		   "-tseitin" -> opt_tseitin_minisat()
		 | _ -> opt_minisat()
	       end
  | "-tseitin" -> begin 
  					opt_tseitin Sys.argv.(2) 2; 
  					print_string "fichier crée\n"
  				  end
  | _ -> calc()
