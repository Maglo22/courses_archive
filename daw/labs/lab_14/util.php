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

  /*function getNombre($db, $id){
    $query = "SELECT nombre FROM usuarios WHERE id ='".$id ."'";
    $res = $db->query($query);
    $row = mysqli_fetch_array($res, MSQLI_BOTH);
    $nombre = $row["nombre"];
    return $nombre;
  }

  function getRol($db, $id){
    $query = "SELECT rol FROM usuarios WHERE id ='".$id ."'";
    $res = $db->query($query);
    $row = mysqli_fetch_array($res, MSQLI_BOTH);
    $rol = $row["rol"];
    return $rol;
  }

  function getDepartamento($db, $id){
    $query = "SELECT departamento FROM usuarios WHERE id ='".$id ."'";
    $res = $db->query($query);
    $row = mysqli_fetch_array($res, MSQLI_BOTH);
    $dep = $row["departamento"];
    return $dep;
  }*/

  function getEmpleados(){
    $db = conectDb();
    $query = "SELECT * FROM usuarios";
    $res = $db->query($query);
    $html = "";
    while($row = $res->fetch_array(MYSQLI_BOTH)){
      $html .= '
      <div class="row">
        <div class="col s4">
          <p>'.$row["nombre"].'</p>
        </div>
        <div class="col s4">
          <p>'.$row["rol"].'</p>
        </div>
        <div class="col s4">
          <p>'.$row["departamento"].'</p>
        </div>
      </div>';

    }
    mysqli_free_result($res);
    closeDb($db);
    return $html;
  }
?>
