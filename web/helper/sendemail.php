#!/usr/bin/php

<?php
//php 8.x

// ; E-Mail einrichten:
// apt install sendmail
// sendmailconfig (alles mit yes bestätigt)

function guidv4($data = null) {
    // Generate 16 bytes (128 bits) of random data or use the data passed into the function.
    $data = $data ?? random_bytes(16);
    assert(strlen($data) == 16);

    // Set version to 0100
    $data[6] = chr(ord($data[6]) & 0x0f | 0x40);
    // Set bits 6-7 to 10
    $data[8] = chr(ord($data[8]) & 0x3f | 0x80);

    // Output the 36 character UUID.
    return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
}

function sendemail($empfaenger, $gridname, $email) 
{
    $myuuid = guidv4();
    
    $betreff = "Registrierung $gridname";
    $from = "From: $gridname <$email>";
    $text = "Bitte tragen sie folgende Bestaetigungsnummer ein:\n $myuuid";
    
	mail($empfaenger, $betreff, $text, $from);
}

// Send:
$empfaenger = 'other@web.com';
$email = 'myGRID@web.com';
$gridname = 'MYGRID';
sendemail($empfaenger, $gridname, $email);
?>
