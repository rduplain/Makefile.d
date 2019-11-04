open Cmdliner

let hello who =
  Printf.printf "Hello, %s!\n" who

(* Accept optional positional command-line arg for `who`, default "world". *)
let who_t = Arg.(value & pos 0 string "world" & info [] ~docv:"WHO")
let hello_t = Term.(const hello $ who_t)
let () = Term.exit @@ Term.eval (hello_t, Term.info "hello")
