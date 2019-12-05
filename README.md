# COMPTER LES PERSONNELS ET CREDITS CNRS DES LABOS

Pour calculer le montant des soutiens CNRS par type d'unité de recherche, j'ai utilisé les fonctions :
- **unique** pour dédoublonner le fichier en ne gardant qu'une ligne par UMR distincte
- **gsub** pour retirer les espaces qui s'étaient glissés via un séparateur de milliers, ou les virgules du format français qui avaient remplacé les points
- **as.numeric** pour transformer des chaînes de caractères en valeurs numériques
