<?php
    session_start();
    require_once("util.php");
    include("_header.html");
    echo getCantidadZombies();
    include("_footer.html");
?>
