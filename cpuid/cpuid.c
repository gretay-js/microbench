#include <caml/mlvalues.h>
#include <caml/memory.h>

/* Returns 1 if the requested leaf is support, and stores the corresponding
   valid cpu information into the provided pointers.
   Returns 0 if the requested leaf is not supported. */
#if defined(__GNUC__)
#include <cpuid.h>
#define get_cpuid __get_cpuid
#elif defined(_MSC_VER)
#include <intrin.h>

int get_cpuid(uint32_t level,
              uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t  *edx)
{
  uint32_t abcd[4];
  /* Calling __cpuid with 0x80000000 as the function_id argument
     gets the number of the highest valid extended ID. */
  __cpuid(abcd, (level & 0x80000000));
  uint32_t max_level = abcd[0];

  if (max_level == 0 || max_level < level)
    return 0;

  __cpuid(abcd, level);
  *eax = abcd[0];
  *ebx = abcd[1];
  *ecx = abcd[2];
  *edx = abcd[3];
  return 1;
}
#endif


/* Returns 1 if the bit is valid and set, 0 otherwise. */
int check_ecx(uint32_t level, uint32_t bit_mask)
{
  uint32_t eax; uint32_t ebx; uint32_t ecx; uint32_t edx;
  if (!get_cpuid(level,&eax,&ebx,&ecx,&edx)) return 0;
  if ((ecx & bit_mask) == 0) return 0;
  else return 1;
}

#define maskPOPCNT (1<<23)
#define maskLZCNT (1<<5)

#define popcnt_support check_ecx(1,maskPOPCNT)
#define lzcnt_support check_ecx(0x80000001, maskLZCNT)

/* The below must be kept in sync with the record defined in [cpuid.ml] */
CAMLprim value cpuid_features(value v_caps)
{
  CAMLparam1(v_caps);
  Store_field(v_caps, 0, Val_bool(lzcnt_support));
  Store_field(v_caps, 1, Val_bool(popcnt_support));
  CAMLreturn(Val_unit);
}

/* Returns 1 if lzcnt instruction is available, 0 otherwise.
   Another way to check if lzcnt is supported:
   emit the instruction and check the return value.
   If lzcnt is not support, then the instruction assembles to bsr.
   lzcnt(2) == bitwidth-2
   bsr(2) == 1 */
CAMLprim value check_lzcnt_direct()
{
  CAMLparam0();
  unsigned long x;
  unsigned long n;
  unsigned long bitwidth;

  x = 2;
  asm ("lzcnt\t%[n], %[x]\n\t" : [n] "=r" (n) : [x] "r" (x) );

#ifdef ARCH_SIXTYFOUR
  bitwidth = 64;
#else
  bitwidth = 32;
#endif

  if (n == (bitwidth-2))
    CAMLreturn(Val_bool(1));
  else if (n == 2)
    CAMLreturn(Val_bool(0));
  else
    __builtin_unreachable();
}
