<?php
  session_start();
  require_once("util.php");
  if(isset($_POST["idZombie"])) {
        editarZombie($_POST["nombre"], $_POST["apellidoP"], $_POST["apellidoM"], $_POST["estado"]);
    } else {
        guardarZombie($_POST["nombre"], $_POST["apellidoP"], $_POST["apellidoM"], $_POST["estado"]);
    }
  header("location:index.php");
?>
