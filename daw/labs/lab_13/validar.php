<?php
  session_start();
  if(isset($_SESSION["user"])){
    header("location:cerrar.php");
  }
  $nombre = htmlspecialchars($_POST["nom"]);
  $apellidoP = htmlspecialchars($_POST["apellidoP"]);
  $apellidoM = htmlspecialchars($_POST["apellidoM"]);
  $nombreU = htmlspecialchars($_POST["nomU"]);
  $passw = htmlspecialchars($_POST["passw"]);
  if(isset($nombre) && isset($apellidoP) && isset($apellidoM) && isset($nombreU) && isset($passw) && isset($_POST["puesto"]) && isset($_POST["dep"])){
    $_SESSION["user"] = $nombre;
    $_SESSION["apellidoP"] = $apellidoP;
    $_SESSION["apellidoM"] = $apellidoM;
    $_SESSION["nomU"] = $nombreU;
    $_SESSION["passw"] = $passw;

    //-- checar imagen --
    $target_dir = "Fotos/";
    $target_file = $target_dir . basename($_FILES["foto"]["name"]);
    $uploadOk = 1;
    $error = "";
    $imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);
    // Checar si es una imagen real
    if(isset($_POST["submit"])) {
        $check = getimagesize($_FILES["foto"]["tmp_name"]);
        if($check !== false) {
            $uploadOk = 1;
        } else {
            $error = "El archivo no es una imagen.";
            $uploadOk = 0;
        }
    }
    //Checar si se eligió un archivo
    if ($target_file == null) {
        $error = "No se eligió ninguna foto.";
        $uploadOk = 0;
    }
    // Checar si el archivo ya existe
    if (file_exists($target_file)) {
        $error = "El archivo ya existe.";
        $uploadOk = 0;
    }
    // Checar tamaño del archivo
    if ($_FILES["foto"]["size"] > 500000) {
        $error = "El archivo es demasiado pesado.";
        $uploadOk = 0;
    }
    // Formatos permitidos
    if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
    && $imageFileType != "gif" ) {
        $error = "Solo se aceptan JPG, JPEG, PNG y GIF como formato.";
        $uploadOk = 0;
    }
    // Checar si $uploadOk está en 0 por un error
    if ($uploadOk == 0) {
        $error .= " El archivo no fue subido.";
        echo "<script type='text/javascript'>alert('$error');</script>";
    // Subir archivo
    } else {
        if (move_uploaded_file($_FILES["foto"]["tmp_name"], $target_file)) {
        } else {
            echo "Error al subir el archivo.";
        }
    }
    $_SESSION["foto"] = $target_file;

    include("_header.html");
    include("_creado.html");
    include("_footer.html");
  }
  else{
    header("HTTP/1.0 404 Not Found");
  }
?>
