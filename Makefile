SHELL=bash

.PHONY: install
install: clz popcnt
	mkdir -p bin
	cp _build/standard/clz_main.exe bin/clz_main_standard.exe
	cp _build/lzcnt/clz_main.exe bin/clz_main_lzcnt.exe
	cp _build/popcnt/popcnt_main.exe bin/popcnt_main_popcnt.exe

.PHONY: all
all: clz popcnt

.PHONY: clz
clz:
	dune build _build/standard/clz_main.exe
	dune build _build/lzcnt/clz_main.exe

.PHONY: popcnt
popcnt:
	dune build _build/popcnt/popcnt_main.exe

