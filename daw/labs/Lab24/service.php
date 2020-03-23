<?php
  require_once('rest.php');
  include('_header.html');
  $num = $_GET['num'];
  if(isset($_GET['num'])){
    getNum($num);
  }
  include('_footer.html');
?>
