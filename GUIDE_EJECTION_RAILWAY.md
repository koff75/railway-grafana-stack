# Guide d'Éjection des Services Railway

## ✅ Modifications Effectuées

Toutes les modifications ont été poussées sur le fork : `https://github.com/koff75/railway-grafana-stack`

### Fichiers Modifiés

1. **prometheus/prom.yml** - Ajout du target beelzebub
2. **grafana/datasources/datasources.yml** - UIDs corrigés (prometheus, loki, tempo)
3. **grafana/dockerfile** - Ajout de la copie des dashboards
4. **grafana/provisioning/dashboards/** - 3 dashboards Beelzebub ajoutés
5. **loki/promtail-config.yaml** - Configuration Promtail créée

## 🔧 Étape : Éjecter les Services Railway

### Pour chaque service (Prometheus, Loki, Tempo, Grafana)

#### Méthode 1 : Via l'interface Railway (Recommandé)

1. **Allez sur [Railway Dashboard](https://railway.app)**
2. **Sélectionnez le projet** `zoological-dedication`
3. **Pour chaque service** (Prometheus, Loki, Tempo, Grafana) :

   **Option A : Si "Eject" est disponible**
   - Cliquez sur le service
   - Allez dans **Settings**
   - Cherchez **Source** ou **Eject**
   - Cliquez sur **Eject** ou **Transform to Code**

   **Option B : Disconnect puis Reconnect**
   - Cliquez sur le service
   - Allez dans **Settings**
   - Cliquez sur **Disconnect** (déconnecte du template)
   - Cliquez sur **Connect** ou **New Service** > **GitHub Repo**
   - Sélectionnez votre fork : `koff75/railway-grafana-stack`
   - **Important** : Sélectionnez le dossier du service :
     - Prometheus → `prometheus/`
     - Loki → `loki/`
     - Tempo → `tempo/`
     - Grafana → `grafana/`

#### Méthode 2 : Via Railway CLI (si disponible)

```bash
# Lier le projet
railway link --project zoological-dedication

# Pour chaque service, connecter au fork
railway service Prometheus
# Puis dans l'interface, reconnecter au fork GitHub
```

### Ordre Recommandé

1. **Prometheus** (priorité - pour avoir les métriques)
2. **Grafana** (pour avoir les dashboards)
3. **Loki** (pour les logs)
4. **Tempo** (pour les traces, optionnel)

## ✅ Vérification après Éjection

### Prometheus

1. **Vérifier les targets :**
   - Accédez à Prometheus UI
   - Status > Targets
   - Le target `beelzebub` doit être **UP**

2. **Tester une requête :**
   - Graph > `beelzebub_events_total`

### Grafana

1. **Vérifier les datasources :**
   - Configuration > Data sources
   - Vérifier que Prometheus, Loki, Tempo sont configurés
   - UIDs doivent être : `prometheus`, `loki`, `tempo`

2. **Vérifier les dashboards :**
   - Dashboards > Dossier "Beelzebub"
   - Les 3 dashboards doivent être visibles :
     - Beelzebub Honeypot - Overview
     - Beelzebub - Exploit Detection (CVE-2026-21858)
     - Beelzebub - IP Analysis

### Loki

1. **Vérifier la collecte de logs :**
   - Si Promtail est déployé, vérifier qu'il fonctionne
   - Sinon, utiliser Locomotive pour collecter les logs Railway

## 📝 Notes Importantes

1. **Dossier du service** : Lors de la connexion au fork, assurez-vous de sélectionner le bon dossier (prometheus/, loki/, etc.)

2. **Variables d'environnement** : Les variables existantes seront conservées lors de l'éjection

3. **Volumes** : Les volumes existants seront conservés

4. **Redéploiement** : Railway redéploiera automatiquement après la connexion au fork

## 🐛 Dépannage

### Le service ne se connecte pas au fork

1. Vérifiez que le fork existe : `https://github.com/koff75/railway-grafana-stack`
2. Vérifiez que vous avez les permissions sur le repo
3. Vérifiez que le dossier du service existe dans le fork

### Les dashboards n'apparaissent pas

1. Vérifiez que le Dockerfile Grafana copie bien les dashboards
2. Vérifiez les logs Grafana pour les erreurs de provisioning
3. Vérifiez que le fichier `dashboards.yml` est correct

### Prometheus ne scrape pas beelzebub

1. Vérifiez que `prometheus/prom.yml` contient bien le target beelzebub
2. Vérifiez les logs Prometheus
3. Vérifiez que le Dockerfile copie bien `prom.yml`

## 🎯 Résultat Attendu

Après éjection de tous les services :

- ✅ Prometheus scrape beelzebub automatiquement
- ✅ Grafana a les datasources configurés automatiquement
- ✅ Grafana a les 3 dashboards importés automatiquement
- ✅ Toute la configuration est versionnée dans Git
- ✅ Les modifications futures se font dans le code, pas dans l'UI
