library(data.table)

#set working directory
setwd('/Users/analutzky/Desktop/UMR_CNRS')

Table_UMR=fread('UMR_tableau_global.csv')

View(Table_UMR)
# -> affichage excel-like

var.names=colnames(Table_UMR)
colnames(Table_UMR)=make.names(var.names)


####### CALCULER LE MONTANT DES SOUTIENS CNRS PAR TYPE D'UNITE DE RECHERCHE (verif des calculs excel)
# Mes premiers essais :
# Table_dotations = Table_UMR[,.(credits=sum(CréditsFEICNRS2018),mass_esalariale=sum(Masse.salariale.CNRS.31.12.2018),ETPT=sum(ETPT.CNRS.31.12.2018),by=.(type.d.unité))]
# Error in sum(CréditsFEICNRS2018) : 
#   'type' (character) de l'argument incorrect
# en fait y'a des espaces pour les séparateurs de milliers dans la variable des crédits => il faut supprimer les espaces et transformer les string en numeric
# autre erreur : j'avais mal placé la 2ème parenthèse. Fallait la mettre avant le by, sinon R croit qu'il s'agit d'une variable des colonnes

# Table_936_UR = Table_UMR[,.by=.(type.d.unité = 'ERL', 'UMR', 'UPR', 'FRE', 'USR' )]
# Error in `[.data.table`(Table_UMR, , .by = .(type.d.unité = "ERL", "UMR",  : 
#   argument inutilisé (.by = .(type.d.unité = "ERL", "UMR", "UPR", "FRE", "USR"))

##### LA SOLUTION DECOMPOSEE

# enlever les doublons (on ne garde que la 1ere ligne pour chaque Code.unité)
TablE_UMR_dedoublonnée = unique(Table_UMR, by='Code.Unité.au.31.12.2018')

# enlever les doublons (on ne garde que la 1ere ligne pour chaque combinaison Code.unité - regroupement)
# TablE_UMR_dedoublonnée = unique(Table_UMR, by=c('Code.Unité.au.31.12.2018','regroupement'))


# enlever les espaces
TablE_UMR_dedoublonnée[,Masse.salariale.CNRS.31.12.2018 := gsub(' ','',Masse.salariale.CNRS.31.12.2018)]
#rendre la variable numérique :
TablE_UMR_dedoublonnée[,Masse.salariale.CNRS.31.12.2018 := as.numeric(Masse.salariale.CNRS.31.12.2018)]
# Faire la somme
TablE_UMR_dedoublonnée[,.(sum(Masse.salariale.CNRS.31.12.2018))]

# remplacer les virgules par des points
TablE_UMR_dedoublonnée[,ETPT.CNRS.31.12.2018 := gsub(',','.',ETPT.CNRS.31.12.2018)]
#rendre la variable numérique :
TablE_UMR_dedoublonnée[,ETPT.CNRS.31.12.2018 := as.numeric(ETPT.CNRS.31.12.2018)]
# Faire la somme
TablE_UMR_dedoublonnée[,.(sum(ETPT.CNRS.31.12.2018))]

# enlever les espaces
TablE_UMR_dedoublonnée[,CréditsFEICNRS2018 := gsub(' ','',CréditsFEICNRS2018)]
#rendre la variable numérique :
TablE_UMR_dedoublonnée[,CréditsFEICNRS2018 := as.numeric(CréditsFEICNRS2018)]
# Faire la somme
TablE_UMR_dedoublonnée[,.(sum(CréditsFEICNRS2018))]


Table_dotations = TablE_UMR_dedoublonnée[,.(credits=sum(CréditsFEICNRS2018),masse_salariale=sum(Masse.salariale.CNRS.31.12.2018),ETPT=sum(ETPT.CNRS.31.12.2018)),by=.(type.d.unité)]

write.csv2(as.data.frame(Table_dotations),file='Dotations_par_type_dunite.csv',fileEncoding = "UTF8")

