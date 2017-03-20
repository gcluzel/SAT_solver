all: 
	ocamlbuild -yaccflag -v -lib unix main.native; ln -fs main.native f2bdd
	ocamlbuild -yaccflag -v -lib unix parite.native; ln -fs parite.native parite
	ocamlbuild -yaccflag -v -lib unix rotations.native; ln -fs rotation.native rotations
	ocamlbuild -yaccflag -v -lib unix tiroir.native; ln -fs tiroir.native tiroir
	ocamlbuild -yaccflag -v -lib unix addition.native; ln -fs addition.native addition

byte: 
	ocamlbuild -yaccflag -v main.byte
	ocamlbuild -yaccflag -v parite.byte
	ocamlbuild -yaccflag -v rotations.byte
	ocamlbuild -yaccflag -v tiroir.byte
	ocamlbuild -yaccflag -v addition.byte
clean: 
	ocamlbuild -clean
