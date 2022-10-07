<?php
function abfrage($parameter)
{
    // $parameter[0] ist der Namen der Bash Funktion.
    //$zusammengesetzt = "/opt/opensim.sh " . $parameter[0];


    echo "Parameteranzahl: " . count($parameter);
    ?> <br> <?php
    if (count($parameter) == 0) { $zusammengesetzt = "/opt/opensim.sh " . $parameter[0]; }
    if (count($parameter) == 1) { $zusammengesetzt = "/opt/opensim.sh " . $parameter[0]; }
    if (count($parameter) == 2) { $zusammengesetzt = "/opt/opensim.sh " . $parameter[0]. " " . $parameter[1]; }
    if (count($parameter) == 3) { $zusammengesetzt = "/opt/opensim.sh " . $parameter[0]. " " . $parameter[1]. " " . $parameter[2]; }
    if (count($parameter) == 4) { $zusammengesetzt = "/opt/opensim.sh " . $parameter[0]. " " . $parameter[1]. " " . $parameter[2]. " " . $parameter[3]; }
    if (count($parameter) == 5) { $zusammengesetzt = "/opt/opensim.sh " . $parameter[0]. " " . $parameter[1]. " " . $parameter[2]. " " . $parameter[3]. " " . $parameter[4]; }
    if (count($parameter) == 6) { $zusammengesetzt = "/opt/opensim.sh " . $parameter[0]. " " . $parameter[1]. " " . $parameter[2]. " " . $parameter[3]. " " . $parameter[4]. " " . $parameter[5]; }
    if (count($parameter) == 7) { $zusammengesetzt = "/opt/opensim.sh " . $parameter[0]. " " . $parameter[1]. " " . $parameter[2]. " " . $parameter[3]. " " . $parameter[4]. " " . $parameter[5]. " " . $parameter[6]; }
    if (count($parameter) == 8) { $zusammengesetzt = "/opt/opensim.sh " . $parameter[0]. " " . $parameter[1]. " " . $parameter[2]. " " . $parameter[3]. " " . $parameter[4]. " " . $parameter[5]. " " . $parameter[6]. " " . $parameter[7]; }
    if (count($parameter) == 9) { $zusammengesetzt = "/opt/opensim.sh " . $parameter[0]. " " . $parameter[1]. " " . $parameter[2]. " " . $parameter[3]. " " . $parameter[4]. " " . $parameter[5]. " " . $parameter[6]. " " . $parameter[7]. " " . $parameter[8]; }

    echo "Zusammengesetzt: $zusammengesetzt";
    ?> <br> <?php

    exec($zusammengesetzt, $ausgabe, $rueckgabewert);
    foreach ($ausgabe as $bildschirmausgabe)
    {
        echo "<pre>".$bildschirmausgabe."</pre>";
    }
}
