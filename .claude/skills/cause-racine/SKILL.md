---
name: cause-racine
description: Activer ce skill quand l'utilisateur ou un agent mentionne "fix", "bug", "patch", "rustine", "workaround", "hack", "quick fix", "palliatif", "contournement", "temporaire", ou propose une correction sur un symptôme observé. Aussi quand un cap arbitraire apparaît dans un commentaire (`// limite = X`, `// ne pas dépasser Y`), quand un test documente une exclusion comme intentionnelle, quand un fix paraît trop simple pour le symptôme. Le skill impose l'identification de la cause racine, l'élargissement du pattern, et l'assomption explicite de tout palliatif.
---

# Cause racine, pas rustine

Avant tout fix, identifier la cause racine. Un palliatif est légitime *à condition d'être explicitement assumé*. C'est l'absence d'assomption qui est interdite, pas le palliatif lui-même.

## Pipeline complet entrée → sortie

Quand un fix est proposé sur un bug, **avant d'accepter** : exiger le pipeline complet entrée → sortie.

```
Source de la donnée → query / sync / import →
transformation → stockage → query lecture → UI affichage
```

À quel niveau le bug apparaît-il vraiment ? Si l'agent corrige au niveau N alors que la cause est au niveau N-2, le fix est cosmétique et le bug reviendra avec un autre visage.

Cas type : un bug d'affichage UI qui est en fait une troncature PostgREST 1000 sur la requête source. Le fix sur le composant est inutile ; la cause est 4 niveaux plus haut.

## Quand un fix paraît trop simple

Si la complexité du fix est manifestement disproportionnée par rapport au symptôme observé : **c'est suspect**.

```
Symptôme : "le total affiche ~1 200 € au lieu de ~2 300 €"
Fix proposé : "UPDATE contacts SET montant_total = 2300 WHERE id = X"
```

Trop simple. La vraie question : pourquoi montant_total est-il stocké et désynchronisé ? Si la réponse est « champ non rafraîchi », le fix correct est de migrer la catégorie du champ (Live au lieu de Snapshot mal classé), pas de rectifier 1 ligne.

## Élargir avant d'agir

**1 cas confirmé d'un pattern → grep le pattern complet** en DB ou dans le code avant de corriger.

```sql
-- Si un cas isolé révèle "contact en liste_rouge alors qu'inscrit",
-- chercher tout le pattern :
SELECT * FROM contacts
WHERE statut = 'liste_rouge'
  AND id IN (SELECT contact_id FROM inscriptions WHERE statut = 'inscrit');
```

Cas type vécu : un cas signalé révèle 12 contacts touchés, pas 1. Sans élargissement, on « répare le cas signalé » et on laisse 11 dérives qui ressurgiront à la prochaine sync.

Le coût de l'élargissement = 1 requête SQL. Le ROI est massif.

## Cap arbitraire dans un commentaire

Quand un commentaire pose une contrainte (`// parallèle = OOM probable`, `// limite 200 séances`, `// max 5 retries`) : **traiter comme hypothèse à challenger**, pas comme fait acquis.

Surtout si daté de moins de 48h : la justification est probablement un bias palliatif de la session précédente, pas un constat empirique.

Quand le cap revient mordre dans un chantier suivant : creuser, ne pas accepter passivement.

## Drift identifié → ticket scopé

Sur diagnostic d'un objet manquant (table, fonction, trigger, migration non trackée) :

- **NE PAS** enchaîner les `IF NOT EXISTS` ou les `CREATE OR REPLACE` en cascade.
- **POSER** la question : « par quoi cet objet a-t-il été créé ? »
- Si la réponse est « migrations non trackées » ou « créé manuellement », c'est un drift large, pas une exception.
- **OUVRIR** un ticket scopé A/B/C/D avec hors-scope explicite, accepter CI rouge ou flag temporaire jusqu'à resync propre.

Le critère utile : si le 1er patch révèle un 2e objet manquant, c'est un drift, pas une exception. Stopper et formaliser.

## Palliatif assumé vs palliatif silencieux

Un palliatif est **légitime** à 4 conditions :

1. Commit message explicite : « palliatif », « rustine assumée », « TODO cause racine », ou tag `[rustine-assumee]`
2. Référence ADR ou mémoire feedback documentant la dette
3. Calendar event ou ticket pour la résolution propre
4. Pas de scope creep adjacent : le palliatif règle exactement le symptôme, pas plus

Un palliatif **silencieux** (sans ces 4 traces) = interdit. C'est une dette aveugle qui revient avec un visage différent.

## Refacto adjacent au prétexte du fix : interdit

Le scope du fix est strict. Si en lisant le code on identifie un autre problème : **noter dans une mémoire feedback ou ouvrir un ticket**, ne pas le corriger dans le même commit. Le scope creep dilue le diagnostic et empêche la review propre.

Exception : si le bug *est* dans le code adjacent et le fix nécessite la modification, alors elle entre dans le scope explicitement et est documentée comme telle.

## Règle dispersée → refacto + ADR

Quand un même invariant ou une même règle est dispersé dans plusieurs fichiers ou dans plusieurs niveaux (TS + DB + commentaires) : **refacto complet + ADR**, jamais option minimale qui « corrige juste où ça fait mal ».

Cas type : une constante `ANNEE_SCOLAIRE = '2025-2026'` hardcodée dans 5 fichiers TS. Le fix correct est de centraliser dans `lib/constants.ts` et migrer les 5 occurrences. Le fix minimal (corriger uniquement l'occurrence buguée) recrée le drift.

## Checklist avant d'accepter un fix

- [ ] Pipeline complet entrée → sortie présent dans la discussion
- [ ] Cause racine identifiée (pas seulement le symptôme)
- [ ] Pattern élargi (1 cas → grep complet)
- [ ] Si palliatif : 4 conditions ci-dessus respectées
- [ ] Pas de refacto adjacent silencieux
- [ ] Si drift d'objet : ticket scopé, pas patch en cascade
