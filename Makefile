.PHONY: current install test run

current:
	julia --project=@. bin/three/run.jl

install:
	julia --project=@. -e 'using Pkg; Pkg.instantiate()'

test:
	julia --project=@. test/runtests.jl