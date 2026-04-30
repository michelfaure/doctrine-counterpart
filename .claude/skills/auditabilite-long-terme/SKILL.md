---
name: auditabilite-long-terme
description: Activer ce skill en fin de session significative (> 1h ou > 3 commits), à chaque création ou modification d'ADR, sur mention de "MEMORY", "doctrine", "audit", "trimestriel", "session log", "passation". Aussi quand une mémoire feedback est créée ou modifiée, quand un drift est documenté sans sonde associée, ou quand l'index MEMORY.md dépasse 200 lignes. Le skill impose la trace ADR pour décisions structurantes, le session log après session significative, l'audit trimestriel des mémoires, et le rappel que la doctrine s'applique à elle-même.
---

# Auditabilité long terme

La mémoire individuelle du solo est insuffisante. L'archive — ADR, sessions log, MEMORY.md, doctrine elle-même — est l'organe externe qui le tient, à condition d'être elle-même auditée régulièrement. Sans cet axe, les six autres se dissolvent dans l'oubli.

## ADR pour décisions structurantes

**Toute décision structurante** (cf. skill *adversarialite-bidirectionnelle*) doit être archivée comme ADR (Architecture Decision Record) dans `docs/adr/NNNN-titre.md`.

Format minimal :

```markdown
# ADR-NNNN — [titre court]

Date : YYYY-MM-DD
Statut : proposé / accepté / déprécié / contredit par ADR-XXXX

## Contexte
## Décision
## Alternatives écartées
## Conséquences
## Références
```

Git history répond à *quoi a été changé* — pas à *pourquoi*. L'ADR archive le pourquoi que git log perd. Sans ADR, le pourquoi reste dans la tête du solo, donc nulle part dehors, donc perdu.

## Session log après session significative

Après chaque session **> 1h ou > 3 commits**, produire un fichier `docs/sessions/YYYY-MM-DD_titre.md` (ou équivalent dans la convention du projet).

Format minimal :

```markdown
# YYYY-MM-DD — [titre]

## Ce qui a été livré
[commits, fichiers, ADRs]

## Ce qui a marché
[3 lignes]

## Ce qui a foiré ou surpris
[3 lignes]

## Ce que je veux essayer la prochaine fois
[bullets]
```

Capture à chaud, pas littéraire. Le pattern émerge des relectures, pas de la session unique.

## MEMORY.md — index ≤ 200 lignes

Tenir un fichier index à la racine (`MEMORY.md` ou équivalent) avec :

- **Une ligne par mémoire**, format : `- [titre](fichier.md) — hook une-phrase < 150 chars`
- Détail dans des fichiers topiques séparés
- **Limite stricte 200 lignes** — au-delà, Claude Code tronque silencieusement

Si l'index dépasse 200 lignes : refactor obligatoire. Archiver les sessions > 6 jours dans un `sessions/INDEX.md`. Déplacer le détail des projets dans des fichiers dédiés.

## Mémoire feedback associée à un drift = sonde obligatoire

**Toute mémoire feedback qui documente un drift actif** doit pointer vers une sonde qui le confirme (script SQL, cron audit, alerting). Sans sonde, la mémoire pourrit silencieusement.

Cas type : mémoire dit « drift sur statuts échéances actif depuis le 26/04 ». À J+3, sonde dit 0 écart. La mémoire est stale et doit être supprimée ou requalifiée. Sinon, elle continue de biaiser les décisions futures.

Règle : *toute mémoire feedback sur un drift actif doit pointer vers une sonde qui le confirme, sinon elle pourrit*.

## Audit trimestriel obligatoire

**Tous les 3 mois** : relire l'index MEMORY.md ligne à ligne, demander pour chaque entrée « est-ce toujours vrai ? ».

Calendariser de façon récurrente :

```
Calendar : 1er dimanche du trimestre, 1h
Action : audit MEMORY.md ligne à ligne + relire ADRs récents + signaler les périmés
```

Le coût : 1h par trimestre. Le bénéfice : une mémoire qui reste un actif au lieu de pourrir.

## Critère de péremption ADR

**ADR avec > 30 % de péremption à 12 mois** = doctrine à requalifier en *recherche en cours*, pas un cadre stable.

Audit annuel : pour chaque ADR de plus de 12 mois, classer :
- **Encore valide** : la décision tient, les conséquences se sont vérifiées
- **Partiellement obsolète** : certaines parties sont périmées, garder en partie
- **Contredit par ADR ultérieur** : référencer le contrediseur, marquer statut
- **Abandonné** : la décision n'a jamais été appliquée ou a été reversée

Si > 30 % en obsolète + contredit + abandonné, c'est que le domaine est encore en exploration — éviter de présenter le corpus ADR comme « doctrine du projet ».

## La doctrine s'applique à elle-même

**Une doctrine qui se croit hors-temps trahit son propre principe d'auditabilité.** Cette doctrine Counterpart est versionnée (v0.1, v0.2, etc.) et auditée comme un ADR.

Conséquence pratique : à chaque mise à jour de la doctrine, ouvrir un changelog dans `doctrine.md` :

```markdown
## Changelog

### v0.2 (YYYY-MM-DD)
- Ajout du skill X suite au retour de Y
- Reformulation axe Z après incident A
- Question ouverte 4 résolue par hypothèse B testée 6 semaines

### v0.1 (YYYY-MM-DD)
- Première version
```

## Bus factor du solo IA-natif

L'archive (ADR + sessions + MEMORY + doctrine) sert aussi de **dossier de passation** implicite : si le solo s'arrête (vacances, maladie, accident), un autre praticien qui charge la doctrine et lit les archives peut reprendre.

Tester périodiquement : « si je m'arrêtais demain, qu'est-ce qu'un autre dev solo qui ouvre ce repo pourrait reprendre en 30 jours ? ». Si la réponse est « rien sans moi », la doctrine n'est pas encore appliquée correctement.

## Checklist fin de session

- [ ] Si décision structurante : ADR rédigé
- [ ] Si session > 1h ou > 3 commits : session log créé
- [ ] Si nouvelle mémoire feedback : pointer vers sonde si drift
- [ ] Si nouveau pattern récurrent identifié : capturer en règle ou skill
- [ ] MEMORY.md à jour, < 200 lignes
- [ ] Si fin de trimestre : audit mémoire planifié

## Checklist trimestrielle

- [ ] MEMORY.md relu ligne à ligne
- [ ] Mémoires stale supprimées ou requalifiées
- [ ] Sondes vérifiées (les drifts documentés sont-ils encore actifs ?)
- [ ] ADRs > 12 mois audités (encore valide / périmé / contredit)
- [ ] Doctrine elle-même : besoin de v0.X+1 ?
