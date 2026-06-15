# 💰 MoneyTrack

> Gère ton salaire, maîtrise tes dépenses, atteins tes objectifs d'épargne.

MoneyTrack est une application mobile **Flutter** de gestion de budget personnel,
pensée pour les salariés, étudiants et jeunes travailleurs. Elle fonctionne
**hors-ligne** (stockage local Hive) et tourne sur **iOS** et **Android**.

## ✨ Fonctionnalités

- **Salaire** — saisie du salaire mensuel et répartition automatique du budget
- **Budget hebdomadaire** — calcul automatique du budget par semaine
- **Dépenses** — ajout (montant, catégorie, date, description) + historique
- **Épargne** — objectif d'épargne et suivi du montant avec dépôts/retraits
- **Dashboard** — salaire, dépenses, reste et épargne en un coup d'œil
- **Alertes** — dépassement de budget par catégorie et bilan hebdomadaire
- **Paramètres** — devise (FCFA, €, \$…), réinitialisation, gestion des données

## 🛠 Stack technique

| Élément        | Choix                          |
|----------------|--------------------------------|
| Framework      | Flutter (Material 3)           |
| Langage        | Dart                           |
| État           | Provider (ChangeNotifier)      |
| Persistance    | Hive (local, offline-first)    |
| Graphiques     | fl_chart                       |
| Formatage      | intl (fr_FR)                   |

> Note : le cahier des charges mentionnait Firebase. Pour le MVP nous avons
> choisi un stockage **local** (zéro configuration, hors-ligne). Le passage à
> Firebase pour la synchro multi-appareil est prévu dans l'évolution.

## 🚀 Démarrage

```bash
flutter pub get
flutter run
```

## 🍎 Build iOS depuis Windows

iOS ne peut pas être compilé sur Windows (Xcode requis). Ce dépôt inclut une
pipeline **Codemagic** (`codemagic.yaml`) qui build sur des machines macOS dans
le cloud :

1. Connecte ce dépôt sur [codemagic.io](https://codemagic.io)
2. Lance le workflow **iOS (unsigned build)** pour un build de test
3. Pour TestFlight/App Store, active la signature (bloc commenté en bas du yaml)

## 🧪 Qualité

```bash
flutter analyze   # analyse statique
flutter test      # tests unitaires + widget
dart format .     # formatage
```

La CI (`.github/workflows/ci.yml`) exécute format + analyze + test à chaque push.

## 📁 Architecture

Voir [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md). En bref :

```
lib/
  core/      constantes, thème, formatage, calcul de budget, alertes
  models/    UserProfile, Expense, Budget, SavingsGoal (+ adapters Hive)
  data/      repositories Hive
  state/     controllers Provider
  widgets/   composants UI réutilisables
  screens/   splash, dashboard, add_expense, history, budget, savings, settings
```

## 📜 Licence

MIT — voir [LICENSE](LICENSE).
