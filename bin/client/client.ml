let close_connection in_chan =
  Unix.shutdown (Unix.descr_of_in_channel in_chan) Unix.SHUTDOWN_SEND
;;

let main_client client_handler =
  let hostname = "127.0.0.1" in
  let server_addr = (Unix.gethostbyname hostname).Unix.h_addr_list.(0) in
  let port = 8765 in
  let sockaddr = Unix.ADDR_INET (server_addr, port) in
  let in_chan, out_chan = Unix.open_connection sockaddr in
  client_handler in_chan out_chan;
  close_connection in_chan
;;

let say_hey in_chan out_chan =
  try
    output_string out_chan ("hey" ^ "\n");
    flush out_chan;
    let r = input_line in_chan in
    Printf.printf "Response: %s\n\n" r;
    flush stdout;
    if r = "END"
    then (
      close_connection in_chan;
      raise Exit)
  with
  | Exit -> exit 0
  | e ->
    close_connection in_chan;
    (match e with
    | Sys_blocked_io ->
      Printf.eprintf "Timeout...\n";
      raise e
    | _ ->
      Printf.eprintf "Fail...\n";
      raise e)
;;


let () = main_client say_hey
