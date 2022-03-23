open Postgresql

let pg_url = "postgresql://main:main@localhost:5432/main"

let create_query = "create table if not exists temp (a int, b json)"

let insert_query = "insert into temp(a,b) values ($1,$2)"


let param_int = 42
let param_json = {|{"key1":1234,"key2":"thing_opg"}|}


    

let main = 
    let db = new connection ~conninfo: pg_url () in
    let _ = db#set_notice_processing `Stderr in
    let query_name = "test_insert" in
    let param_types = [|oid_of_ftype INT4; oid_of_ftype JSON|] in 
    let res1 = db#prepare query_name insert_query ~param_types:param_types in
    let () = print_endline res1#error in
    let res2 = db#exec_prepared query_name ~params:[|string_of_int param_int;param_json|] in
    let () = print_endline res2#error in
    db#finish 

let () =  
     main 
