#!/usr/bin/env bash

function ASK {
echo "Are you SURE you want to remove ALL nextcloud data?"
echo "this includes user data,files, apps, etc"
echo "best to cancel and backup if unsure"
echo "[y] Yes --or-- [n] No"
read ANSWER
case $ANSWER in
	[nN]) echo "quitting per request"
		exit 1
		;;
	[yY]) sudo rm -rf apps/* config/* data/* db/*
		exit 0	
		;;
	*)	
		ASK
	esac
}

ASK		
