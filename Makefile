.PHONY: pygments
pygments:
	cp src/birch.py pygments/pygments/lexers/.
	cd pygments && make mapfiles && easy_install-3.8 --prefix $(HOME)/.local .

build: pygments
	mkdocs build

serve: pygments
	mkdocs serve

deploy:
	mkdocs gh-deploy
