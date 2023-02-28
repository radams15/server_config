<?php

$url_in = $_GET["url"];
$quality = isset($_GET["quality"])? $_GET["quality"] :'best';


exec( "./yt-dlp --get-url -f '$quality' '$url_in'" , $url , $return_value  ) ;

$url = $url[0];

exec("curl -s -L -I -o /dev/null -w '%{url_effective}' '$url'", $final , $return_value  );

$out = preg_replace("/\r|\n/", "", $final[0]);

echo $out;
?>
