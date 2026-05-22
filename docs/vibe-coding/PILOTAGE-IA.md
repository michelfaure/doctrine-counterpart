# PILOTAGE-IA — doctrine-counterpart

Journal de pilotage IA pour le repo de la doctrine Counterpart elle-même. Voix 1ère personne. Hot capture, pas littéraire. Chronologie inversée (plus récent en haut).

Pas de littérature, pas de théorie. Ce qui s'est passé matériellement.

---

## 2026-05-22 matin — R15 V2 commit gate + refutation V3 amend par sonde matérielle (DRAFT à éditer)

### Ce qui a marché

La V2 du commit gate s'est écrite en moins d'une heure, parce que j'avais structuré la V1 hier avec une séparation propre counter/gate. Le contrat partagé est juste le state file JSON — pas besoin de toucher au counter pour ajouter le gate, et inversement. Le coût initial "deux scripts au lieu d'un" a été récupéré dès la première extension. Note pour plus tard : pour tout hook à logique évolutive, je vais préférer N petits scripts avec contrat minimal à 1 script monolithique avec argv branching. C'est exactement la single responsibility de fond, et là c'est vérifié empiriquement.

Les 5 tests matériels avant push ont catché le bon comportement sur les 5 scénarios attendus (allow / block / bypass / non-git / threshold override). Le format "JSON payload simulé pipe au hook" est devenu une habitude qui marche — c'est le même pattern que deploy-safeguard et c'est facile à reproduire pour n'importe quel nouveau hook PreToolUse. Bon template à réutiliser pour V8+ ou autres.

L'auto-application de R5 a été le moment fort. J'avais écrit hier soir en clôture "V3-candidate pour git commit --amend" sans la tester. Ce matin, demande de Michel Faure d'implémenter. Au lieu de coder, j'ai sondé : 6 variantes amend testées au regex existant, toutes matchent. Le claim "limite résiduelle" s'effondre, pas de V3 à écrire. J'ai corrigé la mémoire pour effacer le faux claim. Ça m'a évité une heure de code inutile + une fausse complexité ajoutée au hook.

### Ce qui a foiré ou m'a surpris

Que j'aie produit hier soir un claim faux en fin de session, c'est exactement ce que la doctrine prêche d'éviter — et le moment où c'est statistiquement plus probable, c'est la clôture. La fatigue post-session + le besoin de boucler "proprement" pousse à projeter des extensions futures qui n'ont pas été testées. La section "À suivre" d'un session log est une zone à risque, pas un fourre-tout libre. Si /close-session avait un cinquième artefact obligatoire — "tester ou taguer [unverified] chaque claim de limitation résiduelle" — ce claim n'aurait pas eu lieu. C'est un trou dans le protocole actuel.

Surpris aussi que le skill `falsify-before-fix` ne se soit pas auto-invoqué quand j'écrivais "V3-candidate" hier soir. Le skill cible "fix" au sens correction de bug, mais une projection de feature future est conceptuellement le même type de claim non-testé — la sonde matérielle aurait dû s'imposer. Peut-être que le skill devrait élargir ses triggers à "todo", "candidate", "limite résiduelle", "v-suivante".

### Ce que je veux essayer la prochaine fois

Étendre les triggers du skill `falsify-before-fix` pour inclure les claims de feature future en fin de session ("V3-candidate", "todo: ", "limite résiduelle X", "amélioration possible Y"). Ces formulations sont des hypothèses non vérifiées qui méritent la même discipline que "fix bug X". L'extension de triggers est probablement 5 lignes dans le frontmatter du skill.

Mesurer l'efficacité de la V2 dans 30 jours via rerun M7. Si `runs_exceeding_5` revient près de 0 sur 30-day window, la V2 a tenu sa promesse. Si non, soit le gate ne fire pas en pratique (matcher problem), soit le bypass `[autonomy-ack]` est sur-utilisé — dans les deux cas c'est une donnée empirique exploitable, pas un échec.

Ajouter une section "À suivre — items testés vs hypothèses" au template `/close-session`. Chaque ligne dans "À suivre" doit être taguée `[tested]` ou `[hypothesis]`. Forcer cette distinction empêche les claims faibles de s'accumuler entre sessions. Si je fais ça, ça résout le trou pointé ci-dessus sans toucher au skill `falsify-before-fix`.

---

## 2026-05-21 après-midi — Doctrine v0.7.1 : metrics M6/M7 + meta-hook R15 + cleanup rembrandt-samples (DRAFT à éditer)

### Ce qui a marché

J'ai fait l'erreur de coller une conversation Claude externe (share 20/05) à la session sans contexte, l'IA m'a demandé ce que j'attendais — bon réflexe. La conversation collée critiquait le repo public et notait 7,5/10. La sonde matérielle yaml.safe_load sur les 12 SKILL.md a renversé le diagnostic principal : 11/12 OK, 1/12 cassé (falsify-before-fix avec des `:` non quotés dans la description). L'IA évaluatrice avait inféré "cassé" depuis le rendu GitHub Markdown sans tester. C'est exactement R1 + R12 en application — j'ai vu en pratique le pattern que la doctrine décrit.

Le rerun M1-M5 a tourné en 5 minutes après patch des CLI args (--repo / --memory-dir). Ce qui était hardcoded en placeholder post-cleanup est devenu vraiment configurable, du coup les scripts sont utilisables par n'importe qui maintenant, pas juste moi. M6 (R14 spike compliance) et M7 (R15 autonomous checkpoint) ont été créés à partir des amendements v0.7 et instrumentés en environ 1h. Le script mère doctrine-metrics.ts orchestre les 7 d'un seul appel et sort un tableau Markdown prêt à coller — ça résout le problème de "comment trianguler les chiffres entre toolkit et samples" en un seul exécutable.

Le meta-hook R15 user-scope a marché du premier coup — PostToolUse matcher "Agent" + UserPromptSubmit reset, threshold N=5 stderr warning. Le test matériel 5 incréments → warning fire au 5e ✓. Et la vraie Agent invocation post-wiring a passé count de 0 à 1, confirmant que "Agent" est bien le tool name canonique de Claude Code. La doctrine v0.7 disait "prototype pending user-scope" ; c'est désormais "deployed v0.7.1".

### Ce qui a foiré ou m'a surpris

Le cleanup rembrandt-samples niveau A m'a coûté plus de temps que prévu — j'avais oublié que `michelfaure/rembrandt-samples` contenait des paths `/Users/michelfaure/rembrandt/` committés depuis avril, et la mention "the organization" dans le README désanonymise Rembrandt en 10 secondes via Google. Pas une fuite fiscale (rien sur Vermeer/l'association) mais une cassure du voile le pseudonyme. J'ai assumé niveau A cosmétique sur HEAD, sans filter-repo : l'historique Git garde tout, c'est défensif contre crawler paresseux uniquement. Le voile était déjà rompu avant cette session, je n'ai pas inventé le problème, mais j'avais perdu de vue l'état réel de l'exposition publique.

M7 a sorti un chiffre déstabilisant : 4 chaînes > 5 commits sans session log sur les 30 derniers jours, dont une de **92 commits**. C'est exactement le mode de défaillance que R15 v0.7 prétend cibler — et la mesure révèle que le meta-hook n'était PAS opérationnel. Donc la règle existait en texte depuis v0.6, l'amendement v0.7 disait "prototype pending", et entre temps j'ai accumulé 92 commits consécutifs sans rien checkpointer. La discipline tombe matériellement quand l'autonomie prend le relais — exactement ce que la doctrine prédit. Ça m'a humilié un peu mais c'est aussi la meilleure confirmation empirique du besoin d'amendement.

Surpris aussi par le micro-drift détecté par /close-session lui-même : CLAUDE.md disait "76+ ADRs", le filesystem en a 74. Pas grave (3% d'overshoot) mais le protocole de clôture a attrapé ça, ce qui valide le principe "filesystem authority over summary".

### Ce que je veux essayer la prochaine fois

Implémenter la V2 du meta-hook R15 avec un vrai gating PreToolUse sur `git commit` qui bloque si count >= 5 (et pas seulement warning STDERR). La V1 actuelle est trop polie — l'humain peut ignorer le warning, et c'est précisément ce que la doctrine pénalise. Le gate dur sur `git commit` forcerait à invoquer /falsify-before-fix ou /close-session avant de continuer. Bypass via `[autonomy-ack]` comme pour deploy-safeguard.

Tester l'évaluation par un modèle non-Claude (GPT-5 ou Gemini) sur les mêmes URLs du repo. Le bidirectional-adversariality skill le dit explicitement : deux Claude convergents = une source pour R5, pas deux corroborations. La triangulation vraie nécessite un substrate différent. Je n'ai jamais fait ça matériellement, je devrais le faire avant la v0.5 closing pillar DEV.to (15 juillet).

Étendre les metrics M6-M10 manquantes : R7 (provenance + bulk re-count drift), R10 (silent failures via grep AST), R11 (parsimony via ts-prune). C'est le scope candidate déjà documenté dans `doctrine-metrics.ts`. À faire dans une session dédiée de 2-3h avant la v0.5.

---
