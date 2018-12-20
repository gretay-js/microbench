#!/usr/bin/env sh

export BENCHMARKS_RUNNER=TRUE
flags="-run-without-cross-library-inlining"
quota="-quota 1"

runit () {
    echo $PROFILE $BENCH
    export BENCH_LIB=$BENCH_bench
    bin/$BENCH"_main_"$PROFILE.exe $flags $quota $@
}

export BENCH=clz
export PROFILE=standard
runit

export BENCH=clz
export PROFILE=lzcnt
runit

export BENCH=popcnt
export PROFILE=popcnt
runit


