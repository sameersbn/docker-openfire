all: build

build:
	@docker build --tag=${USER}/openfire .

release: build
	@docker build --tag=${USER/openfire:$(shell cat VERSION) .
