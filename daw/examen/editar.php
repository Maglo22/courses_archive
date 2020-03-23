<?php
  session_start();
  require_once("util.php");
  include("_header.html");
  $entrada = getEntrada(conectDb(), $_GET["idZombie"]);
  include("_forma.html");
  include("_footer.html");
?>
