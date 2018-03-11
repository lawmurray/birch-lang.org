build:
	perl build.pl
	mkdocs build

serve: build
	mkdocs serve

deploy: build
	mkdocs gh-deploy
