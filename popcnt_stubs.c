#include <stdlib.h>
/* #include <stdbool.h>
 * #include <stdint.h>
 * #include <string.h>
 * #include <caml/alloc.h> */
#include <caml/mlvalues.h>
/* #include <caml/memory.h> */


#if defined(__GNUC__)
#if ARCH_INT32_TYPE == long
#define int32_popcnt __builtin_popcountl
#else /* ARCH_INT32_TYPE == long */
#define int32_popcnt __builtin_popcount
#endif /* ARCH_INT32_TYPE == long */

#define int64_popcnt __builtin_popcountll

#else /* defined(__GNUC__) */
#ifdef _MSC_VER
#include <intrin.h>
#pragma intrinsic(_BitScanReverse)

/* _MSVC_ intrinsic for popcnt is not supported on all targets.
   Use naive version of popcnt from Hacker's Delight. */

int naive_int64_popcnt (uint64_t x)
{
   int n = 0;
   while (x != 0) {
      n = n + 1;
      x = x & (x - 1);
   }
   return n;
}

int naive_int32_popcnt (uint32_t x)
{
   int n = 0;
   while (x != 0) {
      n = n + 1;
      x = x & (x - 1);
   }
   return n;
}

#define int32_popcnt naive_int32_popcnt
#define int64_popcnt naive_int64_popcnt
#endif /* _MSC_VER */
#endif /* defined(__GNUC__) */

CAMLprim value stub_untagged_int_popcnt(value v1)
{
#ifdef ARCH_SIXTYFOUR
  return int64_popcnt((uint64_t)v1);
#else
  return int32_popcnt((uint32_t)v1);
#endif
}

CAMLprim value stub_int_popcnt(value v1)
{
  /* -1 to account for the tag */
#ifdef ARCH_SIXTYFOUR
  return Val_long((int64_popcnt((uint64_t)v1)) - 1);
#else
  return Val_long((int32_popcnt((uint32_t)v1)) - 1);
#endif
}

CAMLprim int stub_int32_popcnt_unboxed(int32_t v)
{ return int32_popcnt((uint32_t) v); }

CAMLprim value stub_int32_popcnt_unboxed_tag(int32_t v)
{ return Val_long(int32_popcnt((uint32_t) v)); }

CAMLprim value stub_int32_popcnt(value v1)
{ return Val_long(int32_popcnt((uint32_t) (Int32_val(v1)))); }

CAMLprim int stub_int64_popcnt_unboxed(int64_t v)
{ return int64_popcnt((uint64_t) v); }

CAMLprim int stub_int64_popcnt_unboxed_tag(int64_t v)
{ return Val_long(int64_popcnt((uint64_t) v)); }

CAMLprim value stub_int64_popcnt(value v1)
{ return Val_long(int64_popcnt((uint64_t) (Int64_val(v1)))); }

CAMLprim int stub_nativeint_popcnt_unboxed(intnat v)
{
#ifdef ARCH_SIXTYFOUR
  return int64_popcnt((uint64_t) v);
#else
  return int32_popcnt((uint32_t) v);
#endif
}

CAMLprim int stub_nativeint_popcnt_unboxed_tag(intnat v)
{
#ifdef ARCH_SIXTYFOUR
  return Val_long(int64_popcnt((uint64_t) v));
#else
  return Val_long(int32_popcnt((uint32_t) v));
#endif
}

CAMLprim value stub_nativeint_popcnt(value v1)
{
#ifdef ARCH_SIXTYFOUR
  return Val_long(int64_popcnt((uint64_t) Int64_val(v1)));
#else
  return Val_long(int32_popcnt((uint32_t) Int32_val(v1)));
#endif
}
