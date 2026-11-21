# TalariaBattPro

Web app pour lire en Bluetooth la batterie Greenway d'une Talaria MX3 (lecture seule), sans compte ni login.
Web app to read a Talaria MX3 Greenway battery over Bluetooth (read-only), no account needed.

**App : https://sycoqc.github.io/TalariaBattPro/**

- Android : ouvrir l'adresse dans **Chrome**, puis menu ⋮ → « Ajouter à l'écran d'accueil ».
- iPhone : ouvrir l'adresse dans l'app **Bluefy** (gratuite sur l'App Store). Safari ne gère pas le Bluetooth web.

Fonctions : SOC, tension, courant, puissance, températures, tension de chaque cellule, alarmes, santé, cycles, historique du BMS, connexion par numéro de série, français / anglais, mode démo.

Le protocole est décrit dans [PROTOCOLE.md](PROTOCOLE.md). `serveur.ps1` sert l'app en local (http://localhost:8080) pour les tests.
