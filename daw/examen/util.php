<?php
  function conectDb(){
    $host = "localhost";
    $username = "root";
    $password = "root";
    $dbname = "petz";
    $port = 3306;
    $link = mysqli_init();
    $con = mysqli_real_connect($link, $host, $username, $password, $dbname, $port);

    //Checar conexión
    if (!$con){
      die("Conexión fallida: " . mysqli_connect_error());
    }
    $link->set_charset('utf8');
    return $link;
  }

  function closeDb($mysql){
    mysqli_close($mysql);
  }


  function getEntrada($db, $id){
    $query = "SELECT z.idZombie as idZombie, z.nombre as nombre, z.apellidoP as apellidoP, z.apellidoM as apellidoM, e.idEstado as idEstado
    FROM zombie z, tiene t, estado e
    WHERE z.idZombie = t.idZombie AND e.idEstado = t.idEstado AND z.idZombie ='".$id."'";
    $res = $db->query($query);
    $row = $res->fetch_array(MYSQLI_BOTH);
    return $row;
  }

  function getZombies(){
    $db = conectDb();
    $query = "SELECT z.idZombie as idZombie, z.nombre as nombre, z.apellidoP as apellidoP, z.apellidoM as apellidoM, e.nombreEstado as estado FROM zombie z, tiene t, estado e WHERE z.idZombie = t.idZombie AND e.idEstado = t.idEstado";
    $res = $db->query($query);
    $html = "";
    while($row = $res->fetch_array(MYSQLI_BOTH)){
      $html .= '
      <div class="row">
        <div class="col s3">
          <p>'.$row["nombre"].'</p>
        </div>
        <div class="col s3">
          <p>'.$row["apellidoP"].'</p>
        </div>
        <div class="col s3">
          <p>'.$row["estado"].'</p>
        </div>
        <div class="col s3">
          <a href="editar.php?id='.$row["idZombie"].'" class="btn-floating"><i class="material-icons">edit</i></a>
        </div>
      </div>';
    }
    mysqli_free_result($res);
    closeDb($db);
    return $html;
  }

  function getCantidadZombies(){
    $db = conectDb();
    $query = "SELECT COUNT(z.nombre) as registrados
              FROM zombie z, tiene t
              WHERE z.idZombie = t.idZombie";
    $res = $db->query($query);
    $html = "";
    while($row = $res->fetch_array(MYSQLI_BOTH)){
      $html .= '
      <div class="container">
        <div class="row">
          <h5>Zombies registrados</h5>
          <div class="col s3">
            <p>'.$row["registrados"].'</p>
          </div>
        </div>';
    }
    $query = "SELECT e.nombreEstado, COUNT(t.idEstado) as Cantidad
              FROM tiene t, estado e
              WHERE t.idEstado = e.idEstado
              GROUP BY e.nombreEstado";
    $res = $db->query($query);
    $html .= '
    <div class="row">
    <h5>Zombies por cada Estado</h5>
    </div>';
    while($row = $res->fetch_array(MYSQLI_BOTH)){
      $html .= '
        <div class="row">
          <div class="col s3">
            <p>'.$row["nombreEstado"].'</p>
          </div>
          <div class="col s3">
            <p>'.$row["Cantidad"].'</p>
          </div>
        </div>';
    }
    $html .='</div>';
    mysqli_free_result($res);
    closeDb($db);
    return $html;
  }

  function getDropdownEstados($selected=-1){
    $db = conectDb();
    $query = "SELECT * FROM estado ORDER BY nombreEstado";
    $res = $db->query($query);
    $html = "";
    while($row = $res->fetch_array(MYSQLI_BOTH)){
      if($selected == $row["idEstado"]){
        $html .= '<option value="'.$row["idEstado"].'" selected>'.$row["nombreEstado"].'</option>';
      }
      else{
        $html .= '<option value="'.$row["idEstado"].'">'.$row["nombreEstado"].'</option>';
      }
    }
    mysqli_free_result($res);
    closeDb($db);
    return $html;
  }

  function guardarZombie($nombre, $apellidoP, $apellidoM, $estado){
    $db = conectDb();
    $query = "CALL crearZombie('".$nombre."','".$apellidoP."','".$apellidoM."','".$estado."')";
    if (!$db->query($query)) {
    echo "Falló CALL: (" . $db->errno . ") " . $db->error;
    }
    closeDb($db);
  }

  function editarRegistro($id, $nombre, $rol, $departamento){
    $db = conectDb();
    $query='UPDATE usuarios SET nombre=?, rol=?, departamento=? WHERE id=?';
    if(!($statement = $db->prepare($query))){
      die("Preparación fallida: (".$db->errno.") ".$db->error);
    }
    if(!($statement->bind_param("ssss", $id, $nombre, $rol, $departamento))){
      die("Vinculación de parámetros fallida: (".$statement->errno.") ".$statement->error);
    }
    if(!$statement->execute()){
      die("Ejecución fallida: (".$statement->errno.") ".$statement->error);
    }
    closeDB($db);
  }

?>
