<?php
  $pattern=strtolower($_GET['pattern']);
  $words=array("Fútbol", "Básquetbol", "Hockey", "Vóleibol", "Béisbol", "Softbol", "Tiro olímpico", "Danza",
              "Tenis", "Atletismo", "Tiro con arco", "Arte marcial", "Box");
  $response="";
  $size=0;
  for($i=0; $i<count($words); $i++)
  {
     $pos=stripos(strtolower($words[$i]),$pattern);
     if(!($pos===false))
     {
       $size++;
       $word=$words[$i];
       $response.="<option value=\"$word\">$word</option>";
     }
  }
  if($size>0)
    echo "<select class=\"browser-default\" id=\"list\" size=$size onclick=\"selectValue()\">$response</select>";
?>
