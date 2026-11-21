# Protocole Bluetooth – batterie Greenway (Talaria MX3)

Obtenu en décompilant l'app officielle « IMB » (`com.greenway.modle`, fichier `app_1.apk`).

## Bluetooth LE (module « BLE SPP »)

L'app essaie ces 3 jeux d'UUID (le n°1 est celui par défaut) :

| # | Service | Notify (réception) | Write (envoi) |
|---|---------|--------------------|---------------|
| 1 | `0000fff0-0000-1000-8000-00805f9b34fb` | `0000fff1-…` | `0000fff1-…` |
| 2 | `0000e0ff-3c17-d293-8e48-14fe2e4da212` | `0000ffe2-…` | `0000ffe1-…` |
| 3 | `1b7e8251-2877-41c3-b46e-cf057c562023` | `8ac32d3f-5cb9-4d44-bec2-ee689169f626` | `5e9bf2a8-f93f-4481-a67e-3b2f4a07891a` |

## Trame de lecture

Requête (6 octets) : `46 16 01 REG LEN CHK`
Réponse : `47 16 01 REG LEN DATA[LEN] CHK`

`CHK` = somme de tous les octets précédents, sur 8 bits. Données en little-endian.
L'app attend ~300 ms par réponse et réessaie 5 fois.

> Les trames `46 16 00 …` (écriture) et `46 16 00 77 …` (accès mémoire, mise à jour du firmware) ne sont **pas** utilisées par la web app.

## Registres

| REG | LEN | Contenu |
|-----|-----|---------|
| 0x08 | 32 | Températures (°C, int8) : [0] T1 cellules, [1] T2, [2] T3, [3] carte/MOS, [6] pré-charge |
| 0x09 | 4 | Tension pack (mV, uint32) |
| 0x0A | 4 | Courant (mA, int32 ; > 0 = charge) |
| 0x0D | 4 | SOC % (octet 0) |
| 0x0E | 4 | SOH % (octet 0) |
| 0x0F | 4 | Capacité restante (mAh) |
| 0x10 | 4 | Capacité pleine charge (mAh) |
| 0x14 | 4 | Valeur 16 bits inconnue |
| 0x16 | 16 | État : [0] bits 6-7 indicateurs ; [2..5] défauts ; [6..9] avertissements |
| 0x17 | 4 | Nombre de cycles |
| 0x18 | 4 | Capacité nominale (mAh) |
| 0x19 | 4 | Tension nominale |
| 0x1A | 8 | Version logicielle [1].[0], version matérielle [3].[2], IDX ASCII [4..7] |
| 0x1B | 4 | Date de fabrication (AA, MM, JJ) |
| 0x1D | 6 | Date/heure (AA MM JJ hh mm ss) |
| 0x1E | 6 | uint16 [0..1] (affiché pendant la charge), uint16 [2..3] (65535 = n/d) |
| 0x20 | 16 | Fabricant (ASCII) |
| 0x21 | 32 | Texte (ASCII) |
| 0x22 | 16 | Type de cellule (ASCII) |
| 0x23 | 16 | Numéro de série (ASCII), tronqué à 16 caractères (le nom Bluetooth contient le numéro complet à 17 caractères) |
| 0x24 | 32 | Tensions cellules 1-16 (mV, uint16) |
| 0x25 | 32 | Tensions cellules 17-32 (mV, uint16) |
| 0x26 | 14 | Historique : courant max décharge (int32), courant max charge (int32), cellule max (mV), cellule min (mV), temp max, temp min |
