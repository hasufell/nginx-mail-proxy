<?php
/*
Nginx sends headers as
Auth-User: somuser
Auth-Pass: somepass
On my php app server these are seen as
HTTP_AUTH_USER and HTTP_AUTH_PASS
*/
if (!isset($_SERVER["HTTP_AUTH_USER"] ) || !isset($_SERVER["HTTP_AUTH_PASS"] )){
  fail();
}
$username=$_SERVER["HTTP_AUTH_USER"] ;
$userpass=$_SERVER["HTTP_AUTH_PASS"] ;
$protocol=$_SERVER["HTTP_AUTH_PROTOCOL"] ;
$method=$_SERVER["HTTP_AUTH_METHOD"];
// default backend port
$backend_port=110;
if ($protocol=="imap") {
  $backend_port=143;
}
if ($protocol=="smtp") {
  $backend_port=25;
}

// Authenticate the user or fail
if (!authuser($username,$userpass)){
  fail();
  exit;
}

// Get the server for this user if we have reached so far
$userserver=getmailserver($username);
// Get the ip address of the server
$server_ip=$userserver;
// Pass!
pass($server_ip, $backend_port);


function authuser($user,$pass){
  return true;
}

function getmailserver($user){
  $myFile = "/var/www/tmp/addr";
  $fh = fopen($myFile, 'r');
  $theData = fread($fh, filesize($myFile));
  fclose($fh);

  return "$theData";
}

function fail(){
  header("Auth-Status: Invalid login or password");
  exit;
}

function pass($server,$port){
  header("Auth-Status: OK");
  header("Auth-Server: $server");
  header("Auth-Port: $port");
  exit;
}

