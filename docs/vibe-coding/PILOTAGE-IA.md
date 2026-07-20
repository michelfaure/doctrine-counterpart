# PILOTAGE-IA — doctrine-counterpart

Journal de pilotage IA pour le repo de la doctrine Counterpart elle-même. Voix 1ère personne. Hot capture, pas littéraire. Chronologie inversée (plus récent en haut).

Pas de littérature, pas de théorie. Ce qui s'est passé matériellement.

---

## 2026-07-20 — trois relectures externes, et le garde qui me mord (DRAFT à éditer)

### Ce qui a marché

Faire relire le repo en aveugle, par sessions fraîches et successives, est le meilleur rendement méthodo que j'aie eu. Trois passes, trois couches : la doctrine (rien de matériel, une critique structurelle qui a lancé v0.11), les skills (deux drifts réels), les hooks (deux trous de sécurité, avec tests exécutés). Ce qui rend ces retours utilisables, c'est de les traiter comme des claims à falsifier et pas comme des verdicts : sur les skills, « les refs axis sont périmées » était faux — les axes sont stables depuis v0.3, seul le qualificatif de version driftait ; sur les hooks, le triage vivant/publié a montré que mon scanner de secrets personnel, câblé sur Write/Edit, était structurellement hors d'atteinte des deux défauts. Sans ces sondes j'aurais « corrigé » des choses saines et cru mon tier vivant troué.

### Ce qui a foiré ou m'a surpris

Le secret-scanner publié était éteint sur la forme de commit que les agents émettent en réalité (`git add -A && git commit`), à cause d'un `^` d'ancrage — et il greppait le disque là où le commit embarque l'index. Un secret stagé puis nettoyé passait. Deux ans de fausse confiance en puissance, sur le pattern JWT Supabase qui est précisément le plus cher à fuiter chez moi. Et dans la même soirée, l'identity-guard promu quelques heures plus tôt m'a bloqué pour une fuite réelle : mes propres docs de clôture portaient mes initiales et le vrai nom du projet — pendant que le commit fautif, lui, était déjà parti au push précédent parce que j'avais chaîné commit et push dans une seule commande, et qu'un hook PreToolUse ne voit que le HEAD d'avant. Le garde a mordu et révélé son propre angle mort dans le même mouvement.

### Le quatrième tour (ajout de fin de journée)

Mon correctif du soir avait ouvert son propre contournement : la résolution de répertoire lisait « cd » n'importe où dans la ligne, message de commit compris, si bien que `git commit -m "fix: cd in build.sh"` désarmait le scanner de secrets. Et le pattern clé privée PEM n'avait jamais matché depuis l'écriture du hook — grep lisait ses tirets comme des options. Même famille que ce que je venais de fermer : un regex trop large, un fail-open. Trois de mes quatre sondes de la journée se sont révélées invalides, dont celle qui disait « pas de trou » sur ce bypass. J'ai donc arrêté de réparer à la main : `tests/hooks/run.sh`, 25 assertions, une par forme de commande et une par pattern, mutation-testé — remettre l'état d'hier soir rougit exactement les deux bonnes assertions. Découverte au passage : mes deux correctifs sont redondants, chacun ferme le trou seul, il fallait les deux défauts ensemble — seule une suite qu'on remet dans l'état historique le montre. Et j'ai enfin soldé le finding qui avait survécu à trois relectures : l'installeur ne livrait ni le template d'ADR que R8 impose ni la checklist. Un finding qui survit à trois revues n'est pas mineur, il est sans propriétaire.

### Les skills, et quatre positions avant une mesure (nuit)

Le relecteur a attaqué la couche skills. J'ai voulu savoir ce qu'ils me coûtaient vraiment et j'ai passé quatre tours à me tromper sur une question triviale : est-ce que les dix skills installés dans l'ERP se chargent, oui ou non. J'ai dit non (déduit d'un registre lu dans le mauvais contexte), puis oui (déduit d'un `ls`), puis non à nouveau (déduit d'un nom de frontmatter absent — le harnais indexe sur le nom de dossier). La réponse est venue en une commande : invoquer le skill dans une vraie session ERP et lire un chiffre qui diffère entre les deux copies. 1159 contre 1200. Ils sont actifs. Trois inférences, une mesure — et la mesure était disponible depuis le début.

Ce que la mesure a révélé ensuite est plus intéressant que la question de départ. Deux agents ont comparé, prescription par prescription, ce que ces dix skills portent contre ce que je charge déjà : huit sur dix contiennent des choses qui n'existent nulle part ailleurs. Et surtout, mes copies étaient **plus riches** que la version publique sur un point — elles gardaient les vrais chiffres de l'incident Yasmina là où le repo public porte des chiffres inventés — mais **plus pauvres** de deux mois d'amendements. Les deux lignées s'étaient appauvries dans des directions opposées. J'ai fusionné : texte à jour, ancrages réels conservés.

La leçon que je retiens vraiment : publier oblige à générifier, et générifier retire l'ancrage qui fait mordre une règle. Le danger n'est pas de publier, c'est de **réimporter**. Si je relance un jour `install.sh` chez moi « pour me mettre à jour », j'écrase mes incidents par des exemples inventés, et comme les fichiers portent le même nom, je ne verrai rien. C'est écrit dans le repo maintenant, à l'endroit exact où ça se produirait.

### Le palier 1, et le challenger qui le remet à sa place (fin de journée)

J'ai fini par arrêter de réparer à la main. La suite couvre les dix hooks, le harnais de mutation est versionné, la CI tourne — et elle a mordu dès son premier run sur une chose que mes tests locaux avaient laissée filer : l'installeur sortait en erreur alors que tous les fichiers atterrissaient, parce que ma sonde jetait le code de retour. Cause racine typique : l'installeur sautait un skill clos, le vérificateur le comptait encore comme manquant. Deux décisions qui se contredisaient depuis la veille.

Puis j'ai passé le palier au challenger, et il a réfuté ce que je venais d'annoncer. Ma suite teste le dépôt que je publie ; ce qui garde ma machine, ce sont mes hooks à moi, qui divergent lourdement — scanner de secrets sur un tout autre matcher, deux gardes vivants-seuls (migrations Supabase, arbre principal) qui n'avaient jamais eu un seul test. Autrement dit : j'avais fait du travail de distribution en le présentant comme de la protection. C'est exactement la distinction qu'on avait posée deux heures plus tôt, et je suis tombé du mauvais côté sans le voir. Corrigé dans la foulée : une suite pour le tier vivant, privée, 55 assertions, mutation-testée.

Le chiffre qui reste : **dix sondes manuelles fausses en deux jours** — quatre du relecteur, six de moi, dont une dans le harnais de tests lui-même et une dernière qui accusait à tort mon identity-guard. Ce n'est plus une série d'anecdotes, c'est le taux de base à assumer quand on vérifie à la main. C'est le meilleur argument que j'aie pour tout ce qui est versionné aujourd'hui.

### Ce que je veux essayer la prochaine fois

Écrire les tests de hook comme R17 l'exige : jamais la seule forme canonique — la forme chaînée, la forme `-C`, la forme depuis un autre répertoire, et un cas négatif ré-armé pour prouver que le filet mord. Vers un remote public, commit et push restent deux commandes, toujours. Et industrialiser ce que la triangulation a rendu évident : une passe de relecture externe par couche (norme, skills, hooks) à chaque cycle, en aveugle, en la traitant comme une source Am.R12 — matérielle avant d'être crue.

## 2026-07-19 soir — v0.11 : la doctrine passe aux ciseaux (DRAFT à éditer)

### Ce qui a marché

J'ai fait relire le repo à une session fraîche sans lui dire que Michel Faure c'était moi — la clause de triangulation exécutée pour de vrai, en aveugle. Cinq tours de lecture hostile, zéro finding matériel, et la seule critique restée debout — je réponds à chaque problème par une structure de plus — est devenue le fait nouveau d'un cycle entier. Ce qui a tout déclenché, c'est la conversion de cette critique non-matérielle en sondes locales : 11 806 tokens toujours-chargés mesurés, R19 vivant en 8 copies, 10 fichiers porteurs de version. Le split terse s'est fait en une soirée avec son filet : le ledger reçoit le texte long v0.10 verbatim (byte-identité vérifiée au diff avant réécriture), et l'audit d'équivalence par un agent frais a attrapé six clauses normatives que MA compression avait perdues — toutes réintégrées avant merge. Tuer M1/M5 m'a coûté dix minutes de décision une fois la sonde posée (« ils n'ont jamais produit une mesure valide ») : c'est la première retraite par falsification du corpus, exactement celle que le relecteur croyait absente.

### Ce qui a foiré ou m'a surpris

La compression perd du normatif même quand on fait attention — six clauses tombées, dont l'interdiction du méga-hook et la décision blanket-CI-non-câblée. Sans l'agent d'équivalence je les aurais découvertes dans six mois, en les violant. Surprise plus piquante : ma propre passe de cohérence du 17/07 avait AJOUTÉ une copie — la table R1-R19 complète du README, 42 lignes de contenu-règle — le biais d'accumulation opère pendant qu'on le répare. Et le balayage final a trouvé le drift jusque chez gorgon (référence v0.4.1, sept versions de retard) et dans mon CLAUDE.md personnel, qui affirmait deux choses devenues fausses : le trigger `actions.ts` pourtant retiré au v0.10, et ask-3-options « pas installé » alors qu'il l'est depuis le 17/07. La copie doctrine ne vit pas que dans le repo — elle essaime dans chaque fichier d'instructions de la machine.

### Ce que je veux essayer la prochaine fois

Ouvrir le prochain cycle par la sonde delta — structures nées vs tuées depuis v0.11 — avant tout harvest, pour que la discipline net ≤ 0 soit mesurée et pas déclarée. Tenir cette ligne : ce soir l'identity-guard n'a été promu que parce que M1/M5 mouraient en face. Au premier gros diff chaud venu, tester enfin loop-until-dry avec la colonne single-pass vs loop au journal R19 — le dernier reste du cycle précédent sans données. Billing GHA rembrandt : toujours `[unverified]` (non re-sondé ce soir, reset attendu 01/08).

## 2026-07-17 après-midi — v0.10 : le cycle qui s'audite enfin lui-même (DRAFT à éditer)

### Ce qui a marché

Déléguer l'audit R18(c) à deux agents dédiés au lieu de le faire au fil de l'eau. Le harvest a dépouillé les 26 logs et les 28 entrées PILOTAGE sans en sauter un, et il est revenu avec la chose que je n'aurais pas trouvée moi-même en relisant : trois contradictions dures, dont deux contre R19 que je venais de shipper il y a douze jours. La promotion s'est ensuite écrite presque seule parce que chaque candidat arrivait avec son N et ses ancres — et le spot-check des ancres (3/3) avant de graver m'a coûté trente secondes pour une confiance réelle. R18(c) attendait depuis v0.8 sous forme de « cron trimestriel » jamais câblé ; il aura suffi d'une après-midi et d'une forme différente de celle prescrite.

### Ce qui a foiré ou m'a surpris

Ma propre sonde de mortalité était fausse — `find -newerBt` sur archive/ mesure la naissance, pas l'archivage, parce que `mv` préserve la birthtime ; j'ai failli rapporter « 5 archivages » quand la réalité était 28. Le README du repo annonçait encore v0.7 : deux bumps de version sans jamais lever la tête vers le doc d'entrée. M5 qui tourne « vert » en mesurant le vide depuis des semaines. Et la plus piquante : la contradiction Artefact A — c'est le mécanisme que j'avais durci en v0.8 pour attraper les claims faibles au close qui a laissé passer le « Bug LIVE confirmé » du 11/07, et je l'ai re-durci aujourd'hui pendant que son échec était encore chaud. Post-close, la publication des mesures a produit l'incident le plus instructif de la journée : l'agent a poussé deux fois des noms de clients sur le repo public — un push chaîné derrière le scan qui devait le gater, puis un script de redaction crashé avalé par un `;` — et le commit disait « redacted » alors que rien ne l'était. Réparé en minutes (redaction structurelle, force-push, vérif sur origin = 0), mais la leçon est brutale : au moment de publier, le scan est un gate qui se LIT, pas une étape qui se chaîne, et les slugs de fichiers sont une surface de fuite que aucune liste de noms ne couvre.

### Ce que je veux essayer la prochaine fois

Le test loop-until-dry sur le prochain diff chaud large, avec la colonne « single-pass vs loop » au journal R19, pour savoir si la deuxième vague de finders mord ou si je paie de la cérémonie. La sonde d'ouverture systématique en début de session pilotée par une note de reprise — le durcissement au close ne suffit pas, la classe a cinq occurrences. Et trancher M1/M5 au prochain cycle au lieu de porter deux instruments morts un cycle de plus : un instrument qu'on garde « au cas où » est exactement le cache sans refresher que la doctrine chasse partout ailleurs.

## 2026-07-05 après-midi — v0.9 : le hook qui ne peut pas se lancer lui-même (DRAFT à éditer)

### Ce qui a marché

Le `/challenger` sur ma *propre* recommandation. Je partais convaincu qu'il fallait faire de « /code-review avant merge » une règle OU un hook, je sentais un conflit avec la parcimonie, et au lieu de trancher au feeling j'ai lancé le protocole sur ma proposition. Il a tué deux de mes étais — un hook local ne peut pas lancer une slash-command, et j'avais affirmé que `pre-push-inventory` « n'existe pas » alors qu'il existe en source repo. Le cœur a tenu, donc j'ai shippé R19 avec moins d'échafaudage mais plus de vrai. Bonus : construire le hook en copiant l'idiome exact de `deploy-safeguard` (stdin JSON, bypass `[token]`, exit 2) l'a rendu testable en 4 cas synthétiques du premier coup.

### Ce qui a foiré ou m'a surpris

J'ai sur-vendu `pre-push-inventory` deux fois avant de vérifier. D'abord « n'existe pas sur disque » (faux — il est dans le `.claude/skills/` du repo doctrine), puis j'ai recommandé de l'installer avant de réaliser que `deploy-safeguard` gate déjà push-to-main, donc marginal. Deux claims sur ma propre install, faux jusqu'à ce que je lance vraiment un `ls`. Le vrai drift n'était pas dans CLAUDE.md l.57 (qui dit correctement « skills source ») — il était dans ma tête, à ne pas distinguer source-repo de user-scope. Autre surprise : la doctrine était déjà en v0.8 alors que mon CLAUDE.md projet cadre encore tout en v0.7 — j'avais perdu le fil de ma propre version.

### Ce que je veux essayer la prochaine fois

Lancer un `ls` littéral user-scope vs repo-source AVANT toute affirmation qu'un mécanisme « existe » ou « est actif » — la leçon Am.R1, mais je continue à me la faire sur mon propre outillage. Traiter « cette skill/ce hook est-il vivant ? » comme une sonde matérielle (la liste des skills disponibles), pas un rappel de mémoire. Et solder la dette de lag de version : `manifesto.md` et le CLAUDE.md projet ont deux versions de retard ; je bumpe toujours le fichier opérationnel et je laisse pourrir les fichiers de lecture humaine — à batcher dans le créneau dette mensuel plutôt que de le re-signaler à chaque fois.

---

## 2026-06-16 nuit — v0.8 promue, et une fuite que mon « cleanup » de mai n'avait jamais vraiment réglée (DRAFT à éditer)

### Ce qui a marché

L'arbitrage de scope en 3 options avant d'écrire quoi que ce soit — j'ai tranché « les 4 + 2 artefacts » en connaissant le coût de chaque branche, pas à l'aveugle. Le `/challenger` final a payé son prix : il a vu que R18, figé tel quel, prescrivait un cron qui n'existe pas, soit le « filet sur papier » que Am.R1 interdit dans la même release. Sans cette passe, je publiais une règle qui se viole elle-même. Et la discipline « privé d'abord, scrub, vérifier à zéro, repasser public » a tenu — j'ai vérifié `git log -p --all` ET les messages de commit avant chaque force-push.

### Ce qui a foiré ou m'a surpris

Ma note PILOTAGE de mai disait que rembrandt-samples était « niveau A cosmétique sur HEAD, sans filter-repo » — je l'avais oublié, et c'était toujours vrai : 13× mon nom, 38× rembrandt dans l'historique d'un repo PUBLIC lié depuis le footer de la doctrine. Scrubber la doctrine sans toucher à ça aurait été du théâtre. Deuxième surprise : remplacer les tokens ne suffit pas — « ceramic art school (six locations) » survivait, et sa version française a échappé à ma première règle, il a fallu deux passes. Troisième : bloqué 30 min sur ma propre 2FA GitHub parce que je n'avais aucune app TOTP — sauvé par un fichier recovery sur disque externe, puis passkey.

### Ce que je veux essayer la prochaine fois

Mettre un `git fetch` + `rev-list behind origin/main` en TOUT début de chantier, pas le découvrir au push rejeté (rebase à 1h du mat). Traiter « repo public » comme une checklist matérielle dès qu'on committe dedans : pas de path absolu, pas de descripteur métier, historique + messages, pas seulement HEAD. Enfin compacter MEMORY.md (200 lignes, le hook bloque) pour pouvoir y poser la leçon transversale — sinon R18 me nargue, capture sans place pour capturer.

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
