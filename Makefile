.PHONY: current install test run

current:
	julia --project=@. bin/two/run.jl

install:
	julia --project=@. -e 'using Pkg; Pkg.instantiate()'

test:
	julia --project=@. test/runtests.jl