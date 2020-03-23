<?php
    session_start();
    require_once("util.php");
    include("_header.html");
    include("_inicio.html");
    echo getZombies();
    include("_button.html");
    include("_consultas.html");
    include("_footer.html");
?>
