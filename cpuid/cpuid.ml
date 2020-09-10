open Base
open Stdlib

module Capabilities = struct
  (* This record must match the layout assumed in [cpuid.c] *)
  type t =
    { mutable lzcnt       : bool
    ; mutable popcnt      : bool
    }

  external cpuid_features : t -> unit = "cpuid_features"
  external check_lzcnt : unit -> bool = "check_lzcnt_direct"

  let lzcnt t = t.lzcnt
  let popcnt t = t.popcnt

  let get () =
    let t =
      { lzcnt = false
      ; popcnt = false
      }
    in
    cpuid_features t;
    let b = check_lzcnt () in
    if not ((not t.lzcnt && not b) || (t.lzcnt && b)) then
      failwith (Printf.sprintf
                  "Checking for lzcnt: cpuid returns %B, \
                   but executing lzcnt(2) check returns %B.\n" t.lzcnt b);
    t
end
