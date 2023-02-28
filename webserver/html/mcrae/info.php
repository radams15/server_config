<?php
$CLOSED = false;

$speed_def = 1;
$speed_max = 2;
$speed_min = 0.1;
$speed_step = 0.05;

$clips = Array();

$dir = new DirectoryIterator("./clips/");
foreach ($dir as $fileinfo) {
    if (!$fileinfo->isDot()) {
        if($fileinfo->getExtension() == "mp3"){
            $file = $fileinfo->getFilename();
            $name = str_replace(".mp3", "", $file);
            $file = addslashes($file);
            $clips[$name] = $file;
        }
    }
}
