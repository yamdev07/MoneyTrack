# Déployer MoneyTrack sur iPhone via Codemagic

Comme iOS ne se compile pas sur Windows, on build dans le cloud avec Codemagic
(machines macOS), puis on installe sur l'iPhone via **TestFlight**.

## 0. Prérequis

- Un **compte Apple Developer payant** (99 $/an).
  > Un compte Apple gratuit ne permet **pas** TestFlight. Pour installer sans
  > compte payant, il faut un Mac + Xcode (signature « développeur » 7 jours).
- Un compte **Codemagic** (gratuit pour démarrer) connecté à
  `github.com/yamdev07/MoneyTrack`.
- L'app utilise déjà le bundle id **`com.drwintech.moneytrack`**.

## 1. Créer une clé App Store Connect API

1. [App Store Connect](https://appstoreconnect.apple.com) → **Users and Access**
   → onglet **Integrations / Keys** → **App Store Connect API** → **+**.
2. Rôle **App Manager** (ou Admin). Génère la clé.
3. Récupère :
   - le fichier **`.p8`** (téléchargeable une seule fois),
   - le **Key ID**,
   - l'**Issuer ID** (en haut de la page).

## 2. Brancher la clé dans Codemagic

1. Codemagic → avatar → **Teams / Personal account** → **Integrations**
   → **Apple Developer Portal** → **Connect**.
2. Importe le `.p8`, le **Key ID** et l'**Issuer ID**.
3. Donne à l'intégration le nom exact **`CodemagicApiKey`**
   (c'est la référence utilisée dans `codemagic.yaml`).

## 3. Enregistrer l'app

- **Bundle ID** : Codemagic peut le créer automatiquement à la 1re build.
  Sinon, Apple Developer → **Identifiers** → **+** → `com.drwintech.moneytrack`.
- **App App Store Connect** : App Store Connect → **Apps** → **+** → nouvelle app
  (plateforme iOS, nom « MoneyTrack », bundle id ci-dessus, un SKU au choix).

## 4. Lancer le build

1. Codemagic → ajoute l'app depuis le dépôt GitHub.
2. Choisis le workflow **« iOS release (TestFlight) »** (défini dans `codemagic.yaml`).
3. **Start new build**. Codemagic :
   - récupère les profils de provisioning (`xcode-project use-profiles`),
   - build l'`.ipa` signé,
   - l'envoie à **TestFlight** (`submit_to_testflight: true`).

## 5. Installer sur l'iPhone

1. Sur l'iPhone, installe l'app **TestFlight** (App Store).
2. Dans App Store Connect → **TestFlight**, ajoute-toi comme testeur interne
   (ton Apple ID).
3. Ouvre TestFlight sur l'iPhone → MoneyTrack apparaît → **Installer**.

## Dépannage

- *« No matching profiles »* → vérifie que le bundle id existe côté Apple et que
  l'intégration s'appelle bien `CodemagicApiKey`.
- *Build signé mais pas sur TestFlight* → l'app doit d'abord exister dans
  App Store Connect (étape 3).
- *Pas de compte payant* → utilise plutôt le workflow `ios-unsigned`
  (simulateur uniquement) ou un Mac + Xcode.
