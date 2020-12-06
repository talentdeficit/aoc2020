.PHONY: run install

run:
	julia --project=@. bin/$(day)/run.jl

install:
	julia --project=@. -e 'using Pkg; Pkg.instantiate()'
