module Python = Py.Make(struct
    let lib = "python3.5"
end)

open Python

let py_test_int t =
    Test.check t "Python int to OCaml int" (fun () -> !$(Int 99999) |> Object.to_int) 99999;
    Test.check t "Python int to OCaml string" (fun () -> !$(Int 123) |> Object.to_string) "123"

let py_test_string t =
    Test.check t "Python string to OCaml string" (fun () -> !$(String "testing abc 123") |> Object.to_string) "testing abc 123"

let py_test_list t =
    let l = !$(List [Int 1; Int 2; Int 3]) in
    let l' =  Object.list Object.to_int l in
    List.iteri (fun i x ->
        Test.check t "Python check list" (fun () -> x) (i + 1)) l'

let py_test_tuple t =
    let l = !$(Tuple [| Int 1; Int 2; Int 3 |]) in
    let l' = Object.list Object.to_int l in
    List.iteri (fun i x ->
        Test.check t "Python check tuple" (fun () -> x) (i + 1)) l'

let py_test_dict_data = [| "a"; "b"; "c" |]

let py_test_dict t =
    let d = !$(Dict [
        String "a", Int 1;
        String "b", Int 2;
        String "c", Int 3;
    ]) in
    let d' = Object.items Object.to_string Object.to_int d in
    let d' = List.sort (fun (k, v) (k', v') -> compare v v') d' in
    List.iteri (fun i (k, v) ->
        Test.check t
        "Python check dict"
        (fun () -> k, v)
        (py_test_dict_data.(i), i + 1)) d'


let simple = [
    py_test_int;
    py_test_string;
    py_test_list;
    py_test_tuple;
    py_test_dict;
]

let _ =
    let t = Test.start () in
    let () = Test.all t simple in
    Test.finish t
