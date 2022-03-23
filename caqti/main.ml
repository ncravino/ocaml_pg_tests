
let pg_url = "postgresql://root:rootn@localhost:5432/main"

let create_query = "create table if not exists temp (a int, b json)"

let insert_query = "insert into temp(a,b) values (?,?)"

let createtemp (module Db : Caqti_lwt.CONNECTION) = 
    let q = Caqti_request.exec Caqti_type.unit create_query in
    Db.exec q () 

let testinsert (module Db : Caqti_lwt.CONNECTION) p_int p_json=
    let q = Caqti_request.exec (Caqti_type.(tup2 int string)) insert_query in
    Db.exec q (p_int,p_json) 


let param_int = 42
let param_json = {|{"key1":1234,"key2":"thing"}|}

let main = 
    let%lwt _ = Caqti_lwt.with_connection (Uri.of_string pg_url) createtemp in
    let insert_q db = testinsert db param_int param_json in
    let%lwt res = Caqti_lwt.with_connection (Uri.of_string pg_url) insert_q
    in Caqti_lwt.or_fail res

let () =  
    Lwt_main.run main 
