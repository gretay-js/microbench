#!/usr/bin/env sh

export BENCHMARKS_RUNNER=TRUE
flags="-run-without-cross-library-inlining -clear-columns time"
quota="-quota 1"

runit () {
    echo $PROFILE $BENCH
    export BENCH_LIB=$BENCH_bench
    taskset -c 2 bin/$BENCH"_main_"$PROFILE.exe $flags $quota $@
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

export BENCH=perfmon
export PROFILE=standard
runit

