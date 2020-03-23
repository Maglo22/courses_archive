<?php
  $nombre = htmlspecialchars($_POST["nom"]);
  $apellidoP = htmlspecialchars($_POST["apellidoP"]);
  $apellidoM = htmlspecialchars($_POST["apellidoM"]);
  $nombreU = htmlspecialchars($_POST["nomU"]);
  $passw = htmlspecialchars($_POST["passw"]);
  if(isset($nombre) && isset($apellidoP) && isset($apellidoM) && isset($nombreU) && isset($passw) && isset($_POST["puesto"]) && isset($_POST["dep"])){
    include("_header.html");
    include("_creado.html");
    include("_footer.html");
  }
  else{
    header("HTTP/1.0 404 Not Found");
  }
?>
