<!DOCTYPE html>
<html>
  <head>
    <title>Lab 9: PHP</title>
    <link rel="stylesheet" href="CSS/style.css">
  </head>
  <body>
    <h1>Laboratorio 9</h1>
    <div id="container">

      <div id="arreglo">
        <h3>Arreglo a tratar</h3>
        <?php
          // -- creación del arreglo --
          $size = rand(5, 15);
          for ($i = 0; $i < $size; $i++) {
            $arr[$i] = rand(1, 150);
          }

          //-- Imprimir arreglo --
          function imprimirA($arreglo) {
            $mesg ="";
            $arrLength = count($arreglo);
            for ($i = 0; $i < $arrLength; $i++) {
              $mesg.= $arreglo[$i]." ";
            }
            return $mesg;
          }
          echo imprimirA($arr);
         ?>
      </div>
      <div id="prom">
        <h3>Promedio de un arreglo</h3>
        <?php
            //-- Promedio de arreglo --
            function promedioArr($arreglo) {
              $arrLength = count($arreglo);
              $suma = 0;
              for ($i = 0; $i < $arrLength; $i++) {
                $suma += $arreglo[$i];
              }
              return ($suma/$arrLength);
          }
            $prom = promedioArr($arr);
            echo "Promedio del arreglo: $prom.<br>";
        ?>
      </div>
      <div id="med">
        <h3>Mediana de un arreglo</h3>
        <?php
          //-- Mediana de arreglo --
          function medianaArr($arreglo) {
            $arrSo = sort($arreglo);
            $arrLength = count($arreglo);
            $mi = (($arrLength - 1)/2);
            $med = 0;
            if(($arrLenght % 2) != 0) {
              $med = (($arreglo[$mi] + $arreglo[($mi+1)])/2);
            }
            else{
              $med = $arreglo[$mi];
            }
            return $med;
          }
          $mediana = medianaArr($arr);
          echo "Mediana del arreglo: $mediana.<br>";
        ?>
      </div>
      <div id="lista">
        <h3>Elementos en lista, Promedio, Medinana y Reordenación de un arreglo</h3>
        <?php
              //-- Lista, Promedio, Mediana, Ordenamiento--
              function lista($arreglo) {
                $arrLength = count($arreglo);
                $pr = promedioArr($arreglo);
                $me = medianaArr($arreglo);
                $msg = "<ul>";
                for ($i = 0; $i < $arrLength ; $i++) {
                  $msg .= "<li>".$arreglo[$i]."</li>";
                }
                $msg .= "</ul>";
                $msg .= "<br>Promedio del arreglo: $pr.";
                $msg .= "<br>Mediana del arreglo: $me.";
                sort($arreglo);
                $msg .= "<br>Arreglo ordenado de menor a mayor: ".imprimirA($arreglo);
                rsort($arreglo);
                $msg .= "<br>Arreglo ordenado de mayor a menor: ".imprimirA($arreglo);
                echo $msg;
              }
              lista($arr);
         ?>
      </div>
      <div id="tabla">
        <h3>Tabla de cuadrados y cubos</h3>
        <?php
          //-- tabla de cuadrados y cubos --
          $n = rand(3, 10);
          function tabla($num) {
            $tab = "<table><tbody><tr><th>Número</th><th>Cuadrado</th><th>Cubo</th></tr>";
            for ($i = 0; $i < $num; $i++) {
              $tab .= "<tr><td>".($i+1)."</td><td>".pow(($i+1), 2)."</td><td>".pow(($i+1), 3)."</td></tr>";
            }
            $tab .= "</tbody></table>";
            echo $tab;
          }
          tabla($n);
         ?>
      </div>
      <div id="time">
        <h3>Días para que acabe el semestre</h3>
        <?php
          // -- días hasta el final del semestre --
          function finalS() {
            $fin = strtotime("November 20");
            $left = ceil(($fin-time())/60/60/24);
            echo "Faltan $left días para que acabe el semestre.";
          }
          finalS();
         ?>
      </div>
      <div id="preguntas">
        <h3>¿Qué hace la función phpinfo()?</h3>

        Muestra información sobre la configuración de PHP (opciones de compilación, extensiones, versión, etc.).
        <br>phpinfo() puede incluir parámetros para sólo visualizar cierta parte de la información sobre la configuración PHP.
        <br>La información se muestra en texto plano si se utiliza en una línea de comandos.
        <br>Los parámetros de la función tienen equivalentes entre dígitos y palabras (Ejemplo: phpinfo(32) = phpinfo(INFO_VARIABLES)).

        <h3>¿Qué cambios tendrías que hacer en la configuración del servidor para que pudiera ser apto en un ambiente
        de producción?</h3>

        En base a diferentes criterios, la configuración debe permitir la realización de consultas de manera sencilla
        para hacer al servidor lo más accesible posible.

        <h3>¿Cómo es que si el código está en un archivo con código html que se despliega del lado del cliente, se ejecuta
        del lado del servidor?</h3>

        Todo el código de PHP es ejecutado antes de que el servidor mande la respuesta de petición de página del usuario.
        El archivo enviado al usuario después de la ejecución del PHP está en el formato de html por completo.

      </div>
    </div>
  </body>
</html>
