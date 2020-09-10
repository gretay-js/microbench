open Cpuid

let () =
  let caps = Capabilities.get () in
  Printf.printf "lzcnt is %B\n" (Capabilities.lzcnt caps);
  Printf.printf "popcnt is %B\n" (Capabilities.popcnt caps);
  ()
