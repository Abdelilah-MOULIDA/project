'
chercher des criteres de resemblance qui me feraient donner B plutot que A a ceux qui ont plus beneifice de B que de A.
comment trouver une regle qui me permettent de montrer en choississant B plutot que A pour ceux pour qui B a bien marche.
'
set.seed(2017)

'libraries'
library(broom)
library(ggplot2)
library(forestmodel)
library(carData)
library(effects)
library(questionr)
library(ggeffects)
library(cowplot)

'generer un exemple de donnees d\'essai clinique  qui me permetterait de montrer ce qu\'est la medecine personalisee'

'appel d\'un fichier où on a fait des calculs pour l\'anlyse des donnees'
source("/Users/abdelilahmoulida/Desktop/project/myheadercode.R")

'(*) analyse des variables simuler'
'représentation graphique d’un tableau croisé'
tab = table(DATA$Gender, DATA$Smoke)
dimnames(tab)[[1]] = c("Femme", "Homme")
dimnames(tab)[[2]] = c("Non fumeur", "Fumeur")
tab
par(mfrow = c(1,1))
mosaicplot(tab, main = "distribution genre par smoke", color = 1:3)

'boite à moustache'
par(mfrow = c(1,2))
boxplot(formula = DATA$Before ~ DATA$Gender, main = "Avant : EDSS par Genre", xlab = "Genre", ylab = "edss" )
boxplot(formula = DATA$Before ~ DATA$Smoke, main = "Avant : EDDS par Smoke", xlab = "Smoke", ylab = "edss" )
par(mfrow = c(1,2))
boxplot(formula = DATA$After ~ DATA$Gender, main = "Apres : EDSS par Genre", xlab = "Genre", ylab = "edss" )
boxplot(formula = DATA$After ~ DATA$Smoke, main = "Apres : EDDS par Smoke", xlab = "Smoke", ylab = "edss" )

'test de correlation entre les variables, Test de chisq'
chisq.test(tab)
chisq.residuals(tab)

'edss frequence comparaison'
aftpl = ggplot(aes(x = DATA$After), data = DATA) + geom_bar(fill = 'royalblue2')+coord_flip() + xlab("EDSS") + 
  ggtitle("Frequence des valeurs edss AVANT") 
befplt = ggplot(aes(x = DATA$After), data = DATA) + geom_bar(fill = 'red')+coord_flip() + xlab("EDSS") +  
  ggtitle("Frequence des valeurs edss APRES")
plot_grid(aftpl, befplt)

'frequence du edss avant et apres(A/B)'
colnames(Baseedssfrequency)=c("Baseline-edss","frequence")
colnames(Aedssfrequency)=c("A-edss","frequence")
colnames(Bedssfrequency)=c("B-edss","frequence")
Baseedssfrequency
Aedssfrequency
Bedssfrequency
baseedss = ggplot(data = Baseedssfrequency, mapping = aes(x = Baseedssfrequency$`Baseline-edss`, y = Baseedssfrequency$`frequence`)) +
  geom_point(alpha = 0.9, color = "red") + xlab("edss") + ylab("frequence") + ggtitle("Frequence edss dans Base")
aedss = ggplot(data = Aedssfrequency, mapping = aes(x = Aedssfrequency$`A-edss`, y = Aedssfrequency$`frequence`)) +
  geom_point(alpha = 0.9, color = "green") + xlab("edss") + ylab("frequence") + ggtitle("Frequence edss dans A")
bedss = ggplot(data = Bedssfrequency, mapping = aes(x = Bedssfrequency$`B-edss`, y = Bedssfrequency$`frequence`)) +
  geom_point(alpha = 0.9, color = "blue") + xlab("edss") + ylab("frequence") + ggtitle("Frequence edss dans B")
plot_grid(baseedss, aedss, bedss)

'etat des patients par rapport au debut et apres avoir le traitement eu A ou B'
'patients eu debut "Baseline"'
par(mfrow=c(1,3))
table(Basepatient_state)
mosaicplot(table(Basepatient_state), main = "Etat des patients au debut", xlab = "Etats")

'patients qui ont eu le taitement A'
'pour les patients qui ont eu le traitement sont dans un état moyen : 294 patients de 350 en totale'
table(Apatient_state)
mosaicplot(table(Apatient_state), main = "Etat des patients eu traitement A", xlab = "Etats")

'pour les patients qui ont eu le traitement B sont dans un état moyen et critique avec un nombre important 
de 8 patients qui sont dans le risque de mourir'
table(Bpatient_state)
mosaicplot(table(Bpatient_state), main = "Etat des patient eu traitement B", xlab = "Etats")

'classification de la gravite de la maladie par Gender(Homme/Femme) en se basant sur l\'edss'
'pour les patients qui ont eu le traitement A et ceux qui ont eu B'
par(mfrow = c(1,2))
Aseverity_by_sexe
Bseverity_by_sexe
matplot(y = Aseverity_by_sexe, type = 'l', lty = 1, xlab = "edss", ylab = "count", main = "Traitement A")
legend("topleft",legend=c("Homme","Femme"),col=c("green", "blue"), lty=1, cex=0.3, box.lwd=0, text.font = 2)
matplot(y = Bseverity_by_sexe, type = 'l', lty = 1, xlab = "edss", ylab = "count", main = "Traitement B")
legend("topleft",legend=c("Homme","Femme"),col=c("green", "blue"), lty=1, cex=0.36, box.lwd=0, text.font = 2) 

'classification de la gravite de la maladie par Smoke(Fumeur/Non Fumeur) basant sur l\'edss'
'pour les patients qui ont eu le traitement A et ceux qui ont eu B'
par(mfrow = c(1,2))
Aseverity_by_smoke
Bseverity_by_smoke
matplot(y = Aseverity_by_smoke, type = 'l', lty = 1, xlab = "edss", ylab = "count", main = "Traitement A")
legend("topleft",legend=c("Fumeur","Non fumeur"),col=c("green", "blue"), lty=1, cex=0.25, box.lwd=0.0, text.font = 2)
matplot(y = Bseverity_by_smoke, type = 'l', lty = 1, xlab = "edss", ylab = "count", main = "Traitement B")
legend("topleft",legend=c("Fumeur","Non fumeur"),col=c("green", "blue"), lty=1, cex=0.3, box.lwd=0.0, text.font = 2)

'classification de la gravite de la maladie par Gender et Smoke en se basant sur l\'edss'
'pour les patients avant et apres avoir eu le traitement A ou B'
Baseseverity_by_sexe_smoke
Aseverity_by_sexe_smoke
Bseverity_by_sexe_smoke

'(**) regression logistique sur les patient qui ont eu le traitement A'
DATA$getATreatment = ifelse(DATA$getATreatment == "Oui", 1, 0)

'a, determination du bon modele'
'AIC, 969.23'
modelA = glm(formula = DATA$getATreatment ~ after + gender + smoke, family = binomial(logit), data = DATA)
summary(modelA)

'odds ratio (rapports des cotes), l’odds ratio diffère du risque relatif. Interprétation des odds ratio : 
(.) odds ratio de 1 signifie l’absence d’effet.
(.) odds ratio largement supérieur à 1 correspond à une augmentation du phénomène étudié.
(.) odds ratio largement inféieur à 1 correspond à une diminution du phénomène étudié.'

'la fonction odds.ratio permet de calculer directement les odds ratios, leur intervalles de confiance et les p-value :'
odds.ratio(modelA)

'pour savoir si un odds ratio diffère significativement de 1 (ce qui est identique au fait que le coefficient soit différent 
de 0), on pourra se référer à la colonne Pr(>|z|) obtenue avec summary'

'b, représentation graphique du modèle'
'representation graphique des odds ratios, ici on utilise la fonction tidy de pour récupérer les coefficients du modèle sous la 
forme d’un tableau de données exploitable avec ggplot2, avec : 
(.) conf.int = TRUE pour obtenir les intervalles de confiance.
(.) exponentiate = TRUE pour avoir les odds ratio plutôt que les coefficients bruts.
(.) geom_errorbarh permets de représenter les intervalles de confiance sous forme de barres d’erreurs.
(.) geom_vline une ligne verticale au niveau x = 1.
(.) scale_x_log10 pour afficher l’axe des x de manière logarithmique, les odds ratios étant de nature multiplicative et non 
additive.'
tmp = tidy(modelA, conf.int = TRUE, exponentiate = TRUE)
str(tmp)

ggplot(tmp) + aes(x = estimate, y = term, xmin = conf.low, xmax = conf.high) + 
  geom_vline(xintercept = 1) + geom_errorbarh() + geom_point() + 
  scale_x_log10() + ggtitle("odds ratio : modele du traitement A")

' représentation visuelle et tabulaire des coefficients'
forest_model(modelA)

'c, représentation graphique des effets'
'représentation graphique résumant les effets de chaque variable du modèle'
plot(allEffects(modelA))

'nous pouvons alternativement avoir recours à l’extension ggeffects, la fonction ggeffect, quand on lui précise un terme 
spécifique, produit un tableau de données avec les effets marginaux pour cette variable : edss, gender, smoke'
ggeffect(modelA, "after")
ggeffect(modelA, "gender")
ggeffect(modelA, "smoke")

'ggplot2 de l’effet en question'
cowplot::plot_grid(plotlist = plot(ggeffect(modelA)))

'd, matrice de confusion'
'matrice de confusion permet de tester une manière de tester d’un modèle, c’est-à-dire le tableau croisé des valeurs observées 
et celles des valeurs prédites en appliquant le modèle aux données d’origine, la méthode predict avec l’argument type="response"
permet d’appliquer notre modèle logistique à un tableau de données et renvoie pour chaque individu la probabilité qu’il ait vécu
le phénomène étudié'
predictionA = predict(modelA, type = "response", newdata = DATA)
predictionA

'la matrice de confusion est alors égale à :'
'nous avons donc 324(168+156) prédictions incorrectes sur un total de 700, soit un taux de mauvais classement de 46,28 %'
table(predictionA > 0.5, DATA$getATreatment)

'e, identification des variables ayant un effet significatif sur le modele'
'pour tester l’effet global sur un modèle, on peut avoir recours à la fonction drop1, cette dernière va tour à tour supprimer 
chaque variable du modèle et réaliser une analyse de variance (ANOVA) pour voir si la variance change significativement'
drop1(modelA, test="Chisq")

'f, sélection de modèles'
'pour déterminer la qualité d’un modèle, l’un des critères les plus utilisés est le Akaike Information Criterion ou AIC, plus 
l’AIC sera faible, meilleure sera le modèle. La fonction step permet justement de sélectionner le meilleur modèle par une 
procédure pas à pas descendante basée sur la minimisation de l’AIC, la fonction step affiche à l’écran les différentes étapes de
la sélection et renvoie le modèle final'
modelA2 = step(modelA)
AIC(modelA)
AIC(modelA2)

'effectuons une analyse de variance ou ANOVA pour comparer les deux modèles avec la fonction anova'
anova(modelA, modelA2, test = "Chisq")

'(***) regression logistique sur le traitement B'
DATA$getBTreatment = ifelse(DATA$getBTreatment == "Oui", 1, 0)

'a, determination du bon modele'
'AIC, 969.23'
modelB = glm(formula = DATA$getBTreatment ~ after + gender + smoke, family = binomial(logit), data = DATA)
summary(modelB)

'odds ratio (rapports des cotes), l’odds ratio diffère du risque relatif. Interprétation des odds ratio : 
(.) odds ratio de 1 signifie l’absence d’effet.
(.) odds ratio largement supérieur à 1 correspond à une augmentation du phénomène étudié.
(.) odds ratio largement inféieur à 1 correspond à une diminution du phénomène étudié.'

'la fonction odds.ratio permet de calculer directement les odds ratios, leur intervalles de confiance et les p-value :'
odds.ratio(modelB)

'pour savoir si un odds ratio diffère significativement de 1 (ce qui est identique au fait que le coefficient soit différent 
de 0), on pourra se référer à la colonne Pr(>|z|) obtenue avec summary'

'b, représentation graphique du modèle'
'representation graphique des odds ratios, ici on utilise la fonction tidy de pour récupérer les coefficients du modèle sous la 
forme d’un tableau de données exploitable avec ggplot2, avec : 
(.) conf.int = TRUE pour obtenir les intervalles de confiance.
(.) exponentiate = TRUE pour avoir les odds ratio plutôt que les coefficients bruts.
(.) geom_errorbarh permets de représenter les intervalles de confiance sous forme de barres d’erreurs.
(.) geom_vline une ligne verticale au niveau x = 1.
(.) scale_x_log10 pour afficher l’axe des x de manière logarithmique, les odds ratios étant de nature multiplicative et non 
additive.'
tmp = tidy(modelB, conf.int = TRUE, exponentiate = TRUE)
str(tmp)

ggplot(tmp) + aes(x = estimate, y = term, xmin = conf.low, xmax = conf.high) + 
  geom_vline(xintercept = 1) + geom_errorbarh() + geom_point() + 
  scale_x_log10() + ggtitle("odds ratio : modele du traitement B")

' représentation visuelle et tabulaire des coefficients'
forest_model(modelB)

'c, représentation graphique des effets'
'représentation graphique résumant les effets de chaque variable du modèle'
plot(allEffects(modelB))

'nous pouvons alternativement avoir recours à l’extension ggeffects, la fonction ggeffect, quand on lui précise un terme 
spécifique, produit un tableau de données avec les effets marginaux pour cette variable : edss, gender, smoke'
ggeffect(modelB, "after")
ggeffect(modelB, "gender")
ggeffect(modelB, "smoke")

'ggplot2 de l’effet en question'
par(mfrow=c(2,1))
cowplot::plot_grid(plotlist = plot(ggeffect(modelB))) 

'd, matrice de confusion'
'matrice de confusion permet de tester une manière de tester d’un modèle, c’est-à-dire le tableau croisé des valeurs observées 
et celles des valeurs prédites en appliquant le modèle aux données d’origine, la méthode predict avec l’argument type="response"
permet d’appliquer notre modèle logistique à un tableau de données et renvoie pour chaque individu la probabilité qu’il ait vécu
le phénomène étudié'
predictionB = predict(modelB, type = "response", newdata = DATA)
predictionB

'la matrice de confusion est alors égale à :'
table(predictionB > 0.5, DATA$getBTreatment)

'nous avons donc 324(163+156) prédictions incorrectes sur un total de 700, soit un taux de mauvais classement de 46,28 %'

'e, identification des variables ayant un effet significatif sur le modele'
'pour tester l’effet global sur un modèle, on peut avoir recours à la fonction drop1, cette dernière va tour à tour supprimer 
chaque variable du modèle et réaliser une analyse de variance (ANOVA) pour voir si la variance change significativement'
drop1(modelB, test="Chisq")

'f, sélection de modèles'
'pour déterminer la qualité d’un modèle, l’un des critères les plus utilisés est le Akaike Information Criterion ou AIC, plus 
l’AIC sera faible, meilleure sera le modèle. La fonction step permet justement de sélectionner le meilleur modèle par une 
procédure pas à pas descendante basée sur la minimisation de l’AIC, la fonction step affiche à l’écran les différentes étapes de
la sélection et renvoie le modèle final'
modelB2 = step(modelB)
AIC(modelB)
AIC(modelB2)

'effectuons une analyse de variance ou ANOVA pour comparer les deux modèles avec la fonction anova'
anova(modelB, modelB2, test = "Chisq")

'(****) comparaison des edss avant/apres'
edss_compare()

'(*****) score des traitements on se basant sur la prediction de la regression'
score = 0
for(i in 1:350)
{
  score[i] = predictionA[i] * 100  
}
for(i in 351:700)
{
  score[i] = predictionB[i] * 100
}

DATA = data.frame(Treatment = treatment, Before = before, After = after, Difference = difference, 
  Gender = gender, Smoke = smoke, getATreatment = getATreatment, getBTreatment = getBTreatment,
  Score = score)

View(DATA)




