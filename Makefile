
all: index.xml

index.xml: home.scm
	chibi-scheme -A lib $^ | sed 1d > $@

.PHONY: index.xml
