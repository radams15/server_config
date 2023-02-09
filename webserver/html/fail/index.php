<html>

<?php
$SAVE_FILE = 'save.json';

$content = file_get_contents($SAVE_FILE);

$stats = json_decode($content, true);

if(isset($_POST['name'])){
	$name = $_POST['name'];
	$stats[$name] = time();
	$toSave = json_encode($stats);

	file_put_contents($SAVE_FILE, $toSave);
}
?>

<head>
	<link rel="stylesheet" href="style.css">
</head>

<body>
<?php
	foreach ($stats as $name => $lastFail):
		
		$currentTime = time();
		$sinceFailSecs = $currentTime-$lastFail;

		$sinceFail = floor($sinceFailSecs / (60*60*24));
?>

			<div class="personBox">
			<form method="POST" onsubmit="return confirm('Are you sure there has been a fail?');">
				<h1><?=$name?></h1>
				<h2>Has been fail free for <?=$sinceFail?> days!</h2>

				<input type="hidden" name="name" value="<?=$name?>">
				<input type="submit" value="Fail!"> 
			</form>
		</div>

<?php endforeach; ?>

</body>

</html>
