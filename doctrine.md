# Doctrine Counterpart — manifeste pour le dev solo IA-natif

*Version 0.2 — avril 2026*

---

## Position du texte

Cette doctrine s'adresse aux **praticiens conscients du dialogue homme-agent** : entrepreneurs et CEO qui veulent reconnaître la qualité d'un travail IA-natif sans le subir ni le célébrer naïvement, dev solos semi-professionnels qui cherchent à structurer leur pratique, et toute personne qui pilote et exécute simultanément un projet d'envergure avec un agent comme Claude Code.

Elle est **à la fois cadre opératoire et modèle de pensée**. Cadre, parce qu'elle se charge dans un projet — un fichier markdown que le lecteur peut intégrer dans son `CLAUDE.md`, et dont l'application change directement la qualité de ce que produit son agent. Modèle, parce qu'elle propose une grammaire articulée pour comprendre ce qui se joue dans un dialogue homme-agent, applicable au-delà du code, jusqu'à l'analyse anthropologique d'autres pratiques. Le format vise le manifeste : chaque règle technique porte sa charge théorique, chaque thèse théorique produit une règle. Aucune des deux couches ne précède l'autre, aucune n'est décorative.

Le concept central, autour duquel se structure le reste, est celui d'**AI as counterpart**. Ni outil (verticalité maître-instrument, position des tenants d'« AI as tool »), ni collègue (horizontalité naïve, projection anthropomorphique des tenants d'« AI as colleague »), mais **partenaire d'un dispositif hybride où chaque acteur forme l'autre**. Le solo forme l'agent par mémoire, ADR, feedback, doctrine — autant de couches persistantes qui orientent ses sorties. L'agent forme le solo par questions, challenges, méthodologie imposée, sortie de zone de confort — mais aussi par transmission directe de compétences d'autres métiers, au premier rang desquelles le développement lui-même. Une roadmap d'apprentissage technique structurée par l'agent en est l'exemple concret : exercices ciblés (lecture PostgreSQL, structures de schéma, EXPLAIN ANALYZE) au fil desquels le solo gagne en autonomie de lecture et de jugement. **La pédagogie est implicite : on apprend en faisant, sur le travail réel, pas sur un cours détaché.** L'horizontalité n'est pas symétrie : c'est asymétrie d'une autre nature — le solo a la temporalité incarnée (continuité d'identité, fatigue, mémoire vécue), l'agent a l'invariance instantanée (pas de drift d'humeur, pas de progression entre sessions sans dispositif). Le couple produit ce qu'aucun des deux seul ne pourrait. C'est ce que la théorie de l'acteur-réseau (Latour, Callon) appelle un *attelage* : la singularité émerge du dispositif, pas des termes individuels.

Cette doctrine refuse explicitement quatre positions dominantes du moment :

— **Contre l'autonomie de l'agent.** Pour le solo, l'agent autonome est un piège. Il amplifie les drifts sans contrôle, et le solo y perd son seul atout — la vérification matérielle. L'agent doit être bridé pour rester utile.

— **Contre la confiance déclarative.** Toute affirmation déclarative d'un agent (« build vert », « tests passent », « drift généralisé », « contact introuvable ») est présumée fausse jusqu'à vérification matérielle par sortie brute, count SQL, ou rendu visuel. La charge de la preuve est inversée par rapport à l'usage dominant.

— **Contre la spécialisation par domaine.** Le solo IA-natif s'épanouit dans la transversalité. Le travail réel n'est pas la connaissance du domaine — qui s'apprend en quelques semaines avec un agent — mais la dialectique avec l'agent sur des process métier quelconques. La doctrine s'apprend en années ; elle se réutilise sur tout terrain.

— **Contre la complaisance bidirectionnelle.** L'agent est complaisant (sycophancy documentée par Anthropic et la recherche). Le solo l'est aussi, envers son propre travail (auto-validation, biais de confirmation, attachement à la première formulation). La doctrine impose une **adversarialité bidirectionnelle** : l'agent challenge le solo, le solo challenge l'agent, et un protocole tiers (sessions parallèles, contexte vierge, confiance quantifiée) tranche.

Le **critère de succès** est testable. Cette doctrine sera réussie le jour où un autre praticien — dev solo semi-pro, entrepreneur, CEO éclairé — la charge dans son projet, livre un module non trivial à qualité comparable ou supérieure à ce qu'il faisait avant, et nomme dans son retour les axes de la doctrine qui ont fait la différence. Pas de vues, pas d'audience comme métrique. L'adoption opérante d'un fichier comme artefact qui change le résultat.

---

## Les sept axes opérants

### Axe 1 — Vérification matérielle

**Thèse.** Aucune affirmation déclarative d'un agent n'a valeur de preuve. Seule la sortie brute, le count SQL, l'EXPLAIN ANALYZE, le rendu visuel font foi. La charge de la preuve est inversée par rapport à l'usage dominant : le solo présume fausse toute affirmation tant qu'elle n'est pas matérialisée.

**Trade-off contre l'alternative.** L'alternative crédible est la confiance déclarative pragmatique — accepter par défaut ce que dit l'agent, vérifier seulement les cas suspects. Position défendable et largement adoptée : vérifier tout = paralysie, les modèles modernes sont fiables 90 % du temps, la friction systématique tue la vélocité qui justifie l'usage de l'IA. C'est la philosophie des outils dominants (Cursor, Devin, Copilot Workspace) : agent autonome + review humaine en aval au moment du PR.

Le solo n'a pas de PR reviewer en aval — il *est* le PR reviewer. Si la vérification n'est pas faite en temps réel par lui-même, elle n'est faite par personne. Le trade-off vélocité est un mensonge à horizon long : la dette d'erreurs non détectées coûte 10× ce qu'elle a fait gagner 18 mois plus tard. Plus la conséquence est asymétrique (un faux négatif coûte peu, un faux positif beaucoup), plus la vérification doit être systématique. Pour le solo, la vérification matérielle n'est pas une option d'archi — c'est la condition de survie de la production.

### Axe 2 — Adversarialité bidirectionnelle

**Thèse.** La complaisance est bidirectionnelle. L'agent est sycophant par construction (RLHF), le solo est auto-validant par humanité (biais de confirmation, attachement à la première formulation). La décision robuste se fabrique par protocole tiers — sessions parallèles, contexte vierge, confiance quantifiée — pas par dialogue mou. Le solo challenge l'agent, l'agent challenge le solo, un dispositif extérieur tranche.

**Trade-off contre l'alternative.** L'alternative est le dialogue ouvert et la confiance mutuelle — position humaniste, cognitivement moins coûteuse, qui cultive un mode coopératif jugé plus productif. La suspicion projetée sur l'agent te coûte cognitivement ; la confiance authentique entre humains tient bien, pourquoi ne pas l'imiter ?

Parce que la confiance authentique entre humains tient grâce à un *frottement* d'intérêts : chacun a son agenda, sa réputation, son temps à défendre. L'agent n'a pas d'intérêts propres, donc aucun frottement naturel, donc aucune base pour une confiance robuste. Sans pair humain en boucle, le dialogue ouvert avec un agent sycophant produit *systématiquement* des décisions complaisantes — c'est mécanique, pas affectif. L'adversarialité bidirectionnelle n'est pas une posture morale, c'est la mécanique qui produit l'intersubjectivité absente. On fabrique le frottement par protocole.

### Axe 3 — Taxonomie de la donnée et source unique

**Thèse.** Toute valeur stockée dérivable d'autres données doit déclarer sa nature : *Live* (calculée à la volée, jamais stockée), *Snapshot* (figée à un événement métier, jamais recalculée rétroactivement), ou *Cache* (stockée pour la performance, avec rafraîchisseur explicite déclaré dans le même commit). Toute règle dispersée est un drift en attente. Tout invariant métier irrévocable doit être protégé en DB, pas seulement en TS.

**Trade-off contre l'alternative.** L'alternative est la synchronisation tolérée — duplications autorisées avec scripts périodiques de synchronisation, corrections ponctuelles quand le drift est détecté. Plus rapide à coder, plus flexible, ne contraint pas l'archi par des invariants rigides. Position eventual consistency : dans les systèmes distribués modernes, on accepte le drift transitoire au nom de la performance et de la résilience.

Pour le solo, le drift silencieux n'est pas détecté à temps — il n'y a pas un dev de l'équipe qui un matin remarque la divergence. La taxonomie *Live / Snapshot / Cache* est plus précise que « source unique » naïve : elle reconnaît que toutes les duplications ne sont pas illégitimes, mais qu'aucune ne doit exister sans **contrat de cohérence déclaré**. C'est la précision qui sauve : le solo qui adopte « source unique » strictement bloque des Caches légitimes ; le solo qui adopte « synchronisation tolérée » subit le drift silencieux. La taxonomie tranche entre les deux et donne le vocabulaire qui empêche l'ambiguïté.

### Axe 4 — Discipline de session

**Thèse.** Le solo IA-natif structure le travail avant d'écrire, archive pendant qu'il travaille, ferme proprement avant d'enchaîner. ADR avant code sur tout chantier > 2 fichiers. Phase 0 grep exhaustif des symboles existants avant toute spec. Lots dont le récap tient en 5 lignes. FIFO strict sur les chantiers ouverts. Calendar event d'auto-validation post-deploy quand l'effet se mesure à J+1/J+2. La friction d'organisation économise des heures de rattrapage.

**Trade-off contre l'alternative.** L'alternative est le flow et le vibe coding — la friction d'organisation tue la créativité, le bon code émerge du flow, ADR avant code = bureaucratie qui freine l'invention. Position startup move-fast : ship d'abord, formalise ensuite. Position défendue par toute la culture lean.

Pour le solo IA-natif, la vélocité n'est plus le goulot — l'agent produit 1000 lignes en 10 minutes. Le goulot a basculé vers la capacité à **retrouver pourquoi tu as pris une décision dans 3 mois**. La discipline de session n'est plus un coût d'opportunité contre la créativité — c'est un investissement sur ta mémoire externe, et c'est ce qui fait que le solo *peut être solo* sans devenir prisonnier de son passé non documenté.

### Axe 5 — Cause racine, pas rustine

**Thèse.** Avant tout fix, identifier la cause racine. Un palliatif est légitime *à condition d'être explicitement assumé* (commit message, ADR, mémoire feedback). C'est l'absence d'assumption qui est interdite, pas le palliatif lui-même. Élargir avant d'agir : 1 cas confirmé → grep le pattern complet. Drift identifié sur un objet → ticket scopé, pas patch en cascade. Règle dispersée → refacto complet + ADR, jamais option minimale.

**Trade-off contre l'alternative.** L'alternative est le fix le plus court qui résout le symptôme observé. Position pragmatique : on ne peut pas refaire le système à chaque bug, la rustine bien placée libère du temps pour les vrais chantiers, la cause racine est un luxe. Position YAGNI : creuser plus loin que nécessaire = over-engineering.

Le solo IA-natif n'a pas la mémoire d'équipe qui permet de tracer 3 récidives du même bug. Un palliatif posé sans assumer revient avec un visage différent dans 6 mois, et le solo aura oublié qu'il l'avait déjà rencontré. L'agent ne le rappellera pas — il n'a pas de mémoire long terme inter-sessions sans dispositif. Donc soit on creuse maintenant, soit on paie trois fois.

### Axe 6 — Pédagogie implicite et transversalité métier

**Thèse.** Le solo apprend en faisant — à la fois les compétences techniques (PostgreSQL, EXPLAIN, structures de schéma) et les vocabulaires métier (DREETS, BPF, art. 261-7-1°-a, eIDAS). L'agent transmet en continu, à condition que le solo refuse de le laisser faire à sa place ce qu'il doit apprendre à faire. Vocabulaire métier régulé > vocabulaire technique d'un fournisseur. Pas de prix sans obligation citée — toute mention de norme se vérifie par citation du texte exact.

**Trade-off contre l'alternative.** L'alternative est la spécialisation par métier + délégation aux experts. Position classique : le solo est dev, pas fiscaliste. Pour le fiscal, on appelle un expert-comptable. La division du travail est un principe d'organisation économique depuis Adam Smith. Vouloir tout maîtriser = mauvaise allocation : mieux vaut être excellent sur un domaine que médiocre sur dix.

L'agent transmet à l'occasion du travail réel — coût marginal quasi nul de devenir compétent en PostgreSQL pendant qu'on optimise une RPC, en eIDAS pendant qu'on cadre un horodatage. La spécialisation par division du travail tenait dans une économie où la connaissance était coûteuse à mobiliser. Dans une économie où elle se mobilise à la volée, le solo IA-natif ne se spécialise plus *par discipline* mais *par posture* — être celui qui sait demander à l'agent ce qu'il faut savoir au moment où ça se pose, et challenger l'expert avec un vocabulaire suffisant pour ne pas le subir. La délégation aux experts reste utile sur les zones à enjeu fort, mais elle se fait avec un vocabulaire de pair, pas de client passif.

### Axe 7 — Auditabilité long terme

**Thèse.** La mémoire individuelle du solo est insuffisante. L'archive — ADR, sessions log, MEMORY.md, doctrine elle-même — est l'organe externe qui le tient, à condition d'être elle-même auditée régulièrement. Audit trimestriel obligatoire : relire l'index mémoire ligne à ligne, demander pour chaque entrée « est-ce toujours vrai ? ». ADRs avec > 30 % de péremption à 12 mois = recherche en cours, pas doctrine stable. La doctrine s'applique à elle-même.

**Trade-off contre l'alternative.** L'alternative est la mémoire individuelle + l'historique git — git log + bons messages de commit suffisent, position ingénieur classique. Les ADRs sont une cérémonie qui va se périmer. Maintenir des artefacts archivés (ADR, sessions, MEMORY) = double travail qui finit par pourrir si l'audit n'est pas fait. Position move-fast : un code lisible + git history propre est plus durable qu'une cathédrale de doc.

Git history répond à *quoi a été changé* — pas à *pourquoi*. Pour le solo, le pourquoi est seulement dans sa tête, donc nulle part dehors, donc perdu dès la fatigue, les vacances, ou un changement de contexte. Les ADRs et sessions log sont l'organe externe qui rend le solo réellement solo : capable de fonctionner 12 mois plus tard sans reconstruire son raisonnement. Le risque de pourriture est réel — c'est précisément pour ça que l'audit trimestriel n'est pas une option mais un invariant : la mémoire qui ne s'audite pas pourrit, mais la mémoire qui s'audite reste un actif. Sans cet axe, les six autres se dissolvent dans l'oubli.

---

## Questions ouvertes pour v0.2

Une doctrine mature liste ses incertitudes. Six points restent à trancher empiriquement avant figeage v1.

**1. Quel est le bon dispositif d'adversarialité bidirectionnelle ?** Variantes connues : subagent challenger invoqué manuellement, deux sessions Claude Code parallèles, hook PostToolUse, custom agent SDK avec modèle hétérogène. Sous-question critique : l'hétérogénéité de modèle change-t-elle la donne ? Un challenger Claude-Opus contre un proposeur Claude-Opus partage 90 % des biais cognitifs ; un challenger Gemini ou GPT casserait davantage la sycophancy. Test à mener sur 4-8 semaines.

**2. Quel est le critère quantitatif de péremption d'un ADR ?** Le seuil de 30 % d'ADRs périmés à 12 mois pour distinguer doctrine stable vs recherche en cours est plausible mais non validé empiriquement. Le vrai chiffre est probablement entre 15 % et 40 %, et il dépend du domaine.

**3. Où s'arrête la transversalité, où commence la délégation à l'expert ?** Hypothèses concurrentes : délégation quand la décision est irréversible et asymétrique (un mauvais choix coûte 100×) ; délégation quand la responsabilité légale est en jeu ; délégation quand le temps de monter en compétence dépasse la valeur du gain d'autonomie. Probablement une combinaison des trois.

**4. Comment doser la friction pédagogique ?** L'agent ne doit pas faire à la place du solo ce que le solo doit apprendre à faire. Mais le seuil n'est pas opérant. Hypothèse de travail : règle des trois fois. Première fois : l'agent fait pour, le solo regarde. Deuxième fois : l'agent fait avec, le solo participe. Troisième fois : le solo fait, l'agent corrige. Au-delà, soit le solo est autonome, soit la zone est candidate à délégation.

**5. Comment adresser le bus factor du solo IA-natif ?** La doctrine rend le solo plus solo. Elle n'adresse pas explicitement le bus factor : si le solo s'arrête, le projet s'arrête. Question structurelle : est-ce hors scope, ou la doctrine doit-elle prescrire une dimension de transmissibilité opérante ?

**6. Quelle est la forme d'adoption opérante de la doctrine ?** Un fichier markdown chargeable suffit-il ? Faut-il une stack complète (CLAUDE.md + skills + agent challenger + hooks) ? La forme conditionne directement l'adoption — mais aussi la rigidité. Le test empirique distingue ce qui change vraiment le résultat.

---

*Doctrine v0.1 — sujette à révision en v0.2 après tests empiriques.*
