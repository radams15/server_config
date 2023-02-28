<?php
require 'info.php';
if($CLOSED){
	echo "<center><b><h1>McRae Is Closed For Maintainence</h1></b></center><br>";
	echo "<center><img src='images/pain.png'></center>";
}else{
	header('Location: main.php');
}
?>
