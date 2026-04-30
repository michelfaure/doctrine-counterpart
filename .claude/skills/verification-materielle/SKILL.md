---
name: verification-materielle
description: Activer ce skill quand un agent ou l'utilisateur affirme "build vert", "tests passent", "CI vert", "drift", "contact introuvable", "tout est OK", "ça marche", ou retourne un chiffre/comptage destiné à être retransmis à un humain. Aussi sur diagnostic perf (EXPLAIN ANALYZE) et erreurs 400/422 sur webhooks externes. Le skill impose la production de la preuve matérielle dans le même message que l'affirmation.
---

# Vérification matérielle

Toute affirmation déclarative sur l'état du système est présumée fausse jusqu'à matérialisation de la preuve dans le même message.

## Règles d'application

### Build / CI / Tests

Sur affirmation « build vert / tests passent / CI vert » : produire la commande exécutée et sa sortie brute (les 20 dernières lignes minimum). Sans cela, ne pas affirmer.

```bash
# Exemple : vérifier build TypeScript
npx tsc --noEmit 2>&1 | tail -20
```

Pour CI GitHub :

```bash
gh pr view --json statusCheckRollup -q '.statusCheckRollup[] | select(.conclusion != "SUCCESS")'
```

### Chiffres et comptages

Tout chiffre retourné par un agent (« X contacts touchés », « tous les Y sont impactés », « drift généralisé ») doit être vérifié par requête SQL avant retransmission.

Pattern à appliquer :

```sql
-- Avant de dire "26 contacts ancien", vérifier :
SELECT COUNT(*) FROM contacts WHERE statut = 'ancien' AND ...;

-- Avant de dire "drift généralisé sur cours X", vérifier :
SELECT COUNT(*), COUNT(*) FILTER (WHERE contact_id IS NULL)
FROM emargements WHERE cours_id = '...';
```

Reporter le chiffre vérifié, pas le chiffre affirmé. Si écart, corriger.

### Performance — EXPLAIN ANALYZE

Sur optim perf : exécuter EXPLAIN ANALYZE **sur la requête exacte du code applicatif** (vue, RPC, subquery incluses), pas sur la table cible isolée. Faire 2 runs consécutifs :

```sql
EXPLAIN (ANALYZE, BUFFERS) <requête exacte>;
-- Run 1 = potentiel cold start
-- Run 2 = mesure réelle
```

Ne pas conclure sur 1 run unique.

### Webhooks externes — 400/422

Sur erreur partenaire externe : exiger le **RAW payload** (URL-encoded, JSON brut, headers complets) avant de proposer un fix. Pas de diagnostic sur les form values formatées par l'expéditeur — elles masquent les anomalies de casse, espaces, encodage.

### IDE vs CLI

Diagnostics « Cannot find module », « Type X not assignable » qui sortent du panel IDE sans cause manifeste : valider par `tsc --noEmit` CLI avant toute action. CLI = autorité, panel = potentiel stale.

## Checklist anti-complaisance

Avant de répondre « OK c'est bon » :

- [ ] La commande de vérif est dans le message
- [ ] La sortie brute est dans le message (pas un résumé)
- [ ] Si chiffre : la requête SQL et son résultat sont dans le message
- [ ] Si optim perf : 2 runs EXPLAIN consécutifs
- [ ] Si webhook : le RAW payload est cité
