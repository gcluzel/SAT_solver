(* Correspond à la rotation dans l'énoncer. 
Ce qui correspond en fait à avoir toutes les variables équivalentes *)
let rotation n =
  let fichier = open_out "test/rotation.form" in
  output_string fichier "1";
  for i = 2 to n do
    output_string fichier (" <=> " ^ (string_of_int i))
  done;
  output_string fichier " 0\n";
  close_out fichier

            
let _ =
  try
    parite (int_of_string Sys.argv.(1));
    print_string "Le fichier test/rotation.form a ete cree.\n"
  with
    _ -> print_string "Erreur d'argument. L'argument donne doit etre un nombre.\n"
      
