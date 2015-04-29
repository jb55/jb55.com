
all: index.xml

index.xml: home.scm
	chibi-scheme -A lib $^ | sed 1d > $@
	@sed -i 1d style.xsl

.PHONY: index.xml
