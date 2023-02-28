#!/bin/bash

for i in *.mp4;
  do name=`echo "$i" | cut -d'.' -f1`
  ffmpeg -i "$i" "${name}.mp3"
  rm "$i";
done
