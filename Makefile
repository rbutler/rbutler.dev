.PHONY: build rebuild deploy run clean

build:
	stack build

rebuild:
	stack exec site rebuild

deploy:
	sh script/deploy

run:
	stack exec site watch

clean:
	stack exec site clean
