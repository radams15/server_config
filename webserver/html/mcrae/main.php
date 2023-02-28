<?php
require 'info.php';
?>

<html>
    <head>
        <title>John McRae Soundboard</title>
        <script src="index.js"></script>
        <script
			  src="https://code.jquery.com/jquery-3.4.1.min.js"
			  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
			  crossorigin="anonymous"></script>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
        <link rel="stylesheet" type="text/css" href="style.css">
    </head>

    <body>
        
        <center>
			<?php
				foreach($clips as $name => $file){
					echo "<button class=\"btn btn-dark btn-lg\" type=\"button\" onclick=\"play_song('$file')\">$name</button>";
					echo "<br><br>";
				}
			?>
        </center>
        
        <br>
        
        <div class="slidecontainer">
            
        </div>
        
        <center>
			<input type="range" class="form-control-range" min=<?=$speed_min?> max=<?=$speed_max?> value=<?=$speed_def?> step=<?=$speed_step?> onchange="updateTextInput(this.value);" id="speed">
			<input type="text" id="valDisplay" value=1>
        </center>
        
    </body>
</html>
