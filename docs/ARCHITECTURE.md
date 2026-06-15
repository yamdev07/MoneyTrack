# Architecture

MoneyTrack suit une architecture en couches simple, adaptée à un MVP mobile.

## Couches

```
UI (screens + widgets)
        │  context.watch / context.read
        ▼
State (controllers — ChangeNotifier)
        │
        ▼
Data (repositories)
        │  Hive boxes
        ▼
Persistance locale (Hive)
```

### `models/`
Objets métier purs et leurs `TypeAdapter` Hive écrits à la main (pas de
`build_runner`). Les `typeId` sont stables :

| Modèle        | typeId |
|---------------|--------|
| Expense       | 1      |
| UserProfile   | 2      |
| Budget        | 3      |
| SavingsGoal   | 4      |

⚠️ Ne jamais réordonner les valeurs de `ExpenseCategory` : leur `index` est
persisté.

### `data/`
Un repository par agrégat (`ProfileRepository`, `ExpenseRepository`,
`BudgetRepository`, `SavingsRepository`). Les repositories encapsulent les boxes
Hive et exposent des opérations CRUD + requêtes (par mois / par semaine).

### `state/`
Un `ChangeNotifier` par domaine. Les controllers délèguent aux repositories puis
appellent `notifyListeners()`. Ils sont fournis à l'arbre via `MultiProvider`
dans `app.dart`.

### `core/`
Code transverse sans dépendance UI lourde : `Money` (formatage), `DateHelpers`,
`BudgetCalculator` (limites mensuelles/hebdomadaires), `AlertService`, thème et
constantes.

### `screens/`
Une feature par dossier, avec ses `widgets/` locaux. La navigation principale est
gérée par `HomeShell` (bottom navigation + FAB d'ajout de dépense).

## Choix de persistance

Le MVP utilise **Hive** (local, offline-first) plutôt que Firebase pour éviter
toute configuration et fonctionner sans connexion. La logique métier est isolée
dans les repositories : migrer vers Firebase reviendrait à réimplémenter ces
mêmes interfaces.

## Tests

Les tests unitaires couvrent la logique pure (`core/`, `models/`) sans dépendre
de Hive, ce qui les rend rapides et déterministes. Un smoke test widget valide le
rendu d'un composant.
