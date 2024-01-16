.PHONY: pygments
pygments:
	cp src/birch.py pygments/pygments/lexers/.
	cd pygments && tox -e mapfiles && pip install -e .

build: pygments
	mkdocs build

serve: pygments
	mkdocs serve

deploy:
	mkdocs gh-deploy

