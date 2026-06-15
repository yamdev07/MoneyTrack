# Contribuer à MoneyTrack

Merci de ton intérêt ! Voici comment contribuer proprement.

## Workflow Git

- Une **branche par fonctionnalité** : `feat/...`, `fix/...`, `chore/...`, `docs/...`
- Des commits **petits et atomiques** suivant [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `test:`, `docs:`, `chore:`, `style:`, `ci:`)
- Merge dans `main` via `--no-ff` (ou Pull Request)

## Avant de pousser

```bash
dart format .
flutter analyze
flutter test
```

Ces trois commandes doivent passer (elles sont rejouées par la CI).

## Style de code

- `prefer_single_quotes` activé (voir `analysis_options.yaml`)
- Garder la logique métier dans `core/` et `data/`, hors des widgets
- Les nouveaux modèles persistés reçoivent un `typeId` Hive **unique et stable**

## Structure

Voir [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) avant d'ajouter une couche ou un écran.
