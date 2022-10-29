.PHONY: pygments
pygments:
	cp src/birch.py pygments/pygments/lexers/.
	cd pygments && make mapfiles && python3.10 setup.py install --force --prefix $(HOME)/.local

build: pygments
	mkdocs build

serve: pygments
	mkdocs serve

deploy:
	mkdocs gh-deploy

