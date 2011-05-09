compile: 
	(runhaskell Setup configure --user --prefix=$$HOME)
	(runhaskell Setup build)
	(cp -a dist/build/jark/jark jark)
	(rm -rf dist)
