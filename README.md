# Doctrine Counterpart

> Une stack qui empêche Claude Code de te mentir. Pour les dev solos qui codent en prod sans PR reviewer humain.

## Le problème

Tu codes seul avec Claude Code sur un projet non-trivial. Probablement, ce mois-ci :

- Claude t'a dit « build vert, on push » alors que CI était rouge sur des tests préexistants — et tu l'as cru sans demander la sortie brute.
- Tu as accepté un fix qui « semblait corriger le bug ». Le bug est revenu six jours plus tard sous un autre visage, et tu avais oublié l'avoir déjà rencontré.
- Tu as ajouté une colonne dérivée à ta DB, jamais rafraîchie, qui drift maintenant en silence sans qu'aucune sonde te le dise.
- Tu as relancé Claude par « es-tu sûr ? » et il a changé d'avis sans t'apporter aucun fait nouveau.

Pas de PR reviewer humain pour rattraper. Pas de pair pour challenger. Cette stack adresse exactement ces patterns.

## Effets visibles dès la 1ʳᵉ session

Une fois la stack installée, voici ce que tu observes immédiatement :

- Tu écris « build vert » à Claude → Claude exige `tsc --noEmit` + sortie brute dans le même message avant de valider.
- Tu commits un message contenant `fix`/`hack`/`workaround` sans assomption → un hook bloque le commit et exige `[rustine-assumee]` ou une référence ADR.
- Tu pousses sur `main` sans `[deploy-ok]` dans le dernier commit → bloqué, force la re-vérification consciente.
- Tu ajoutes une colonne dérivée (`montant_total`, `nb_actifs`, etc.) → un skill auto-invoqué exige la catégorie Live / Snapshot / Cache et le rafraîchisseur dans le même commit.
- Tu poses une décision structurante (ADR, pattern, bascule modèle) → tu peux invoquer un agent-challenger qui produit objections + tests empiriques + confiance 0-10.
- Tu commits un fichier contenant un secret en clair (clé API, token, JWT) → bloqué, sauf bypass `[secret-ok]` explicite.
- Tu rouvres Claude Code après 90 jours sans audit mémoire → rappel automatique au démarrage de session.

Sept invariants matériellement enforced. Pas de discipline à tenir mentalement — la stack le fait pour toi.

## Installation

```bash
git clone https://github.com/michelfaure/doctrine-counterpart.git
cd doctrine-counterpart
./install.sh /chemin/vers/ton/projet
```

Le script est interactif : il copie `CLAUDE.md` (avec choix de fusion si tu en as déjà un), installe les 7 skills + l'agent challenger, te demande si tu veux activer les 4 hooks d'enforcement matériel.

Pré-requis pour les hooks : `jq` (`brew install jq` sur macOS).

Désinstallation : supprimer `CLAUDE.md` et le répertoire `.claude/` du projet cible. Aucun effet de bord persistant ailleurs.

## Architecture — stack à 4 niveaux

| Couche | Fichier | Effet | Activation |
|---|---|---|---|
| Humain | `doctrine.md` | Cadre intellectuel, à lire pour comprendre | Lecture |
| Prior agent | `CLAUDE.md` | Oriente Claude Code dès le démarrage de session | Auto |
| Règles activables | 7 skills + agent challenger dans `.claude/` | Auto-invoqués sur triggers (keywords précis) | Auto / manuel pour challenger |
| Enforcement matériel | 4 hooks bash dans `.claude/hooks/` | Bloquent commit/push si invariants violés | Optionnels, activés via `install.sh` |

**Sans les hooks**, la stack oriente sans contraindre — Claude peut suivre les règles ou les oublier sous pression de longueur de contexte.

**Avec les hooks**, certains invariants critiques (palliatif assumé, deploy explicite, secrets, audit mémoire) deviennent matériellement enforced. Tous les hooks ont un mécanisme de bypass explicite documenté dans leurs scripts. Ils ne modifient jamais le code silencieusement — ils bloquent ou avertissent uniquement.

## Les 7 axes opérants

Cf. `doctrine.md` pour la prose intégrale. En une ligne par axe :

1. **Vérification matérielle** — toute affirmation d'un agent est présumée fausse jusqu'à matérialisation de la preuve dans le même message.
2. **Adversarialité bidirectionnelle** — agent et solo sont tous deux complaisants ; la décision robuste se fabrique par protocole tiers, pas par dialogue mou.
3. **Taxonomie de la donnée** — Live / Snapshot / Cache obligatoire pour toute valeur stockée dérivable. Drift silencieux interdit.
4. **Discipline de session** — ADR avant code, phase 0 grep exhaustif, FIFO chantiers, calendar event d'auto-validation post-deploy.
5. **Cause racine, pas rustine** — palliatif légitime *à condition d'être assumé* ; palliatif silencieux interdit.
6. **Pédagogie implicite et transversalité métier** — apprendre en faisant, vocabulaire métier régulé, pas de prix sans obligation citée.
7. **Auditabilité long terme** — ADR + sessions log + MEMORY index + audit trimestriel obligatoire. La doctrine s'applique à elle-même.

## Concept central

*AI as counterpart* — ni outil (verticalité maître-instrument), ni collègue (horizontalité naïve anthropomorphique), mais **partenaire d'un dispositif hybride où chaque acteur forme l'autre**. Le solo forme l'agent par mémoire, ADR, feedback, doctrine. L'agent forme le solo par questions, challenges, méthodologie imposée, transmission de compétences techniques. Asymétrie productive, pas symétrie.

Pour le développement intellectuel : `doctrine.md`.

## Test demandé

Cette doctrine est en **v0.2**. Elle n'a pas été testée empiriquement à grande échelle avant cette publication — c'est précisément le test. Si tu installes, j'attends ton retour sous 2-3 semaines, format libre, via Issue GitHub ou commentaire DEV.to.

Trois questions ciblées (cf. `CONTRIBUTING.md` pour le format détaillé) :

**(a) Qu'as-tu effectivement chargé / utilisé ?**
CLAUDE.md complet ou partiel, quels skills déclenchés, agent challenger invoqué ou non, hooks activés, doctrine.md lu en entier ou en partie.

**(b) Qu'est-ce qui a changé concrètement dans ta pratique ?**
Une décision prise différemment ? Un bug évité ? Une friction inutile ? L'effet est-il *notable*, *marginal*, ou *négatif* ?

**(c) Quels axes peux-tu nommer sans relire ?**
Sans rouvrir le fichier — combien des 7 axes peux-tu lister ? Ce critère mesure si la doctrine a été **intégrée** (tu y penses spontanément) ou seulement **consultée**. C'est le test le plus important.

Trois paragraphes suffisent.

## Honnêteté du livreur

- v0.2 non validée empiriquement à grande échelle avant publication.
- Efficacité forte attendue sur axes 1, 3, 5 (règles claires, triggers déclenchables). Plus variable sur 2, 4, 6. Différée sur 7 (utilité visible à 6+ mois).
- Six questions ouvertes restent à trancher (cf. fin de `doctrine.md`). Ton retour peut faire évoluer chacune.
- Si la doctrine ne marche pas pour toi, dis-le. Le retour négatif est plus utile qu'un silence poli.

## Licence

[CC-BY-4.0](LICENSE) — usage, modification et redistribution libres avec attribution.

Format de citation suggéré :

> Faure, M. (2026). *Doctrine Counterpart — manifeste pour le dev solo IA-natif*.
> Disponible sous CC-BY-4.0 sur https://github.com/michelfaure/doctrine-counterpart

## Liens

- Manifeste intégral : [`doctrine.md`](doctrine.md)
- Format de retour : [`CONTRIBUTING.md`](CONTRIBUTING.md)
- Licence : [`LICENSE`](LICENSE)

---

*Michel Faure — avril 2026*
