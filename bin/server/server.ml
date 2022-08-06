open Core
open Async

let rec copy_blocks buffer r w =
  match%bind Reader.read r buffer with
  | `Eof -> return ()
  | `Ok bytes_read ->
    print_endline (Bytes.to_string buffer);
    Writer.write
      w
      (Bytes.to_string buffer |> String.uppercase)
      ~len:bytes_read;
    let%bind () = Writer.flushed w in
    copy_blocks buffer r w
;;

let run () =
  let host_and_port =
    Tcp.Server.create
      ~on_handler_error:`Raise
      (Tcp.Where_to_listen.of_port 8765)
      (fun _addr r w ->
        let buffer = Bytes.create (16 * 1024) in
        copy_blocks buffer r w)
  in
  ignore
    (host_and_port : (Socket.Address.Inet.t, int) Tcp.Server.t Deferred.t)
;;

let () =
  run ();
  never_returns (Scheduler.go ())
;;

