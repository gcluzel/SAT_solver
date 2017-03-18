Gestion du partage :
La première version était sans partage pour le BDD : c'est à dire que les structures de données t et h ainsi que la fonction mk. Puis pour implémenter le partage, il n'y avait qu'à ajouter ces trois objets, et à utiliser mk à la fin de la fonction déjà implémentée pour savoir si la branche créée est nouvelle ou pas (et donc savoir si on la garde ou pas).

Précision importante : t est pour nous un tableau de taille fixe.
Cette taille est fixée dans le fichier f2bdd.cfg, il suffit de modifier la valeur inscrite dedans pour allouer plus ou moins de mémoire au tableau
