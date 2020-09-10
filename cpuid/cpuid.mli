module Capabilities : sig
  type t

  val lzcnt: t -> bool
  val popcnt: t -> bool

  val get: unit -> t
end
