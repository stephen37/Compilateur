{

  open Lexing
  open Parser
  open Ast
  open Error

  (* Petite fonction utile pour la localisation des erreurs. *)
  let current_pos b =
    lexeme_start_p b,
    lexeme_end_p b

}



rule token = parse
  (* Le retour à la ligne est traité à part pour aider la localisation. *)
  | '\n'
      { new_line lexbuf; token lexbuf }
      
  (* Cadeau : la fonction print_newline et la constante unité. *)
  | "print_newline"
      { PRINT_NEWLINE }
  | "()"
      { CONST_UNIT }
  | " "
      { token lexbuf }
  | ['0'-'9']+ as const
      { CONST_INT (int_of_string (const))  }
  | "print_int"
      { PRINT_INT }
  | ";;"
      { EOI }


  | "+"
      { PLUS }
  | "-"
      { MINUS }
  | "/"
      { SLASH }
  | "*"
      { STAR }

  | "(*"
      { comment lexbuf }
      
  | "("
      { LPAREN }
  | ")"
      { RPAREN }
  (* À compléter. Il faut gérer :
     x les blancs
     x les constantes
     x les noms "print_int" et "print_newline"
     - les symboles
     - les commentaires *)

      
  (* Les autres caractères sont des erreurs lexicales. *)
  | _
      { error (Lexical_error (lexeme lexbuf)) (current_pos lexbuf) }
  (* Fin du fichier. *)
  | eof
      { EOF }


 and comment = parse
    | "*)" { token lexbuf }
    | _ { comment lexbuf }
    | eof { failwith "Commentaire non termine" }
