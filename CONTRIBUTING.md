# Contribuer à la Doctrine Counterpart

Cette doctrine est en v0.2 — sous test empirique. Les retours sont précieux et structureront la v0.3.

## Si tu testes la doctrine sur un projet

Le format de retour le plus utile suit les **trois questions du README** :

**(a) Qu'as-tu effectivement chargé / utilisé ?**

CLAUDE.md complet ou partiel, skills déclenchés, agent challenger invoqué, hooks activés ou non, doctrine.md lu en entier ou en partie.

**(b) Qu'est-ce qui a changé concrètement dans ta pratique ?**

Une décision qui aurait été prise différemment, un bug évité, une friction inutile, le ressenti net (notable / marginal / négatif).

**(c) Quels axes peux-tu nommer sans relire ?**

Test critique d'intégration : si la réponse est faible (1-2 axes après 3 semaines), le format chargeable a une limite intrinsèque qu'il faudra adresser en v0.3.

## Format des retours

- **Issue GitHub** sur ce repo, tag `feedback-test-v0.2`
- **Commentaire Dev.to** sous l'article *Appel au test*
- **Email** à l'adresse indiquée sur le profil GitHub

Pas de format imposé. Trois paragraphes suffisent. Les retours bruts (audio transcrit, voix, notes) sont bienvenus — la rédaction soignée n'est pas nécessaire.

## Si tu repères un bug ou une exposition

- **Bug dans un hook bash** : ouvrir une issue avec sortie brute du hook + commande qui a déclenché.
- **Faille de sécurité** (token exposé, regex secret-scanner trop laxe ou trop stricte) : email privé en priorité, puis issue publique après fix.
- **Anonymisation manquée** (un nom propre réel, un identifiant interne qui aurait survécu à l'audit) : signalement immédiat par email privé. Sera corrigé sans question.

## Si tu veux proposer un patch

Pull requests bienvenues, mais préférer pour cette v0.2 les **issues de discussion** d'abord. La doctrine est encore en formation — un patch isolé peut entrer en tension avec une refonte plus large à venir.

Format PR utile :
- Titre court
- Description : quel axe / quel skill / quelle règle est touchée
- Justification : un cas concret qui a motivé le patch
- Test si applicable

## Critique de fond

La doctrine refuse explicitement quatre positions dominantes (cf. `doctrine.md` — section position du texte). Les critiques sur ces choix sont les plus précieuses :

- *AI as counterpart* est-il vraiment supérieur à *AI as tool* / *AI as colleague* dans ton expérience ?
- L'adversarialité bidirectionnelle est-elle praticable, ou trop coûteuse cognitivement ?
- La taxonomie Live/Snapshot/Cache est-elle utile ou over-engineered pour un solo ?
- L'auditabilité long terme tient-elle, ou pourrit-elle en pratique malgré les invariants ?

Ces questions structureront la v0.3.

## Six questions ouvertes

Cf. fin de `doctrine.md`. Toute donnée empirique, témoignage ou argument qui éclaire l'une de ces six questions ouvertes accélèrera leur résolution :

1. Quel est le bon dispositif d'adversarialité bidirectionnelle ?
2. Quel critère quantitatif de péremption d'un ADR ?
3. Où s'arrête la transversalité, où commence la délégation à l'expert ?
4. Comment doser la friction pédagogique ?
5. Comment adresser le bus factor du solo IA-natif ?
6. Quelle est la forme d'adoption opérante de la doctrine ?

---

*v0.2 — sous licence CC-BY-4.0 — Michel Faure*
