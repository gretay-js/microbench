# Microbenchmarks for new intrinsics

- clz: count leading zeros in an integer
- popcnt: count number of bits set in an integer
- perfmon: performance monitoring

## Compare performance
1) intrinsics: emit the instruction directly in native compilation
2) call C stubs that invoke the
corresponding C compiler intrinsics or inline assembly.

### Target: amd64
instructions:
- clz using lzcnt vs bsr vs gcc builtins that compile to the same instruction
- popcnt: popcnt vs gcc builtins that compile to popcnt
- perfmon: rdtsc and rdpmc vs inline assembly of the same instruction

### Variations
- different types of input: int, int32, int64, nativeint
- different type of result: always return int vs type of result is the same
as the type of input
- unboxed and untagged


## Preliminary results

On Intel(R) Xeon(R) Gold 6144 CPU @ 3.50GHz
GenuineIntel-6-55
```
standard clz using bsr and xor
┌─────────────────────────────────────┬──────────┐
│ Name                                │ Time/Run │
├─────────────────────────────────────┼──────────┤
│ [clz.ml] int                        │  24.17ms │
│ [clz.ml] stub_int                   │  24.03ms │
│ [clz.ml] int32                      │  29.32ms │
│ [clz.ml] stub_int32                 │  42.62ms │
│ [clz.ml] stub_int32_unboxed         │  37.91ms │
│ [clz.ml] stub_int32_unboxed_tag     │  34.57ms │
│ [clz.ml] int64                      │  25.06ms │
│ [clz.ml] stub_int64                 │  32.14ms │
│ [clz.ml] stub_int64_unboxed         │  27.55ms │
│ [clz.ml] stub_int64_unboxed_tag     │  24.18ms │
│ [clz.ml] nativeint                  │  24.63ms │
│ [clz.ml] stub_nativeint             │  31.66ms │
│ [clz.ml] stub_nativeint_unboxed     │  33.44ms │
│ [clz.ml] stub_nativeint_unboxed_tag │  19.33ms │
└─────────────────────────────────────┴──────────┘
lzcnt clz
┌─────────────────────────────────────┬──────────┐
│ Name                                │ Time/Run │
├─────────────────────────────────────┼──────────┤
│ [clz.ml] int                        │   6.03ms │
│ [clz.ml] stub_int                   │  21.69ms │
│ [clz.ml] int32                      │  25.70ms │
│ [clz.ml] stub_int32                 │  41.39ms │
│ [clz.ml] stub_int32_unboxed         │  37.99ms │
│ [clz.ml] stub_int32_unboxed_tag     │  33.04ms │
│ [clz.ml] int64                      │   9.62ms │
│ [clz.ml] stub_int64                 │  31.39ms │
│ [clz.ml] stub_int64_unboxed         │  28.83ms │
│ [clz.ml] stub_int64_unboxed_tag     │  24.02ms │
│ [clz.ml] nativeint                  │   9.61ms │
│ [clz.ml] stub_nativeint             │  28.88ms │
│ [clz.ml] stub_nativeint_unboxed     │  24.04ms │
│ [clz.ml] stub_nativeint_unboxed_tag │  26.48ms │
└─────────────────────────────────────┴──────────┘
popcnt popcnt
┌────────────────────────────────────────┬──────────┐
│ Name                                   │ Time/Run │
├────────────────────────────────────────┼──────────┤
│ [popcnt.ml] int                        │  19.24ms │
│ [popcnt.ml] stub_int                   │  24.03ms │
│ [popcnt.ml] int32                      │  25.87ms │
│ [popcnt.ml] stub_int32                 │  33.97ms │
│ [popcnt.ml] stub_int32_unboxed         │  33.89ms │
│ [popcnt.ml] stub_int32_unboxed_tag     │  30.30ms │
│ [popcnt.ml] int64                      │  19.29ms │
│ [popcnt.ml] stub_int64                 │  26.72ms │
│ [popcnt.ml] stub_int64_unboxed         │  24.10ms │
│ [popcnt.ml] stub_int64_unboxed_tag     │  21.62ms │
│ [popcnt.ml] nativeint                  │  19.26ms │
│ [popcnt.ml] stub_nativeint             │  26.33ms │
│ [popcnt.ml] stub_nativeint_unboxed     │  24.02ms │
│ [popcnt.ml] stub_nativeint_unboxed_tag │  21.63ms │
└────────────────────────────────────────┴──────────┘

```

### Analysis

- clz intrinsics using lzcnt are much faster than clz intrinsic using bsr
  4x faster for int->int
  2.6x faster for int64->int
  1.14x faster for int32->int

- clz intrinsic using lzcnt is much faster than clz stub using lzcnt
  3.6x faster for int->int,
  2.6x faster for int64->int,
  1.3x faster for int32->int,

- popcnt instrinsic is faster than popcnt stubs consistantly across
  all type variations (12-25% faster).

- clz using bsr: intrinsic vs stubs results are mixed.
  practically no difference for int->int,
  intrinsic faster for int32->int,
  intrinsics slower than stubs for int64->int and nativeint->int
  this is the only indication against intrinsics. WHY does it happen?

- stubs that return int are slighly faster than the ones returning
  boxed types even with untagged/unboxed.
  For example, int64->int is faster than int64-int64
  for both clz variants and popcnt.

- Some questions and answers

  -- why is there such a difference between bsr and lzcnt?
  They have the same latence, throughput, and ports on our
  benchmarking machine, but lzcnt appears to be 2-3x faster
  in our experiments.
  Adjusting the generated code to have exactly the same layout
  (alignment).
  does not make any difference to this phenomenon.

-- why is int32 intrinsic slower than 64 bit version?
  The 32bit version on 64bit machine needs to extend the 32bit input
  value before passing it to clz and then adjut the result.

-- why is there a difference between int64 and nativeint clz? This
  happens with both bsr and with lzcnt?
  The generated code is the same, other than explicit locations,
  and the alignment is similar.

-- why is there virtually no different between clz int->int
  intrinisic, while there is a difference for other types?

## Which dune version to use?

Requires support for of c_flags in profile definitions
with env, see dune-workspace.
Added in https://github.com/ocaml/dune/pull/1700

```
opam pin add dune <path to patched dune>
```

## How to setup the experimental compiler?

```
opam switch create dev --empty
opam pin add ocaml-variants.4.07.1+dev <path-to-experimental-compiler>
opam install dune core core_bench ...
```

Point <path-to-experimental-compiler> to local directory or git repository#branch.

The opam file should contain something like this:

```
opam-version: "2.0"
name: "ocaml-variants"
version: "4.07.1+dev"
depends: [
  "ocaml" {= "4.07.1" & post}
  "base-unix" {post}
  "base-bigarray" {post}
  "base-threads" {post}
]
conflict-class: "ocaml-core-compiler"
flags: compiler
setenv: CAML_LD_LIBRARY_PATH = "%{lib}%/stublibs"
build: [
  ["./configure" "-prefix" prefix]
    {os != "openbsd" & os != "freebsd" & os != "macos"}
  ["./configure" "-prefix" prefix "-cc" "cc" "-aspp" "cc -c"]
    {os = "openbsd" | os = "freebsd" | os = "macos"}
  [make "-j4" "world"]
  [make "-j4" "world.opt"]
]
install: [make "install"]
```

Note the version numbering schema to make it work.
