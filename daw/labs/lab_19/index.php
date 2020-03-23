<?php
  //session_start();
  require_once("util.php");
  include("_header.html");
  include("_main_view_head.html");
  echo getEmpleados();
  include("_preguntas.html");
  include("_button.html");
  include("_footer.html");
?>
