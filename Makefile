.PHONY: build rebuild deploy run clean

build:
	stack build

rebuild:
	stack exec rbio rebuild

deploy:
	sh script/deploy

run:
	stack exec rbio watch

clean:
	stack exec rbio clean
