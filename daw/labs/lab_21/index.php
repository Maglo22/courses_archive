<?php
  session_start();
  require_once("util.php");
  include("_header.html");
  echo getEmpleados();
  include("_button.html");
  include("_footer.html");
?>
