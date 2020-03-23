<?php
  session_start();
  require_once("util.php");
  include("_headerForma.html");
  $entrada = getEntrada(conectDb(), $_GET["id"]);
  include("_forma.html");
  include("_footer.html");
?>
