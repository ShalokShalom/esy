let readFile (path : Path.t) =
  let open RunAsync.Syntax in
  let path = Path.to_string path in
  try%lwt (
    let%lwt ic = Lwt_io.open_file ~mode:Lwt_io.Input path in
    let%lwt data = Lwt_io.read ic in
    return data
  ) with Unix.Unix_error (_, _, _) ->
    let msg = Printf.sprintf "Unable to read file: %s" path in
    error msg

let readJsonFile (path : Path.t) =
  let open RunAsync.Syntax in
  let%bind data = readFile path in
  return (Yojson.Safe.from_string data)

let exists (path : Path.t) =
  let path = Path.to_string path in
  let%lwt exists = Lwt_unix.file_exists path in
  RunAsync.return exists
