SHELL=bash

.PHONY: all
all: clz popcnt

.PHONY: clz
clz:
	dune build _build/standard/clz_main.exe
	cp _build/standard/clz_main.exe bin/clz_main_standard.exe
	dune build _build/lzcnt/clz_main.exe
	cp _build/lzcnt/clz_main.exe bin/clz_main_lzcnt.exe

.PHONY: popcnt
popcnt:
	dune build _build/popcnt/popcnt_main.exe
	cp _build/popcnt/popcnt_main.exe bin/popcnt_main_popcnt.exe

.PHONY: perfmon
perfmon:
	dune build _build/standard/perfmon_main.exe
	cp _build/standard/perfmon_main.exe bin/perfmon_main_standard.exe

.PHONY: cpuid
cpuid:
	dune build _build/standard/cpuid/main.exe
	cp _build/standard/cpuid/main.exe bin/cpuid_main.exe


.PHONY: objdump

objdump:
	objdump -d bin/popcnt_main_popcnt.exe > obj/popcnt_main_popcnt.exe.s
	objdump -d bin/clz_main_lzcnt.exe > obj/clz_main_lzcnt.exe.s
	objdump -d bin/clz_main_standard.exe > obj/clz_main_standard.exe.s
