<?php
  session_start();
  require_once("util.php");
  if(isset($_POST["id"])) {
        editarRegistro($_POST["id"], $_POST["nombre"], $_POST["rol"], $_POST["departamento"]);
    } else {
        nuevaEntrada();
    }
  header("location:index.php");
?>
