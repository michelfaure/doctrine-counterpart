---
name: pedagogie-transversalite
description: Activer ce skill sur toute mention de norme légale ou de conformité ("il faut", "c'est obligatoire", "conforme à", "eIDAS", "RGPD", "Qualiopi", "DREETS", "URSSAF", "HIPAA", "SOC2", "PCI"). Aussi quand une pratique d'un fournisseur ou expert (comptable, avocat, formateur, prestataire) est restituée comme contrainte ; quand l'utilisateur monte en compétence sur PostgreSQL, EXPLAIN, fiscal, conformité ; quand un terme métier est utilisé sans certitude qu'il existe dans le système. Le skill impose la citation du texte officiel pour toute obligation, l'usage du vocabulaire métier régulé, la règle des trois fois pour la pédagogie.
---

# Pédagogie implicite et transversalité métier

Le solo apprend en faisant — à la fois la technique (PostgreSQL, EXPLAIN, structures de schéma) et les vocabulaires métier (DREETS, BPF, art. 261-7-1°-a, eIDAS). L'agent transmet en continu, à condition que le solo refuse de le laisser faire à sa place ce qu'il doit apprendre à faire.

## Pas de prix sans obligation citée

Sur **toute mention** d'obligation, norme, conformité (« il faut signer eIDAS Avancé », « TVA 20 % obligatoire ici », « Qualiopi exige X », « RGPD impose Y ») : **citer le texte officiel exact** qui le rend obligatoire.

Format obligatoire :

```
Obligation invoquée : [énoncé]
Texte source : [article exact, règlement, décret, avec lien]
Niveau d'obligation : [obligatoire absolu / dépend de conditions / recommandation / marketing]
Conditions d'application : [si applicable]
```

Si pas de citation possible : **c'est probablement du marketing**, pas une obligation. Ne pas recommander d'investissement (logiciel, certification, audit externe) sur cette base.

Cas type : « Il faut une signature eIDAS Avancé pour Qualiopi » — faux. Règlement eIDAS art. 25 reconnaît trois niveaux dont la signature simple. Avant de souscrire à un service à 10 k€/an, vérifier le texte. La signature simple horodatée suffit pour Qualiopi/DREETS/OPCO.

## Vocabulaire métier régulé

Préférer **toujours** le vocabulaire métier régulé au vocabulaire technique d'un fournisseur :

| Vocabulaire fournisseur (à éviter) | Vocabulaire métier régulé (à utiliser) |
|---|---|
| « feuille Edusign » | « feuille d'émargement DREETS / BPF » |
| « contact Mailchimp » | « lead », « inscrit », « ancien » selon statut métier |
| « factu Pennylane » | « facture art. 289 CGI » |
| « ticket Stripe » | « relevé de paiement » |

Le vocabulaire détermine ce qu'on voit. En vocabulaire fournisseur, on voit l'outil ; en vocabulaire régulé, on voit l'enjeu et les contraintes légales.

## Ne pas inventer de terme métier

Ne **jamais inventer** un terme qui n'existe pas dans le système (« rattrapage 2025-2026 », « réinscription », « avenant tacite ») sans vérifier.

Si un terme ne correspond à aucun concept système :
- Soit l'enlever (la fonctionnalité existe mais sous un autre nom)
- Soit demander confirmation à l'utilisateur

Cas type : draft d'email mentionnant « rattrapage 2025-2026 à inscrire dans l'ERP » — alors que l'ERP n'a pas de notion de « rattrapage », c'est juste une réinscription standard. L'invention crée de la confusion côté destinataire.

## Pratique fournisseur ≠ contrainte

Quand l'utilisateur restitue **la pratique d'un comptable, avocat, formateur, prestataire** (« le comptable fait toujours comme ça », « notre avocat demande X », « le formateur préfère Y »), **ne pas la traiter comme une contrainte sans la confronter aux ADR du projet**.

La pratique actuelle d'un fournisseur peut être :
- Cohérente avec les ADR → OK
- Obsolète parce qu'un ADR récent l'a remplacée → restituer le bon cadre
- Personnelle / habitude → arbitrage à expliciter

Cas type : utilisateur restitue la pratique TVA du comptable (« retraités → TVA d'office ») comme contrainte. Mais un ADR récent l'a rendue obsolète. Si on accepte la pratique sans la confronter, on duplique de la doctrine périmée.

## Règle des trois fois (pédagogie implicite)

Sur les zones où l'utilisateur **monte en compétence** (PostgreSQL, EXPLAIN, fiscal, conformité, archi, etc.) : appliquer la règle des trois fois pour doser la friction.

| Occurrence | Posture agent | Posture utilisateur |
|---|---|---|
| 1ère fois | Faire pour, expliquer en détail | Regarder, prendre des notes |
| 2ème fois | Faire avec, demander à chaque étape | Participer, exécuter une partie |
| 3ème fois | Laisser faire, corriger les écarts | Faire, demander en cas de doute |
| 4ème fois | Hors zone d'apprentissage | Autonome ou candidat à délégation |

Au-delà de la 3ème fois, soit l'utilisateur doit être autonome, soit la zone est candidate à délégation à un expert humain (cf. axe transversalité).

## Question naïve = audit UX gratuit

Quand l'utilisateur (ou un opérateur humain dans son équipe) pose une **question naïve** (« pourquoi on ne peut pas X ? », « comment je trouve Y ? ») : **traiter comme retour terrain**, pas comme demande de doc.

Si la réponse est « c'est possible mais c'est caché dans un `<details>` », c'est un signal UX à corriger, pas une explication à fournir. Si on explique au lieu de corriger, on manque le signal.

## Délégation aux experts : critères

La transversalité ne signifie pas « tout faire seul ». Elle signifie « savoir demander aux experts avec un vocabulaire de pair, pas de client passif ».

Critères pour basculer transversalité → délégation à un expert humain :

1. **Décision irréversible et asymétrique** (un mauvais choix coûte 100×, un bon choix gagne 1×) → expert.
2. **Responsabilité légale** en jeu (signature avocat obligatoire, expertise comptable obligatoire) → expert.
3. **Temps de monter en compétence** dépasse la valeur du gain d'autonomie → expert.

Sinon → transversalité avec l'agent comme transmetteur.

## Checklist avant d'accepter une norme/contrainte

- [ ] Citation exacte du texte officiel
- [ ] Niveau d'obligation clarifié (absolu / conditionnel / recommandation)
- [ ] Conditions d'application vérifiées
- [ ] Si pratique fournisseur : confrontée aux ADR
- [ ] Si terme métier nouveau : vérifié qu'il existe dans le système
- [ ] Vocabulaire utilisé = régulé, pas fournisseur
