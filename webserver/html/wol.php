<?php

$REAL_PASSWORD = "WakeMyPc";

$password = $_POST["password"];
$mac = "d4:c9:ef:53:8a:27";
$ip = "192.168.1.249";

if($password == $REAL_PASSWORD){
	shell_exec("perl wakeonlan -i '$ip' -p 9 '$mac'");
}

?>

<html>

	<head>
		<title>Wake-On-Lan</title>
	</head>

	<body>
		<form action="/wol.php" method="POST">
			<input type="password" id="password" name="password"><br>
			<input type="submit" value="Submit">
		</form>
	</body>

</html>
