GEM := $(shell which gem)
BUNDLE := $(shell which bundle)

all: clear build push

clear:
	rm -rf *.gem

init:
	$(BUNDLE) install --path=vendor/bundle

build:
	$(GEM) build easyrsa.gemspec

push: build
	$(GEM) push *.gem

test:
	$(BUNDLE) exec rake test

gem: test build push
