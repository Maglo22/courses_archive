<?php
  require_once('../rest.php');
  include('../_header.html');
  $str = $_GET['str'];
  if(isset($_GET['str'])){
    getCount(urlencode($str));
  }
  include('../_footer.html');
?>
