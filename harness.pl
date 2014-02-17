#!/usr/bin/perl

my @test_files = glob 'tests/*.hs';

for (@test_files) {
    s/\.hs$//;
    print "$_ (single threaded)\n";
    system "ghc --make -isrc -fforce-recomp $_.hs -o ${_}_single && ./${_}_single" and die $!;
    print "$_ (multithreaded)\n";
    system "ghc --make -isrc -fforce-recomp $_.hs -o ${_}_multi -threaded && ./${_}_multi +RTS -N2" and die $!;
}
