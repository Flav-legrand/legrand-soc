<?php
/*
 * Legrand$ Démo — application bancaire VOLONTAIREMENT VULNÉRABLE.
 * Elle sert uniquement de cible au laboratoire SOC. Ne jamais l'exposer sur Internet.
 */
session_start();

function db(): PDO
{
    $file = '/var/lib/legrand/banque.sqlite';
    $new = !file_exists($file);
    $pdo = new PDO('sqlite:' . $file);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    if ($new) {
        $pdo->exec("CREATE TABLE clients (id INTEGER PRIMARY KEY, login TEXT, password TEXT, nom TEXT, solde INTEGER)");
        $pdo->exec("CREATE TABLE transactions (id INTEGER PRIMARY KEY, client_id INTEGER, libelle TEXT, montant INTEGER, date TEXT)");
        $pdo->exec("INSERT INTO clients VALUES (1,'amoukouama','Brazza2026','A. Moukouama',1250000),(2,'bngouabi','Soleil123','B. Ngouabi',845000),(3,'admin','admin123','Administrateur',0)");
        $pdo->exec("INSERT INTO transactions VALUES (1,1,'Dépôt agence Poto-Poto',500000,'2026-11-02'),(2,1,'Retrait Mobile Money',-75000,'2026-11-10'),(3,2,'Virement salaire',845000,'2026-11-25'),(4,1,'Paiement facture E2C',-32000,'2026-11-18')");
    }
    return $pdo;
}

/** Journal applicatif JSON, collecté par l'agent Wazuh (/var/log/legrand/app.log). */
function log_event(string $event, array $extra = []): void
{
    $line = json_encode([
        'app'       => 'legrand-bank',
        'event'     => $event,
        'srcip'     => $_SERVER['REMOTE_ADDR'] ?? '-',
        'url'       => $_SERVER['REQUEST_URI'] ?? '-',
        'timestamp' => date('c'),
    ] + $extra, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    file_put_contents('/var/log/legrand/app.log', $line . PHP_EOL, FILE_APPEND | LOCK_EX);
}

function h(?string $s): string { return htmlspecialchars((string) $s, ENT_QUOTES, 'UTF-8'); }

function page(string $title, string $body): void
{
    echo '<!DOCTYPE html><html lang="fr"><head><meta charset="utf-8"><title>' . h($title) . ' · Legrand$</title><link rel="stylesheet" href="style.css"></head><body>'
        . '<header><strong>Legrand$</strong> <span>Banque démo · laboratoire SOC</span></header><main>' . $body . '</main>'
        . '<footer>Application volontairement vulnérable — usage pédagogique uniquement</footer></body></html>';
}
