#!/bin/bash

## FUNCTIONS

logo() {
clear
cat << "EOF"
█▀▄ █▀█ █ █ █▀█ █   █▀█ █▀█ █▀▄ █▀▀ █▀▄
█ █ █ █ █▄█ █ █ █   █ █ █▀█ █ █ █▀▀ █▀▄
▀▀  ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀ ▀ ▀▀  ▀▀▀ ▀ ▀
EOF

}

# function to lowercase a string variable
lowercase () {
  printf $(printf $1 | tr '[:upper:]' '[:lower:]')
}

logo
printf "checking updates.."

# Download/update video, image or audio
pip3 install gallery-dl yt-dlp --upgrade -q


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  images="~/Pictures/"
  vid_path="~/Videos/"
  music_path="~/Music/"
  config="~/.config/gallery-dl/config.json"
  printf '%s\n' "OS = Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  printf '%s\n' "OS = MacOS"
elif [[ "$OSTYPE" == "cygwin" ]]; then
  # POSIX compatibility layer and Linux environment emulation for Windows
  printf '%s\n' "OS = Windows WSL"
elif [[ "$OSTYPE" == "msys" ]]; then
  # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
  printf '%s\n' "OS = Windows MinGW"
elif [[ "$OSTYPE" == "win32" ]]; then
  # I'm not sure this can happen.
  printf '%s\n' "OS = Windows"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
  # ...
  printf '%s\n' "OS = Linux freebsd"
elif [[ "$OSTYPE" == *"android"* ]]; then
  # ...
  # Default Paths
  images="/storage/emulated/0/Pictures/Instagram/"
  vid_path="/storage/emulated/0/Movies/"
  music_path="/storage/emulated/0/Music/Download"
  config="/data/data/com.termux/files/home/downloads/config.json"
  printf '%s\n' "OS = Android"
else
        # Unknown.
        printf '%2s\n' "OS = $OSTYPE" "Not supported"
        exit 1
fi


# color code
RED="\e[31m"
GREEN="\e[32m"
DEFAULT="\e[0m"

loop=1
while [ $loop = 1 ];
do
logo

printf "[*] Choose download type:\n1. Image\n2. Video\n3. Audio\n"
read -rp "Select: " input
input=$(lowercase $input)


if [ $input = "1" ] || [ $input = "image" ];
then
printf "Image download loading.."
# Download image from Instagram URL
# Needs cookies file in config.json

while [ True ];
do
logo
printf '%2s\n' "[*] Instagram Image Download" "- Powered by gallery-dl"
read -rp "[*] Enter URL: " url 

if [ $url = "menu" ];
then break
elif [ $url = "exit" ];
then exit
else

printf '%s\n' "Attempting to save: \"$images\""
# gallery-dl -K "URL" > tmpfile and look at the possible variables of url
printf "${GREEN}"
gallery-dl --config $config $url -w -D $images  --exec "printf '[+] {_filename}\n'"
printf "${DEFAULT}"
read -p "Done." -s temp
fi
done

elif [ $input = "2" ] || [ $input = "video" ];
then
 printf "Video Download Loading.."
 # Video downloader for non-DRM sites - yt-dlp
 while [ True ];
 do
  logo
  printf "[*] Video Download (Non-DRM) \n- powered by yt-dlp.\n"
  read -rp "[*] Enter URL: " vid
  
  if [ $vid = "menu" ];
  then break
  elif [ $vid = "exit" ];
  then exit
  else
   printf '%s\n' "Downloading..."
   printf '%s\n' "Attempting to save: $vid_path"
   printf "${GREEN}"
   yt-dlp $vid -P $vid_path --output '%(title)s.%(ext)s' --quiet --exec "printf '[+] %(filename)q\n'" -t mp4
   printf "${DEFAULT}"

  read -p "Done." -s temp
  fi
 done
 
elif [ $input = "3" ] || [ $input = "audio" ];
then
 printf "Loading..."
 while [ True ];
 do
  logo
  printf "[*] Audio Downloader\n- powered by yt-dlp.\n"
  read -rp "[*] Enter URL: " song
  
  if [ $song = "menu" ];
  then break
  elif [ $song = "exit" ];
  then exit
  else
   printf '%s\n' "Downloading..."
   printf '%s\n' "Attempting to save: $music_path"
   printf "${RED}"
   yt-dlp $song -P $music_path --format mp3 --output '%(title)s.%(ext)s'
   printf "${DEFAULT}"

   read -p "Done." -s temp
  fi
 done

else
 loop=0
fi

done

printf '%s\n' "Log end"
exit 0
