all: build

build:
	@docker build --tag=quay.io/sameersbn/openfire .

release: build
	@docker build --tag=quay.io/sameersbn/openfire:$(shell cat VERSION) .
