# Microbenchmarks for new intrinsics

- clz: count leading zeros in an integer
- popcnt: count number of bits set in an integer
- perfmon: performance monitoring

## Compare performance
1) intrisics: emit the instruction directly in native compilation
2) call C stubs that invoke the
corresponding C compile intrinsics or inline assembly.

### Target: amd64
instructions:
- clz using lzcnt vs bsr vs gcc builtins
- popcnt: popcnt instruction vs gcc builtins
- perfmon: rdtsc, rdpmc vs inline assembly

Compare performance of different types.

## Preliminary results

On Intel(R) Xeon(R) Gold 6144 CPU @ 3.50GHz
GenuinIntel-6-55
```
standard clz
Warning: X_LIBRARY_INLINING is not set to true, benchmarks may be inaccurate.
Estimated testing time 14s (14 benchmarks x 1s). Change using -quota SECS.
┌─────────────────────────────────────┬──────────┬────────────────┬──────────┬──────────┬────────────┐
│ Name                                │ Time/Run │        mWd/Run │ mjWd/Run │ Prom/Run │ Percentage │
├─────────────────────────────────────┼──────────┼────────────────┼──────────┼──────────┼────────────┤
│ [clz.ml] int                        │  33.71ms │         -0.13w │   -1.53w │   -1.53w │     68.00% │
│ [clz.ml] stub_int                   │  21.66ms │                │   -1.05w │   -1.05w │     43.70% │
│ [clz.ml] int32                      │  30.88ms │         -0.13w │   -1.53w │   -1.53w │     62.30% │
│ [clz.ml] stub_int32                 │  41.92ms │ 60_000_343.26w │    0.17w │    0.17w │     84.56% │
│ [clz.ml] stub_int32_unboxed         │  37.98ms │          2.83w │   -1.92w │   -1.92w │     76.61% │
│ [clz.ml] stub_int32_unboxed_tag     │  43.36ms │         -0.17w │   -1.92w │   -1.92w │     87.46% │
│ [clz.ml] int64                      │  34.11ms │         -0.13w │   -1.53w │   -1.53w │     68.81% │
│ [clz.ml] stub_int64                 │  33.01ms │ 60_000_343.17w │    0.13w │    0.13w │     66.58% │
│ [clz.ml] stub_int64_unboxed         │  28.91ms │          2.87w │   -1.53w │   -1.53w │     58.32% │
│ [clz.ml] stub_int64_unboxed_tag     │  49.57ms │         -0.21w │   -2.46w │   -2.46w │    100.00% │
│ [clz.ml] nativeint                  │  34.47ms │         -0.13w │   -1.53w │   -1.53w │     69.53% │
│ [clz.ml] stub_nativeint             │  31.26ms │ 60_000_343.32w │    0.13w │    0.13w │     63.06% │
│ [clz.ml] stub_nativeint_unboxed     │  32.14ms │          2.87w │   -1.53w │   -1.53w │     64.84% │
│ [clz.ml] stub_nativeint_unboxed_tag │  48.16ms │         -0.21w │   -2.46w │   -2.46w │     97.14% │
└─────────────────────────────────────┴──────────┴────────────────┴──────────┴──────────┴────────────┘
lzcnt clz
Warning: X_LIBRARY_INLINING is not set to true, benchmarks may be inaccurate.
Estimated testing time 14s (14 benchmarks x 1s). Change using -quota SECS.
┌─────────────────────────────────────┬──────────┬────────────────┬──────────┬──────────┬────────────┐
│ Name                                │ Time/Run │        mWd/Run │ mjWd/Run │ Prom/Run │ Percentage │
├─────────────────────────────────────┼──────────┼────────────────┼──────────┼──────────┼────────────┤
│ [clz.ml] int                        │   9.63ms │                │   -0.57w │   -0.57w │     19.98% │
│ [clz.ml] stub_int                   │  21.68ms │                │   -1.05w │   -1.05w │     44.97% │
│ [clz.ml] int32                      │  28.72ms │         -0.13w │   -1.53w │   -1.53w │     59.57% │
│ [clz.ml] stub_int32                 │  40.62ms │ 60_000_343.26w │    0.17w │    0.17w │     84.26% │
│ [clz.ml] stub_int32_unboxed         │  37.55ms │          2.83w │   -1.92w │   -1.92w │     77.89% │
│ [clz.ml] stub_int32_unboxed_tag     │  48.21ms │         -0.21w │   -2.46w │   -2.46w │    100.00% │
│ [clz.ml] int64                      │   9.64ms │                │   -0.57w │   -0.57w │     19.99% │
│ [clz.ml] stub_int64                 │  32.93ms │ 60_000_343.17w │    0.13w │    0.13w │     68.31% │
│ [clz.ml] stub_int64_unboxed         │  23.96ms │          2.89w │   -1.25w │   -1.25w │     49.71% │
│ [clz.ml] stub_int64_unboxed_tag     │  43.08ms │         -0.17w │   -1.92w │   -1.92w │     89.36% │
│ [clz.ml] nativeint                  │   9.58ms │                │   -0.57w │   -0.57w │     19.87% │
│ [clz.ml] stub_nativeint             │  28.15ms │ 60_000_343.32w │    0.13w │    0.13w │     58.39% │
│ [clz.ml] stub_nativeint_unboxed     │  21.53ms │          2.91w │   -1.05w │   -1.05w │     44.67% │
│ [clz.ml] stub_nativeint_unboxed_tag │  43.10ms │         -0.17w │   -1.92w │   -1.92w │     89.41% │
└─────────────────────────────────────┴──────────┴────────────────┴──────────┴──────────┴────────────┘
popcnt popcnt
Warning: X_LIBRARY_INLINING is not set to true, benchmarks may be inaccurate.
Estimated testing time 14s (14 benchmarks x 1s). Change using -quota SECS.
┌────────────────────────────────────────┬──────────┬────────────────┬──────────┬──────────┬────────────┐
│ Name                                   │ Time/Run │        mWd/Run │ mjWd/Run │ Prom/Run │ Percentage │
├────────────────────────────────────────┼──────────┼────────────────┼──────────┼──────────┼────────────┤
│ [popcnt.ml] int                        │  28.92ms │         -0.13w │   -1.53w │   -1.53w │     62.67% │
│ [popcnt.ml] stub_int                   │  21.67ms │                │   -1.05w │   -1.05w │     46.96% │
│ [popcnt.ml] int32                      │  28.55ms │         -0.13w │   -1.53w │   -1.53w │     61.86% │
│ [popcnt.ml] stub_int32                 │  34.15ms │ 60_000_343.17w │    0.13w │    0.13w │     74.00% │
│ [popcnt.ml] stub_int32_unboxed         │  33.63ms │          2.87w │   -1.53w │   -1.53w │     72.87% │
│ [popcnt.ml] stub_int32_unboxed_tag     │  46.15ms │         -0.17w │   -1.92w │   -1.92w │    100.00% │
│ [popcnt.ml] int64                      │  28.96ms │         -0.13w │   -1.53w │   -1.53w │     62.75% │
│ [popcnt.ml] stub_int64                 │  26.70ms │ 60_000_343.35w │    0.11w │    0.11w │     57.86% │
│ [popcnt.ml] stub_int64_unboxed         │  23.39ms │          2.89w │   -1.25w │   -1.25w │     50.68% │
│ [popcnt.ml] stub_int64_unboxed_tag     │  44.15ms │         -0.17w │   -1.92w │   -1.92w │     95.67% │
│ [popcnt.ml] nativeint                  │  28.91ms │         -0.13w │   -1.53w │   -1.53w │     62.65% │
│ [popcnt.ml] stub_nativeint             │  26.66ms │ 60_000_343.35w │    0.11w │    0.11w │     57.79% │
│ [popcnt.ml] stub_nativeint_unboxed     │  24.08ms │          2.89w │   -1.25w │   -1.25w │     52.18% │
│ [popcnt.ml] stub_nativeint_unboxed_tag │  43.33ms │         -0.17w │   -1.92w │   -1.92w │     93.89% │
└────────────────────────────────────────┴──────────┴────────────────┴──────────┴──────────┴────────────┘

```


## Which dune version to use?

Requries support for of c_flags and cxx_flags in profile definitions
with env, see dune-workspace.
Added in https://github.com/ocaml/dune/pull/1700

## How to setup the experimental compiler?

opam switch create dev --empty
opam pin add ocaml-variants.4.07.1+dev <path-to-experimental-compiler>
opam install dune core core_extended core_bench

Point <path-to-experimental-compiler> to local directory or git repository#branch.
The opam file should contain something like this:

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

Note the version numbering schema to make it work.
