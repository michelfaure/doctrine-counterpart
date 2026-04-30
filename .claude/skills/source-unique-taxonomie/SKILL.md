---
name: source-unique-taxonomie
description: Activer ce skill quand l'utilisateur ou un agent envisage d'ajouter une colonne stockée dérivée d'autres données, crée une migration de schéma, mentionne "duplication", "synchronisation", "cache", ou ajoute une constante métier (taux TVA, année scolaire, seuil) dans un fichier. Aussi sur tout invariant métier irrévocable (statut terminal, enum fermé). Le skill impose la déclaration de catégorie Live/Snapshot/Cache et le rafraîchisseur dans le même commit.
---

# Source unique et taxonomie de la donnée

Toute valeur stockée dérivable d'autres données doit être catégorisée explicitement. La duplication par négligence — sans catégorie déclarée — est interdite.

## Les trois catégories

### Live

La valeur doit toujours refléter l'état courant du système. Aucune raison métier de figer.

**Implémentation** : ne pas stocker. Lecture via vue SQL `v_*` ou requête sur la source.

Exemple :

```sql
-- ❌ NE PAS FAIRE
ALTER TABLE contacts ADD COLUMN nb_inscriptions_actives integer;
-- Cette colonne va diverger silencieusement.

-- ✅ FAIRE
CREATE VIEW v_contact_inscriptions_actives AS
SELECT c.id AS contact_id, COUNT(i.*) AS nb
FROM contacts c
LEFT JOIN inscriptions i ON i.contact_id = c.id AND i.statut = 'inscrit'
GROUP BY c.id;
```

### Snapshot

La valeur doit rester **figée à sa valeur du moment d'un événement métier**. La modifier rétroactivement = faute fonctionnelle (vol d'historique).

**Implémentation** : stocker, ne jamais recalculer. Documenter en commentaire SQL.

Exemples typiques : `tarif_applique` au jour de l'inscription, `montant_prevu` d'une échéance contractuelle, `tva_taux` d'une facture.

```sql
COMMENT ON COLUMN inscriptions.tarif_applique IS
  'SNAPSHOT: tarif au jour de l''inscription. Ne jamais recalculer.';
```

### Cache

La valeur est dérivable mais coûteuse à calculer à la volée. On accepte de stocker pour la performance, **à condition** d'avoir un rafraîchisseur explicite déclaré dans le même commit.

**Implémentation** : stocker + déclarer le mécanisme. Trois mécanismes admis :

- `GENERATED ALWAYS AS (...)` — dérivation intra-ligne
- Trigger `trg_*` — sur les tables qui alimentent la valeur
- Vue matérialisée `mv_*` — avec REFRESH planifié (cron) ou manuel après bulk

Exemple :

```sql
-- Cache avec trigger de rafraîchissement
ALTER TABLE cours ADD COLUMN places_prises integer DEFAULT 0;
COMMENT ON COLUMN cours.places_prises IS
  'CACHE: rafraîchi par trg_inscriptions_sync_places';

CREATE OR REPLACE FUNCTION fn_sync_places_prises() RETURNS trigger AS $$
BEGIN
  UPDATE cours SET places_prises = (
    SELECT COUNT(*) FROM inscriptions
    WHERE cours_id = NEW.cours_id AND statut = 'inscrit'
  ) WHERE id = NEW.cours_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inscriptions_sync_places
AFTER INSERT OR UPDATE OR DELETE ON inscriptions
FOR EACH ROW EXECUTE FUNCTION fn_sync_places_prises();
```

## Algorithme de décision

Devant tout nouveau champ qui ressemble à une duplication :

1. **La valeur doit-elle évoluer avec les données amont ?**
   - Non — événement passé figé → **Snapshot**.
   - Oui — continuer en 2.

2. **Le calcul à la volée est-il acceptable côté performance ?**
   - Oui → **Live** (vue `v_*`).
   - Non — continuer en 3.

3. **Quel mécanisme de rafraîchissement pour ce Cache ?**
   - Dérivation intra-ligne → `GENERATED ALWAYS AS`.
   - Dérivation depuis autre table fréquente → trigger `trg_*`.
   - Dérivation lourde + lecture intensive → matview `mv_*`.

Si aucune des trois implémentations Cache n'est tenable, c'est que la valeur ne devrait pas être stockée — repasser à Live.

## Constantes métier

Toute constante (année scolaire, taux TVA, seuils) hardcodée dans plusieurs fichiers TS = drift en attente. Centraliser :

```typescript
// lib/constants.ts
export const ANNEE_SCOLAIRE_ACTIVE = '2025-2026';
export const TVA_TAUX_NORMAL = 0.20;
export const SEUIL_TIMEOUT_BATCH = 200;
```

Refuser toute occurrence hardcodée dispersée. Refacto + ADR si pattern dispersé identifié.

## Cash vs engagement

Si le projet implique de la finance : ne jamais mélanger les deux comptabilités dans une vue. Cash = quand encaissé/payé. Engagement = quand facturé/comptabilisé. Annoncer explicitement l'axe en titre de la vue ou de l'export.

## Invariants irrévocables

Statuts terminaux (`liste_rouge`, `transaction_annulee`), enums fermés, valeurs qui ne doivent jamais redescendre : protéger en DB par CHECK constraint ou trigger, pas seulement en TS. Le code applicatif peut être contourné, la DB pas.

## Checklist avant migration

- [ ] Catégorie L / S / C déclarée explicitement dans le commit
- [ ] Si Cache : rafraîchisseur déclaré dans le même commit
- [ ] Commentaire SQL `COMMENT ON COLUMN` documentant la catégorie
- [ ] Si invariant : protégé en DB, pas seulement en TS
- [ ] Constante métier centralisée si applicable
