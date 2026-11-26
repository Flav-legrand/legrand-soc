<?php
require __DIR__ . '/lib.php';
if (empty($_SESSION['client'])) { header('Location: index.php'); exit; }

$id = (int) $_SESSION['client'];
$q = $_GET['q'] ?? '';
$rows = [];
$err = '';
try {
    // VULNÉRABILITÉ VOLONTAIRE (injection SQL) : concaténation directe du paramètre q.
    // Correctif : voir playbooks/PB-02-injection-sql.md (requête préparée).
    $sql = "SELECT date, libelle, montant FROM transactions WHERE client_id = $id AND libelle LIKE '%$q%' ORDER BY date DESC";
    $rows = db()->query($sql)->fetchAll(PDO::FETCH_ASSOC);
    if ($q !== '') log_event('search', ['query' => $q]);
} catch (PDOException $e) {
    log_event('sql_error', ['query' => $q, 'error' => $e->getMessage()]);
    $err = '<p class="err">Erreur de base de données.</p>';
}
$table = '';
foreach ($rows as $r) {
    $table .= '<tr><td>' . h($r['date'] ?? '') . '</td><td>' . h($r['libelle'] ?? '') . '</td><td>' . h((string) ($r['montant'] ?? '')) . '</td></tr>';
}
page('Mon compte', '<h1>Mes transactions</h1><form><input name="q" value="' . h($q) . '" placeholder="Rechercher un libellé"><button>Rechercher</button></form>'
    . $err . '<table><tr><th>Date</th><th>Libellé</th><th>Montant (FCFA)</th></tr>' . $table . '</table>');
