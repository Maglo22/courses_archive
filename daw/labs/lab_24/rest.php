<?php
  function getNum($num){
    $url = "http://localhost/Lab24/Lab24/public/$num"; //Route to the REST web service
    $c = curl_init($url);
    $response = curl_exec($c);
    curl_close($c);
  }

  function getCount($str){
    $url = "http://localhost/Lab24/Lab24/public/count/$str"; //Route to the REST web service
    $c = curl_init($url);
    $response = curl_exec($c);
    curl_close($c);
  }
?>
