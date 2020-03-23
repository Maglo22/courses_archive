<?php
  function conectDb(){
    $host = "localhost";
    $username = "root";
    $password = "root";
    $dbname = "empleados";
    $port = 3306;
    $link = mysqli_init();
    $con = mysqli_real_connect($link, $host, $username, $password, $dbname, $port);

    //Checar conexión
    if (!$con){
      die("Conexión fallida: " . mysqli_connect_error());
    }
    return $link;
  }

  function closeDb($mysql){
    mysqli_close($mysql);
  }

  function getTable($table){
    $conn = conectDb();
    $query = "SELECT * FROM" .$table;
    $res = $conn->query($query);
    while ($row = mysqli_fetch_array($res, MYSQLI_BOTH)){
      for($i = 0; $i < count($row); $i++){
        echo $row[$i];
      }
      echo "<br>";
    }
    echo "<br>";
    mysqli_free_result($res);
    closeDb($conn);
    return;
  }

  function getColumna($col, $db, $id){
    $query = "SELECT" .$col ."FROM usuarios WHERE id ='".$id."'";
    $res = $db->query($query);
    $row = mysqli_fetch_array($res, MSQLI_BOTH);
    $columna = $row["".$col.""];
    return $columna;
  }

  function getEntrada($db, $id){
    $query = "SELECT * FROM usuarios WHERE id ='".$id."'";
    $res = $db->query($query);
    $row = $res->fetch_array(MYSQLI_BOTH);
    return $row;
  }

  function getEmpleados(){
    $db = conectDb();
    $query = "SELECT * FROM usuarios";
    $res = $db->query($query);
    $html = "";
    while($row = $res->fetch_array(MYSQLI_BOTH)){
      $html .= '
      <div class="row">
        <div class="col s3">
          <p>'.$row["nombre"].'</p>
        </div>
        <div class="col s3">
          <p>'.$row["rol"].'</p>
        </div>
        <div class="col s3">
          <p>'.$row["departamento"].'</p>
        </div>
        <div class="col s3">
          <a href="eliminar.php"><i class="material-icons right">delete_forever</i></a>
          <a href="editar.php"><i class="material-icons right">edit</i></a>
        </div>
      </div>';
    }
    mysqli_free_result($res);
    closeDb($db);
    return $html;
  }

  function nuevaEntrada(){
    $nombre = $_POST["nombre"];
    if($_POST["rol"] == 1){
      $rol = "Hitman";
    }
    else if($_POST["rol"] == 2){
      $rol = "Caza recompensas";
    }
    else if($_POST["rol"] == 3){
      $rol = "Reconocimiento";
    }
    if($_POST["departamento"] == 1){
      $departamento = "Pulp";
    }
    else if($_POST["departamento"] == 2){
      $departamento = "Retro";
    }
    else if($_POST["departamento"] == 3){
      $departamento = "BF";
    }
    guardarEntrada($nombre, $rol, $departamento);
  }

  function guardarEntrada($nombre, $rol, $departamento){
    $db = conectDb();
    $query = "INSERT INTO usuarios (`nombre`, `rol`, `departamento`) VALUES (?,?,?)";
    if(!($statement = $db->prepare($query))){
      die("Preparación fallida: (".$db->errno.") ".$db->error);
    }
    if(!($statement->bind_param("sss", $nombre, $rol, $departamento))){
      die("Vinculación de parámetros fallida: (".$statement->errno.") ".$statement->error);
    }
    if(!$statement->execute()){
      die("Ejecución fallida: (".$statement->errno.") ".$statement->error);
    }
    closeDB($db);
  }

  function eliminarEntrada($nombre){
    $db = conectDb();
    $query = "DELETE FROM usuarios WHERE nombre = '".$nombre."'";
    $res = mysqli_query($db, $query);
    closeDb($db);
    return $res;
  }

?>
