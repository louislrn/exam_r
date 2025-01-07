################################################################################
# Importer les couches d’information et les cartographier (4 points)
################################################################################ 







################################################################################
# Carte des prix par personne (accommodates) (4 points)
################################################################################ 





# Justification de la discrétisation (statistiques, boxplot, histogramme, 
# beeswarm...)





################################################################################ 
# Prix médian par personne dans le voisinage du MK2 Bibliothèque (4 points)
################################################################################ 






cat(paste0("Le prix médian par personne dans un voisinage de 600
           mètres autour du MK2 Bibliothèque est de ", 
           round(value, 0), 
           " euros par m²"))





################################################################################ 
# Utilisation d’un maillage régulier (4 points)
################################################################################ 

# Créer une grille régulière avec st_make_grid()

# Transformer la grille en objet sf avec st_sf()

# Ajouter un identifiant unique

# Faire une jointure spatiale entre les locations et la grille

# Compter le nombre de locations dans chaque carreau

# Calculez le prix médian par carreau

# Sélectionner les carreaux ayant plus de 5 transactions

# Justification de la discrétisation (statistiques, boxplot, histogramme, 
# beeswarm...)


