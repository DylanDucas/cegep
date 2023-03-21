<h1 style="text-align:center;">Monovox</h1>

<?php redirect_message() ?>

<form action="/actions/auth/login" method="POST">
    <input type="text" name="username" placeholder="Identifiant">
    <input type="password" name="password" placeholder="Mot de passe">
    <label>
        <input type="checkbox" name="teacher">
        Enseignant
    </label>
    <br>

    <button type="submit">Connexion</button>
</form>