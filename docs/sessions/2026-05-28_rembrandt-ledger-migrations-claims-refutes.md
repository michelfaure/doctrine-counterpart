# Session 2026-05-28 — Audit ledger migrations rembrandt : trois claims réfutés par sonde matérielle

## Contexte

Substrat rembrandt (Next.js/Supabase), distinct du dogfooding doctrine. Alerte de la sonde `sonde_migrations_doublon_timestamp` (ADR-0039 Rembrandt) : doublon de préfixe horodatage `20260527200000` (enum ADR-0084 + vue ADR-0085). Le fix immédiat a ouvert un audit du découplage archive locale `supabase/migrations/` ↔ ledger remote `supabase_migrations.schema_migrations`, puis un ADR-0087 (stratégie ledger) et un test sur branche preview Supabase. Session révélatrice non par son livrable mais par le **nombre de claims que j'ai posés puis dû réfuter matériellement**.

## Réalisé (côté rembrandt, hors ce repo)

- 3 commits poussés sur `main` rembrandt : `be81c31` + `0bc0dee` (fix collision : rename vue `200000`→`190000`), `935f7c0` (ADR-0087).
- Test branche preview Supabase (`<branch-ref>`, créée puis supprimée, ~0,01 $) → `MIGRATIONS_FAILED`.
- Mémoire user-scope `feedback_migration_ledger_replay_casse_dr_pgdump.md` + index MEMORY.md.

## Décisions tranchées

1. **Pas de nouveau re-baseline (Option A).** Il a déjà été fait une fois (chantier #15, baseline 2026-05-01 + 178 stubs no-op) ; la DR repose sur pg_dump (`test-restore.yml`), indépendante du ledger ; le bénéfice d'un re-baseline est ergonomique (`migration list` propre, `db push` utilisable), pas sécuritaire ; risque prod non nul. Recommandé **Option C** (formaliser l'archive + corriger la cause racine timestamp + garde-fou anti-`db push` prod).
2. **Priorité zéro = débloquer la facturation GitHub Actions**, qui a stoppé `backup-db.yml` (DOWN depuis 26/05) et menace `test-restore.yml`. Ne rien toucher au schéma prod tant que le filet DR n'est pas vert.

## Apprentissages méthodo

1. **R2 + R5 — trois de mes claims réfutés par sonde, dans une même session :**
   - *« La CI rejoue les migrations (`supabase start`) et c'est vert. »* → `gh run list` : CI rouge depuis le **16/04**, jobs bloqués par facturation depuis le 26/05. La rejouabilité locale n'était pas prouvée du tout.
   - *« La DR est déjà couverte, donc minimiser le risque de l'Option A. »* → vrai jusqu'au 24/05, mais `test-restore`/`backup-db` étaient **en train de tomber** (facturation). Le filet que j'invoquais pour minimiser un risque était lui-même hors service. Leçon : un argument « c'est couvert par X » exige de vérifier que X **tourne maintenant**, pas qu'il existe.
   - *« Le hook pre-commit a déstagé la suppression. »* → `ls .husky/ .git/hooks/` : **aucun hook pre-commit**. La cause était fausse. La vraie cause du de-staging reste **inconnue** — je ne la connais toujours pas, et c'est l'aveu honnête.

2. **R1 s'applique à une CAUSE, et un message de commit est un artefact soumis à R1.** J'ai exigé une preuve pour « build green » mais laissé passer une **cause** (« le hook a fait X ») sans sonde — et je l'ai **gravée dans le message du commit `0bc0dee`** (déjà poussé, historique non réécrit). Pattern : toute affirmation causale « X parce que Y » dans un commit, une ADR ou un rapport exige la même sonde que « tests pass ». Une cause plausible non testée est une déclaration sans valeur probante, et le commit la rend permanente.

3. **La rigueur R4 du début ne se propage pas d'elle-même au milieu du raisonnement.** L'ouverture a bien suivi falsify-before-fix : hypothèse « collision formelle, pas l'incident archétypal », 3 sondes réfutant (lecture des 2 fichiers / `schema_migrations` remote / backfill+git). Mais les claims posés *en passant* plus tard (« CI verte », « DR couverte ») n'ont reçu aucune sonde jusqu'à ce qu'ils deviennent load-bearing. Écho à la session du 22/05 (claims faibles au close) : ici, claims faibles **en milieu d'analyse**. Le risque n'est pas qu'au close — c'est tout énoncé non sondé qu'on s'apprête à utiliser comme prémisse.

4. **Instance R6 multi-substrate : `create_branch` Supabase rejoue le LEDGER REMOTE (corps SQL figés à l'application), pas les fichiers locaux.** Le ledger remote est un *Cache* du schéma sans rafraîchisseur vis-à-vis des fichiers patchés. Preuve matérielle : `MIGRATIONS_FAILED` sur `snapshot_liste_rouge_pre_reclassement` — corps remote figé au 11/05 (`RAISE EXCEPTION` sur snapshot vide) alors que le fichier local a été patché le 25/05 (`RAISE WARNING`). La divergence local↔remote porte sur le **contenu**, pas que le timestamp. Toute voie de reconstruction par replay (branching, `db reset`) bute dessus ; seul pg_dump (schéma réel) y échappe.

## À suivre

- rembrandt : débloquer facturation Actions ; appliquer Option C (ADR-0087 §C.0→C.3).
- **Candidat doctrine (NE PAS promouvoir, N=1)** : étendre explicitement R1 aux **messages de commit / ADR** — une cause asserée dans un artefact permanent exige sa sonde dans le même artefact. À décanter, accumuler d'autres occurrences avant amendement. Distinct de R1 actuel qui vise les claims de chat (« build green »).

## Liens utiles

- ADR-0087 (rembrandt) : `~/rembrandt/docs/adr/0087-strategie-ledger-migrations.md`
- Commits rembrandt : `be81c31`, `0bc0dee` (contient la fausse cause), `935f7c0`
- Mémoire user-scope : `~/.claude/projects/-Users-michelfaure/memory/feedback_migration_ledger_replay_casse_dr_pgdump.md`

## Notes catch-up archive

0 session log untracked au start (repo `## main...origin/main`, propre). Ce log est ajouté propre. Substrat de la session = rembrandt ; ce repo n'enregistre que l'apprentissage méthodo transversal.
