################################################################################
# Importer les couches d’information et les afficher sur une carte (4 points)
################################################################################ 







################################################################################
# Carte du nombre de locations par IRIS (4 points)
################################################################################ 










################################################################################ 
# Prix médian par personne dans le voisinage du MK2 Bibliothèque (4 points)
################################################################################ 

# La variable accommodates désigne le nombre de visiteurs




cat(paste0("Le prix médian par personne dans un voisinage de 600
           mètres autour du MK2 Bibliothèque est de ", 
           round(value, 0), 
           " euros."))





################################################################################ 
# Utilisation d’un maillage régulier (4 points)
################################################################################ 

# Créer une grille régulière avec st_make_grid()

# Transformer la grille en objet sf avec st_sf()

# Ajouter un identifiant unique

# Faire une jointure spatiale entre les locations et la grille

# Compter le nombre de locations dans chaque carreau

# Calculez le prix médian par personne par carreau

# Sélectionner les carreaux ayant plus de 5 transactions

# Justification de la discrétisation


