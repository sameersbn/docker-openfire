all: build

build:
	@docker build --tag=sameersbn/openfire .

release: build
	@docker build --tag=sameersbn/openfire:$(shell cat VERSION) .
