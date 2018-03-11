build:
	perl build.pl

serve: build
	mkdocs serve

deploy: build
	mkdocs gh-deploy
