(* addition à n bits sans retenue *)
let addition n =
  let fichier = open_out "test/addition.form" in
  for i = 0 to (n-1) do
    output_string fichier ((string_of_int (3*i+1)) ^ " X " ^ (string_of_int (3*i+2)) ^ " <=> " ^ (string_of_int (3*i + 3)));
    if i <> (n-1) then
      output_string fichier " /\\ "
    else
      ()
  done;
  output_string fichier " 0\n";
  close_out fichier

let _ =
  try
    addition (int_of_string Sys.argv.(1));
    print_string "Le fichier test/addition.form a ete cree.\n"
  with
    _ -> print_string "Erreur d'argument. L'argument donne doit etre un nombre.\n"
      
