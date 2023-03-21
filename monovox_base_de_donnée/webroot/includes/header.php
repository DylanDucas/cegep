<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monovox</title>

    <link rel="stylesheet" href="/assets/awsm.css">
    <link rel="stylesheet" href="/assets/style.css">

    <style>
        .error-flash {
            padding: 8px 16px 16px 16px;
            background-color: lightpink;
        }

        .error-flash h1 {
            margin: 0px;
        }
    </style>
</head>
<body style="margin: 0px;">
    <div style=" height: 100vh; display: flex; flex-direction: column;"> <!-- parent -->
        <div style="flex-grow: 1;  overflow: auto; padding: 16px;"> <!-- main content container -->

        <?php
        $name = get_session('user_name');

        if ($name) :
        ?>
            <div>
                <h1 style="display: inline-block;">Bonjour <span style="font-style: italic;"><?= $name ?></span></h1>
                <a href="/actions/auth/logout">Déconnexion</a>
            </div>
        <?php endif; ?>