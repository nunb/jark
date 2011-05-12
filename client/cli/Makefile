compile: 
	(runhaskell Setup configure --user --prefix=$$HOME)
	(runhaskell Setup build)
	(cp -a dist/build/jark/jark jark)
	(rm -rf dist)

deps: 
	(cabal install readline regex-compat pretty)
	(cabal install Shellac parsec Shellac-readline)
	(cabal install network curl)
