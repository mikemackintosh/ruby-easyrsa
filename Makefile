all: clear build push

clear:
	rm -rf *.gem

build:
	gem build easyrsa.gemspec

push:
	gem push *.gem
