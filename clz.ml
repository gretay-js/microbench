external int_clz : int -> int = "%clzint"
external int32_clz : int32 -> int = "%int32_clz"
external int64_clz : int64 -> int = "%int64_clz"
external nativeint_clz : nativeint -> int = "%nativeint_clz"

external stub_int_clz : int -> int = "stub_int_clz" [@@noalloc]
external stub_int32_clz : int32 -> int = "stub_int32_clz" [@@noalloc]
external stub_int64_clz : int64 -> int = "stub_int64_clz" [@@noalloc]
external stub_nativeint_clz : nativeint -> int = "stub_nativeint_clz" [@@noalloc]

external stub_int32_clz_unboxed: int32 -> int32
  = "stub_never" "stub_int32_clz_unboxed" [@@unboxed] [@@noalloc]
external stub_int64_clz_unboxed: int64 -> int64
  = "stub_never" "stub_int64_clz_unboxed" [@@unboxed] [@@noalloc]
external stub_nativeint_clz_unboxed: nativeint -> nativeint
  = "stub_never" "stub_nativeint_clz_unboxed" [@@unboxed] [@@noalloc]

external stub_int32_clz_unboxed_tag: (int32[@unboxed])-> int
  = "stub_int32_clz" "stub_int32_clz_unboxed_tag" [@@noalloc]
external stub_int64_clz_unboxed_tag:  (int64[@unboxed]) -> int
  = "stub_int64_clz" "stub_int64_clz_unboxed_tag" [@@noalloc]
external stub_nativeint_clz_unboxed_tag: (nativeint[@unboxed])-> int
  = "stub_nativeint_clz" "stub_nativeint_clz_unboxed_tag" [@@noalloc]

open Base

(* let iterations = (Int.max_value asr 32) *)
let iterations = 10_000_000
let[@inline never] opaque x = Sys.opaque_identity x

let%bench_fun "int" =
  let min = 0 in
  let max = iterations in
  fun () ->
    let e = ref 0 in
    for i = min to max do
      e := int_clz i
    done;
    for i = -max to -min do
      e := int_clz i
    done;
    opaque !e
;;


let%bench_fun "stub_int" =
  let min = 0 in
  let max = iterations in
  fun () ->
    let e = ref 0 in
    for i = min to max do
      e := stub_int_clz i
    done;
    for i = -max to -min do
      e := stub_int_clz i
    done;
    opaque !e
;;

let%bench_fun "int32" =
  let open Int32.O in
  let min = 0l in
  let max = Int32.of_int_trunc iterations in
  fun () ->
    let e = ref 0 in
    let m = ref min in
    while !m < max do
      e := int32_clz !m;
      m := !m + 1l
    done;
    let m = ref (-max) in
    while !m < -min do
      e := int32_clz !m;
      m := !m + 1l
    done;
    opaque !e
;;

let%bench_fun "stub_int32" =
  let open Int32.O in
  let min = 0l in
  let max = Int32.of_int_trunc iterations in
  fun () ->
    let e = ref 0 in
    let m = ref min in
    while !m < max do
      e := stub_int32_clz !m;
      m := !m + 1l
    done;
    let m = ref (-max) in
    while !m < -min do
      e := stub_int32_clz !m;
      m := !m + 1l
    done;
    opaque !e
;;

let%bench_fun "stub_int32_unboxed" =
  let open Int32.O in
  let min = 0l in
  let max = Int32.of_int_trunc iterations in
  fun () ->
    let e = ref 0l in
    let m = ref min in
    while !m < max do
      e := stub_int32_clz_unboxed !m;
      m := !m + 1l
    done;
    let m = ref (-max) in
    while !m < -min do
      e := stub_int32_clz_unboxed !m;
      m := !m + 1l
    done;
    opaque !e
;;


let%bench_fun "stub_int32_unboxed_tag" =
  let open Int32.O in
  let min = 0l in
  let max = Int32.of_int_trunc iterations in
  fun () ->
    let e = ref 0 in
    let m = ref min in
    while !m < max do
      e := stub_int32_clz_unboxed_tag !m;
      m := !m + 1l
    done;
    let m = ref (-max) in
    while !m < -min do
      e := stub_int32_clz_unboxed_tag !m;
      m := !m + 1l
    done;
    opaque !e
;;

let%bench_fun "int64" =
  let open Int64.O in
  let min = 0L in
  let max = Int64.of_int iterations in
  fun () ->
    let e = ref 0 in
    let m = ref min in
    while !m < max do
      e := int64_clz !m;
      m := !m + 1L
    done;
    let m = ref (-max) in
    while !m < -min do
      e := int64_clz !m;
      m := !m + 1L
    done;
    opaque !e
;;

let%bench_fun "stub_int64" =
  let open Int64.O in
  let min = 0L in
  let max = Int64.of_int iterations in
  fun () ->
    let e = ref 0 in
    let m = ref min in
    while !m < max do
      e := stub_int64_clz !m;
      m := !m + 1L
    done;
    let m = ref (-max) in
    while !m < -min do
      e := stub_int64_clz !m;
      m := !m + 1L
    done;
    opaque !e
;;

let%bench_fun "stub_int64_unboxed" =
  let open Int64.O in
  let min = 0L in
  let max = Int64.of_int iterations in
  fun () ->
    let e = ref 0L in
    let m = ref min in
    while !m < max do
      e := stub_int64_clz_unboxed !m;
      m := !m + 1L
    done;
    let m = ref (-max) in
    while !m < -min do
      e := stub_int64_clz_unboxed !m;
      m := !m + 1L
    done;
    opaque !e
;;


let%bench_fun "stub_int64_unboxed_tag" =
  let open Int64.O in
  let min = 0L in
  let max = Int64.of_int iterations in
  fun () ->
    let e = ref 0 in
    let m = ref min in
    while !m < max do
      e := stub_int64_clz_unboxed_tag !m;
      m := !m + 1L
    done;
    let m = ref (-max) in
    while !m < -min do
      e := stub_int64_clz_unboxed_tag !m;
      m := !m + 1L
    done;
    opaque !e
;;


let%bench_fun "nativeint" =
  let open Nativeint.O in
  let min = 0n in
  let max = Nativeint.of_int iterations in
  fun () ->
    let e = ref 0 in
    let m = ref min in
    while !m < max do
      e := nativeint_clz !m;
      m := !m + 1n
    done;
    let m = ref (-max) in
    while !m < -min do
      e := nativeint_clz !m;
      m := !m + 1n
    done;
    opaque !e
;;


let%bench_fun "stub_nativeint" =
  let open Nativeint.O in
  let min = 0n in
  let max = Nativeint.of_int iterations in
  fun () ->
    let e = ref 0 in
    let m = ref min in
    while !m < max do
      e := stub_nativeint_clz !m;
      m := !m + 1n
    done;
    let m = ref (-max) in
    while !m < -min do
      e := stub_nativeint_clz !m;
      m := !m + 1n
    done;
    opaque !e
;;

let%bench_fun "stub_nativeint_unboxed" =
  let open Nativeint.O in
  let min = 0n in
  let max = Nativeint.of_int iterations in
  fun () ->
    let e = ref 0n in
    let m = ref min in
    while !m < max do
      e := stub_nativeint_clz_unboxed !m;
      m := !m + 1n
    done;
    let m = ref (-max) in
    while !m < -min do
      e := stub_nativeint_clz_unboxed !m;
      m := !m + 1n
    done;
    opaque !e
;;

let%bench_fun "stub_nativeint_unboxed_tag" =
  let open Nativeint.O in
  let min = 0n in
  let max = Nativeint.of_int iterations in
  fun () ->
    let e = ref 0 in
    let m = ref min in
    while !m < max do
      e := stub_nativeint_clz_unboxed_tag !m;
      m := !m + 1n
    done;
    let m = ref (-max) in
    while !m < -min do
      e := stub_nativeint_clz_unboxed_tag !m;
      m := !m + 1n
    done;
    opaque !e
;;
