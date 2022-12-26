binary:
	dune build src/XpatSolver.exe

byte:
	dune build src/XpatSolver.bc

clean:
	dune clean

test:
	dune runtest

summary:
	@./test-summary
