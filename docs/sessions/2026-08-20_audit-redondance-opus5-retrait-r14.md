# 2026-08-20 — Audit de redondance Opus 5 : R14 tuée par falsification, Am.R4, et la prémisse retournée

## Contexte

Session ouverte sur une note de reprise self-contained : la doc de prompting d'Opus 5 affirme que les instructions de vérification explicites *causent* de la sur-vérification et qu'il faut les retirer. Le corpus en contient. Objectif annoncé : mesurer lesquelles retirer, lesquelles gardent leur valeur.

Sonde d'ouverture (R13/close v0.10) sur les 4 claims porteurs de la note. **(1)** Doc relue : les trois passages sont **verbatim inchangés**, la section *Task scope and over-verification* existe toujours — plus deux faits que la note ne portait pas : *« do not use subagents to verify or double-check your own work »* (touche R16 et la pratique multi-finder de R19), et les deux blocs de prompt que la doc recommande d'**ajouter** — scope, narration de correction — sont **déjà présents quasi-verbatim dans le system prompt du harnais**. **(2)** Modèle confirmé `claude-opus-5`. **(3)** Compteurs recomptés : 13 hooks / 4 skills / 2 rules user / 21 rules projet — inchangés. **(4)** Ledger dépouillé règle par règle.

Recadrage de MF en cours de session, qui a réorienté tout le reste : *« le nombre de token n'est pas l'enjeu, l'enjeu est de ne pas créer de sur-correction ou d'over-engineering »*.

## Réalisé

- **R14 RETIRÉE par falsification** (`53c369e`, poussé sur `main`). Sonde : `git log --grep='\[spike\]' --all` retourne **1 commit sur 152 jours de repo — celui qui a introduit la règle**. Zéro usage réel, contre `[autonomy-ack]` 9, `[review-ok]` 7, `[workaround-assumed]` 5 sur la même fenêtre. Sous death-watch R18 depuis le jour 60 ; tuée au jour ~150. **Première règle R1–R19 tuée par falsification et non par hygiène** — la classe que la relecture externe du 19/07 disait n'avoir jamais été démontrée.
- **Cascade du retrait, assumée** : **M6 meurt avec R14** (une métrique dont la règle est morte n'instrumente rien) ; anti-pattern *orphan spike* retiré (30 → 29) ; `[spike]` retiré des exceptions de R19 et de son corps. **Slot conservé, numéro jamais réutilisé** — R15–R19 sont ancrées dans les hooks, les skills et des ADR projet ; renuméroter aurait cassé des références pour économiser un chiffre.
- **Am.R4 — le fix d'un finding exige la phase-0 d'énumération**, pas seulement la falsification de l'hypothèse. N=10 : dix régressions produites par les correctifs de l'auteur sur quatre passes de review, surface paiement, signature commune — *un élément d'état partagé modifié sans ré-énumérer ses autres lecteurs et écrivains*.
- **Propagation aux surfaces vivantes** (le dépôt public est la moins opérante) : skill `challenger` → **étape 4bis** (énumérer écrivains, lecteurs, diff des gardes, écrire le compte) + **déclencheur élargi au fix de finding de review**, qui était le trou réel ; règle R19 user-scope → **cadence UNE passe par défaut** ; `~/CLAUDE.md` et le CLAUDE.md projet → « 19 règles » corrigé en 18 ; feedback du critère d'arrêt + index mémoire alignés ; 2 pointeurs de règles inversés corrigés dans le skill.
- **Entrée de journal au ledger** avec les sondes brutes, et **Artefact B** en tête du PILOTAGE-IA.

## Décisions tranchées

1. **R14 retirée**, pas requalifiée. Contre-argument pesé et écarté par MF : la règle avait une fonction non opérationnelle (rendre le corpus adoptable en montrant que le toolkit ne s'applique pas toujours) — ce motif est conservé dans le ledger, pas comme règle vivante.
2. **Ne pas renuméroter.** Le slot R14 reste, marqué RETIRED avec sa date et sa raison.
3. **Cadence de review : une passe par défaut.** La seconde se décide sur un fait constaté — une régression introduite, vue — jamais sur une boucle à faire converger.
4. **Ne pas brider la review en amont** (« only high severity ») : tout faire remonter et filtrer ensuite sur la gravité atteignable en production — ce que la doc recommande explicitement et ce que l'amendement du critère d'arrêt faisait déjà.
5. **Pas de bump de version.** Le cycle n'est pas clos (R5/R3 non tranchées, ledger non resynchronisé) : la cadence est datée « hors cycle de version » plutôt que faussement attribuée à une v0.12.
6. **Lot abandonné** : le déplacement du journal de la règle R19 hors des fichiers auto-chargés. Sa seule justification était le coût en tokens ; l'enjeu étant la sur-correction, le lot tombe avec sa justification.

## À suivre

- **Mesure à une passe sur la prochaine surface chaude** : compter les findings réels, estimer ce qu'une seconde aurait ajouté, consigner. La justification des finders multiples (angles disjoints → classes disjointes, 08/07) **date d'avant Opus 5 et n'a pas été refaite** → `[unverified]` sur le modèle courant. **Tant que cette mesure n'existe pas, la cadence à une passe est une décision, pas un fait établi.**
- **R5 et R3 non tranchées** — les deux seules règles restant dans la cible réelle de la doc : R5 double le natif quasi mot pour mot et ne porte **aucun incident daté** au ledger ; R3 n'a **jamais produit un N** (vérifié : aucune ligne de provenance dans sa section). Décision due.
- **Journal du ledger resynchronisé pour cette session seulement.** L'intervalle 20/07 → 20/08 reste non versé (mesuré : 12 session logs et 55 commits côté projet de référence sur la période).
- **Faux positif du hook de review, N=3 confirmé** : le déclencheur textuel ne distingue pas un *usage* d'une *mention*. Trois cas matériels en deux jours — un `DELETE` dans un corps de fonction (19/08), une mention en commentaire (20/08), et aujourd'hui **le texte de la règle qui définit le déclencheur** (2 × `SECURITY DEFINER` + 1 × `.sql` dans un diff 100 % markdown). Correctif non écrit ; modifier une garde est une proposition de code au sens d'Am.R4. `[unverified]` : l'hypothèse « une condition sur l'extension des fichiers du diff suffirait » n'a pas été sondée.
- **Index mémoire user-scope à ~21 Ko** contre un seuil de lecture annoncé à 24,4 Ko par le harnais, tandis que sa garde plafonne en *lignes* (162/200) et autoriserait ~39 Ko. Prompt de session dédié rédigé. `[unverified]` : aucune troncature n'a jamais été observée — seule la limite est annoncée.

## Apprentissages méthodo

**Le discriminant de la sur-correction est quantitatif, pas générique.** Une règle qui prescrit *combien de fois* ou *jusqu'à quand* se compose avec un modèle qui vérifie déjà et produit de la sur-correction ; une règle qui nomme *quoi regarder* ou *où le downside est cher* n'entre pas en composition — elle informe. L'inventaire de toutes les prescriptions chiffrées du corpus montre qu'elles sont presque toutes des seuils de déclenchement ou des plafonds, qui **restreignent** le champ : il ne restait que deux prescriptions faisant produire un volume fixe de vérification. Le corpus normatif était donc largement disculpé, et la sur-correction mesurée venait d'ailleurs.

**La dérive vit dans la couche d'usage, pas dans les règles.** La règle de review ne prescrit aucun nombre de passes ni d'angles ; ce sont les journaux de calibration (« review high, 3 finders », « 8 angles ») et un critère d'arrêt formulé en boucle qui ont produit quatre passes et dix régressions. Un journal d'incidents se relit comme une norme sans avoir jamais été promu norme — chercher la cérémonie dans les pratiques avant de la chercher dans le corpus.

**La redondance textuelle est un critère faible pour retirer.** Le cycle v0.10 avait rejeté un amendement « fix-of-finding » comme déjà couvert par le texte existant. Dix régressions plus tard, ce texte était lu comme *falsifie ton hypothèse* et jamais comme *ré-énumère les chemins*. Redondant sur le papier, absent au moment de décider — exactement la distinction sur laquelle repose l'arbitrage doc-vs-corpus.

**Écrire la règle au bon endroit ne suffit pas si le déclencheur ne l'atteint pas.** L'amendement a d'abord été porté dans le skill qui codifie la règle — lequel ne se déclenchait que sur « bug / fix / incident de production ». Un finding de review n'est ni l'un ni l'autre : la garde nommait son risque et le ratait. Vérifier le *déclencheur*, pas seulement le *contenu*, fait partie de la propagation.

**La surface publiée est la moins opérante de l'installation.** Le corpus publié n'est chargé que manuellement ; ce qui gouverne le comportement, ce sont les fichiers auto-chargés et les hooks. La session a failli se clore avec un dépôt public impeccable pendant que deux fichiers auto-chargés annonçaient encore le mauvais compte de règles. La phase-0 d'énumération d'une modification de doctrine commence par les hooks et les fichiers auto-chargés ; le dépôt vient en dernier.

**Un seuil chiffré qu'aucune mesure ne soutient est une prescription en attente.** Un « au-delà de deux ou trois sites, ça appelle un ADR » a été introduit dans le skill durci puis retiré le même jour : rien ne le mesurait, et un nombre inventé devient normatif à la relecture suivante. Application immédiate de la leçon que la session venait d'établir.

## Liens utiles

- Commit du retrait : `53c369e` — `doctrine: retire R14 by falsification, amend R4 with phase-0 enumeration`
- Guide de prompting Opus 5 (sections *Task scope and over-verification*, *Self-correction*, *Controlling subagent spawning*, puce *Code review*)
- `calibration-ledger.md` § Journal, entrée 2026-08-20
