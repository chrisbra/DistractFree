SCRIPT=$(wildcard plugin/*.vim)
DOC=$(wildcard doc/*.txt)
AUTOL=$(wildcard autoload/*.vim)
COLORS=colors/darkroom.vim
PLUGIN=$(shell basename $$PWD)
VERSION=$(shell sed -n '/Version:/{s/^.*\(\S\.\S\+\)$$/\1/;p}' $(SCRIPT))

.PHONY: $(PLUGIN).vmb README

all: uninstall vimball install README

vimball: $(PLUGIN).vmb

clean:
	find . -type f \( -name "*.vba" -o -name "*.orig" -o -name "*.~*" \
	-o -name ".VimballRecord" -o -name ".*.un~" -o -name "*.sw*" -o \
	-name tags -o -name "*.vmb" \) -delete

dist-clean: clean

install:
	vim -N -c':so %' -c':q!' $(PLUGIN)-$(VERSION).vmb

uninstall:
	if [ -f "$(PLUGIN).vmb" ]; then vim -N -c':RmVimball' -c':q!' $(PLUGIN).vmb; fi

undo:
	for i in */*.orig; do mv -f "$$i" "$${i%.*}"; done

README:
	cp -f $(DOC) README

$(PLUGIN).vmb:
	if [ -f "$(PLUGIN)-$(VERSION).vmb" ]; then rm -f $(PLUGIN)-$(VERSION).vmb; fi
	vim -N -c 'ru! vimballPlugin.vim' -c ':call append("0", [ "$(SCRIPT)", "$(DOC)", "$(AUTOL)", "$(COLORS)"])' -c '$$d' -c ":%MkVimball $(PLUGIN)-$(VERSION)   ." -c':q!'
	ln -f $(PLUGIN)-$(VERSION).vmb $(PLUGIN).vmb
     
release: version all

version:
	perl -i.orig -pne 'if (/Version:/) {s/\.(\d*)/sprintf(".%d", 1+$$1)/e}' ${SCRIPT} ${AUTOL}
	perl -i -pne 'if (/GetLatestVimScripts:/) {s/(\d+)\s+:AutoInstall:/sprintf("%d :AutoInstall:", 1+$$1)/e}' ${SCRIPT} ${AUTOL}
	perl -i -pne 'if (/Last Change:/) {s/(:\s+).*\n/sprintf(": %s", `date -R`)/e}' ${SCRIPT} ${AUTOL}
	perl -i.orig -pne 'if (/Version:/) {s/\.(\d+).*\n/sprintf(".%d %s", 1+$$1, `date -R`)/e}' ${DOC}
	VERSION=$(shell sed -n '/Version:/{s/^.*\(\S\.\S\+\)$$/\1/;p}' $(SCRIPT))
