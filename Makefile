all: 
	ocamlbuild -yaccflag -v -lib unix main.native; ln -fs main.native prop

byte: 
	ocamlbuild -yaccflag -v main.byte

clean: 
	ocamlbuild -clean
