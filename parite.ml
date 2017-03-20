
(* fonction qui prend en entrée un entier et fait un gros xor sur le nombre en argument *)

let parite n =
  let file = open_out "test/parite.form" in
  output_string file  "~(";
  let rec aux i = match i with
    | 1 -> output_string file ((string_of_int n) ^ ") 0")
    | _ -> begin
        output_string file ((string_of_int (n - i + 1)) ^ " X ");
        aux (i - 1)
      end
  in
  aux n;
  close_out file;;
    
let _ =
  try
    parite (int_of_string Sys.argv.(1));
    print_string "Le fichier test/parite.form a ete cree.\n"
  with
    _ -> print_string "Erreur d'argument. L'argument donne doit etre un nombre.\n"
      
