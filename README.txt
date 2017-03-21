Le BDD est assez lent quand la formule est satisfiable et qu'il y a plus de 100 variables.
Il sort toujours la même réponse que minisat que la formule soit satifisable ou non, ce qui est plutôt une bonne nouvelle.

Sur les exemples du cours, certains sont très longs à traiter avec le BDD.

Sans argument, le programme affiche simplement le BDD.

=========================================================
                        BDD
=========================================================
Gestion du partage :
La première version était sans partage pour le BDD : c'est à dire que les structures de données t et h ainsi que la fonction mk. Puis pour implémenter le partage, il n'y avait qu'à ajouter ces trois objets, et à utiliser mk à la fin de la fonction déjà implémentée pour savoir si la branche créée est nouvelle ou pas (et donc savoir si on la garde ou pas).

Précision importante : t est pour nous un tableau de taille fixe.
Cette taille est fixée dans le fichier f2bdd.cfg, il suffit de modifier la valeur inscrite dedans pour allouer plus ou moins de mémoire au tableau



=========================================================
                      Tseitin
=========================================================

Il y a deux fichiers :
 - Le premier permet de convertir de faire la transformation de Tseitin. Tout marche. Mais il ne traite pas les cas de => et <=> qui sont à la place modifié en ¬P \/ Q pour P => Q et de même pour <=>.
 - dimacs.ml permet de créer un fichier dimacs à partir d'une formule sous forme normale conjonctive (préalablement transformer avec Tseitin.ml donc)
 
Ces deux fichiers marchent bien.


=========================================================
                        Tests
=========================================================

Les fichiers .form de test dans dans le répertoire test/

Pour utiliser les tests : (remplacer n par un entier)
 - Additionneur : ./addition n 
 - Tiroir : ./tiroir n
 - Rotations : ./rotations n
 - Parite : ./parite n
 - Aléatoire : ./aleatoire n
 
 Ce dernier fichier prend un nombre en entrée et créer une formule de hauteur n aléatoire.
 
 Ces commandes créent un fichier .form qu'il faut ensuite passer en argument de f2bbd.