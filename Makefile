build:
	mkdocs build

serve: build
	mkdocs serve

deploy: build
	mkdocs gh-deploy
