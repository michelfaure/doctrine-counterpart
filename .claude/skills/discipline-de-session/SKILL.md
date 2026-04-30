---
name: discipline-de-session
description: Activer ce skill quand l'utilisateur ouvre un chantier multi-fichiers, mentionne "module", "spec", "refacto", "ADR", "architecture", "phase", "lot", "chantier", "feature", "implémentation", crée une nouvelle migration ou un nouveau template. Aussi sur "git push", "deploy", "production", quand un cron est créé ou modifié, et en début de session pour ouvrir un FIFO chantiers. Le skill impose ADR avant code, phase 0 grep exhaustif, lots de 5 lignes max, FIFO chantiers, trigger manuel post-deploy, cleanup avant push, calendar event d'auto-validation.
---

# Discipline de session

Le solo IA-natif structure le travail avant d'écrire, archive pendant qu'il travaille, ferme proprement avant d'enchaîner. La friction d'organisation économise des heures de rattrapage.

## ADR avant code

**Tout chantier > 2 fichiers** déclenche un ADR avant le premier commit.

Format minimal (1 page) :

```markdown
# ADR-NNNN — [titre court]

Date : YYYY-MM-DD
Statut : proposé / accepté / déprécié / contredit par ADR-XXXX

## Contexte
[1-2 paragraphes : pourquoi cette décision se pose]

## Décision
[1 paragraphe : ce qu'on choisit]

## Alternatives écartées
- [option A] — écartée parce que [...]
- [option B] — écartée parce que [...]

## Conséquences
- Positives : [...]
- Négatives ou dette : [...]

## Références
- [liens vers ADRs voisins, mémoires, sessions]
```

L'ADR sert d'oracle pendant l'implémentation : quand un détail UX hésite, retourner à l'ADR plutôt que rouvrir l'arbitrage.

## Phase 0 — grep exhaustif

**Avant toute spec d'un module nouveau ou d'un refacto > 2 fichiers** : grep exhaustif des symboles, assets, formats du domaine concerné.

```bash
# Exemple pour un module mail post-SD
grep -rn "email_post_sd\|emailPostSD\|calendrier" app/ lib/ --include='*.ts' --include='*.tsx'

# Exemple pour un nouveau format PDF
find app/api/emargement/ -name "*.tsx" -o -name "*.ts" | xargs head -20
```

Reporter l'existant *avant* de proposer du neuf. Si un module produit ou consomme l'asset déjà : brancher dessus, pas créer un slot parallèle.

## Lots de travail

Sur chantier pas-à-pas, **chaque lot doit pouvoir être validé par un récap court (3-5 lignes)**. Si le récap d'un lot déborde 5 lignes, le lot est trop gros — découper avant de poursuivre.

À chaque fin de lot :
- Récap 3-5 lignes (commits, fichiers touchés, prochaine étape)
- Question explicite « on enchaîne ? »
- Validation utilisateur avant lot suivant

## FIFO chantiers

**Pas plus de 3 chantiers ouverts en parallèle.** Ouvrir un nouveau = clore un ancien (livré, reporté, ou explicitement abandonné avec ADR).

En début de session, lister les chantiers ouverts. Si > 3, refuser d'en ouvrir un nouveau jusqu'à clôture explicite.

## Trigger manuel post-deploy

**Tout cron nouveau ou modifié** doit être triggé manuellement *avant* que le cron prenne le relais. Observer le digest réel, ajuster si faux positifs, *puis* laisser tourner.

```bash
# Exemple : trigger immédiat d'un cron audit-drift
curl -X POST https://app.../api/cron/audit-drift \
  -H "Authorization: Bearer $CRON_SECRET"
# Lire le digest Slack / log dans la minute qui suit
```

Sans ce trigger, on s'habitue à des faux positifs Slack 30 jours d'affilée avant de découvrir la mauvaise calibration.

## Cleanup avant push

**Avant tout `git push` multi-commits** : lancer ESLint + grep des morts + build, reporter la sortie brute.

```bash
npx eslint <fichiers touchés> 2>&1 | tail -20
grep -rn "TODO\|FIXME\|XXX" <fichiers touchés>
npm run build 2>&1 | tail -10
```

Si imports orphelins, fonctions mortes, ou warnings non documentés : nettoyer ou ouvrir un ticket explicite. Pas de cleanup silencieux ni de push sale.

## Calendar event d'auto-validation

Sur tout chantier dont **l'effet réel se mesure à J+1/J+2** (cron qui s'active demain, sync qui rafraîchit la nuit, deploy dont l'impact se voit en prod) : créer un calendar event ou rappel pour vérifier le résultat à la date attendue.

```
[Calendar] Demain 9h30 — Vérifier digest cron audit-drift,
           ajuster sonde 3 si faux positifs > 100
```

Le signal vient toujours plus tard que prévu, l'oubli vient toujours plus vite. Le calendar bloque le coût mental de la mémoire.

## Subagent en background quand scope verrouillé

Si un travail agent est bien cadré (audit + commits + push), l'invoquer en `run_in_background: true` libère la session principale pour orchestration ou doc. Condition : scope verrouillé, impossibilité d'ambiguïté. Sinon il faut être disponible pour ses questions.

## Ticket comme contexte cold portable

Pour les chantiers qui s'étalent sur plusieurs sessions, le ticket (issue GitHub, fichier docs/chantiers/, etc.) sert de **contexte cold portable**. Coût de rédaction : 10 min. Économie : 30-45 min de rebriefing en début de prochaine session.

Format ticket :
- Scope (A / B / C / D)
- Hors scope explicite
- Critères de réussite cochables
- Hypothèses ouvertes
- Prompt court à copier-coller pour ouverture de session

## Checklist début de chantier

- [ ] Chantier > 2 fichiers ? → ADR rédigé
- [ ] Phase 0 grep exhaustif fait
- [ ] Existant identifié, décision « réutiliser ou créer » prise
- [ ] Découpage en lots prévisualisé (récap < 5 lignes par lot)
- [ ] Si cron : trigger manuel post-deploy planifié
- [ ] Si effet J+1/J+2 : calendar event posé
- [ ] FIFO respecté (≤ 3 chantiers ouverts)
