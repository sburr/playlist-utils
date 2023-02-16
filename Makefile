.PHONY: all build clean

all: build

build:
	@echo "===> Transpiling CoffeeScript to JavaScript..."
	yarn build
	@echo "Done."

clean:
	@echo "===> Cleaning 'dist' directory..."
	yarn clean
	@echo "Done."
