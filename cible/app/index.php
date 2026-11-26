<?php
require __DIR__ . '/lib.php';

$msg = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $login = $_POST['login'] ?? '';
    $pass = $_POST['password'] ?? '';
    // VULNÉRABILITÉS VOLONTAIRES : aucune limitation de tentatives, mots de passe en clair.
    $st = db()->prepare('SELECT * FROM clients WHERE login = ? AND password = ?');
    $st->execute([$login, $pass]);
    $client = $st->fetch(PDO::FETCH_ASSOC);
    if ($client) {
        session_regenerate_id(true);
        $_SESSION['client'] = $client['id'];
        log_event('login_success', ['srcuser' => $login]);
        header('Location: compte.php');
        exit;
    }
    log_event('login_failed', ['srcuser' => $login]);
    http_response_code(401);
    $msg = '<p class="err">Identifiants invalides.</p>';
}
page('Connexion', '<h1>Espace client</h1>' . $msg . '
<form method="post"><label>Identifiant <input name="login"></label>
<label>Mot de passe <input type="password" name="password"></label><button>Se connecter</button></form>');
