RU=../apertium-kv-ru/apertium-kv-ru.ru.dix

all:
	if [ ! -d .deps ]; then mkdir .deps ; fi

	hfst-lexc apertium-cv-ru.cv.lexc -o .deps/cv-ru.lexc.hfst
	hfst-twolc -R -i apertium-cv-ru.cv.twol -o .deps/cv-ru.twol.hfst
	hfst-compose-intersect -1 .deps/cv-ru.lexc.hfst -2 .deps/cv-ru.twol.hfst -o .deps/cv-ru.gen.hfst
	hfst-invert .deps/cv-ru.gen.hfst > .deps/cv-ru.morf.hfst
	hfst-fst2fst -O -i .deps/cv-ru.morf.hfst -o cv-ru.automorf.hfst
	hfst-fst2fst -O -i .deps/cv-ru.gen.hfst -o cv-ru.autogen.hfst

	if [ ! -d .deps ]; then mkdir .deps; fi
	xsltproc lexchoicebil.xsl apertium-cv-ru.cv-ru.dix > .deps/apertium-cv-ru.cv-ru.dix
	apertium-validate-dictionary .deps/apertium-cv-ru.cv-ru.dix

	lt-comp lr .deps/apertium-cv-ru.cv-ru.dix cv-ru.autobil.bin
	lt-comp rl $(RU) cv-ru.autogen.bin
	cg-comp apertium-cv-ru.cv-ru.rlx cv-ru.rlx.bin

	apertium-validate-transfer apertium-cv-ru.cv-ru.t1x
	apertium-preprocess-transfer apertium-cv-ru.cv-ru.t1x cv-ru.t1x.bin
	apertium-validate-interchunk apertium-cv-ru.cv-ru.t2x
	apertium-preprocess-transfer apertium-cv-ru.cv-ru.t2x cv-ru.t2x.bin
	apertium-validate-postchunk apertium-cv-ru.cv-ru.t3x
	apertium-preprocess-transfer apertium-cv-ru.cv-ru.t3x cv-ru.t3x.bin

	apertium-gen-modes modes.xml
	cp *.mode modes/
clean:
	rm -rf .deps *.bin modes *.mode *.hfst
