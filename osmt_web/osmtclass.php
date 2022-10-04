<?php

// Funktion zum aufruf von opensim.sh Funktionen. Funktioniert
function abfrage(string $funktionsname)
{
    $ausgabe=null; $rueckgabewert=null;
    $datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);
    ?>

    <div class="w3-card-4 w3-sand">
    <h2>Bildschirmausgabe</h2>
    <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>

    <?php
    foreach ($ausgabe as $bildschirmausgabe)
    {
        echo "<pre>".$bildschirmausgabe."</pre>";
    }
    ?>
    </div>
    <?php
}

// Abfrage mit Titel und Information. Status OK
function abfrage1($funktionsname, $Titel, $Information1)
{
?>
<div class="w3-card-4"><div class="w3-container w3-green"><h2><?php echo $Titel; ?></h2></div>
    <p><form class="w3-container" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <?php echo $Information1; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe1"></p>
    <p><button class="w3-btn w3-green">Senden</button></p>
    </form>
</div>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") 
{
    // Wert des Eingabefeldes sammeln.
    $ergebniss2 = $_POST['ergebnisseingabe1']; trim($ergebniss2);      
    if (empty($ergebniss2)) {
        ?>    
        <div class="w3-card-4 w3-sand">
        <h2>Bildschirmausgabe</h2>
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
        <pre> Eingabe ist leer oder unvollständig!</pre></div>
        <?php
    } else {
    $ausgabe=null; $rueckgabewert=null;
    $datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $ergebniss2";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);
    ?> 	
    
    <div class="w3-card-4 w3-sand">
    <h2>Bildschirmausgabe</h2>
    <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
    
        <?php
        foreach ($ausgabe as $bildschirmausgabe)
        {
            echo "<pre>".$bildschirmausgabe."</pre>";
        }
        ?> 
    
    </div> 
    
    <?php
    }
 }
}

// Abfrage mit Titel und Information. Status OK
function abfrage2($funktionsname, $Titel, $Information1, $Information2)
{
?>
<div class="w3-card-4"><div class="w3-container w3-green"><h2><?php echo $Titel; ?></h2></div>
    <p><form class="w3-container" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <?php echo $Information1; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe1"><br/>    
    <?php echo $Information2; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe2"></p>
    <p><button class="w3-btn w3-green">Senden</button></p>
    </form>
</div>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") 
{
    // Wert des Eingabefeldes sammeln.
    $ergebniss2 = $_POST['ergebnisseingabe1']; trim($ergebniss2);
    $ergebniss3 = $_POST['ergebnisseingabe2']; trim($ergebniss3);   

    if (empty($ergebniss2) or empty($ergebniss3)) {
        ?>    
        <div class="w3-card-4 w3-sand">
        <h2>Bildschirmausgabe</h2>
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
        <pre> Eingabe ist leer oder unvollständig!</pre></div>
        <?php
    } else {
    $ausgabe=null; $rueckgabewert=null;
    $datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $ergebniss2 $ergebniss3";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);
    ?> 	
    
    <div class="alert">
    <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
    
        <?php
        foreach ($ausgabe as $bildschirmausgabe)
        {
            echo "<pre>".$bildschirmausgabe."</pre>";
        }
        ?> 
    
    </div> 
    
    <?php
    }
 }
}

// Abfrage mit Titel und Information. Status OK
function abfrage3($funktionsname, $Titel, $Information1, $Information2, $Information3)
{
?>
<div class="w3-card-4"><div class="w3-container w3-green"><h2><?php echo $Titel; ?></h2></div>
    <p><form class="w3-container" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <?php echo $Information1; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe1"><br/>    
    <?php echo $Information2; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe2"><br/>
    <?php echo $Information3; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe3"></p>
    <p><button class="w3-btn w3-green">Senden</button></p>
    </form>
</div>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") 
{
    // Wert des Eingabefeldes sammeln.
    $ergebniss2 = $_POST['ergebnisseingabe1']; trim($ergebniss2);
    $ergebniss3 = $_POST['ergebnisseingabe2']; trim($ergebniss3);
    $ergebniss4 = $_POST['ergebnisseingabe3']; trim($ergebniss4);

    if (empty($ergebniss2) or empty($ergebniss3) or empty($ergebniss4)) {
        ?>    
        <div class="w3-card-4 w3-sand">
        <h2>Bildschirmausgabe</h2>
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
        <pre> Eingabe ist leer oder unvollständig!</pre></div>
        <?php
    } else {
    $ausgabe=null; $rueckgabewert=null;
    $datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $ergebniss2 $ergebniss3 $ergebniss4";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);
    ?> 	
    
    <div class="alert">
    <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
    
        <?php
        foreach ($ausgabe as $bildschirmausgabe)
        {
            echo "<pre>".$bildschirmausgabe."</pre>";
        }
        ?> 
    
    </div> 
    
    <?php
    }
 }
}

// Abfrage mit Titel und Information. Status OK
function abfrage4($funktionsname, $Titel, $Information1, $Information2, $Information3, $Information4)
{
?>
<div class="w3-card-4"><div class="w3-container w3-green"><h2><?php echo $Titel; ?></h2></div>
    <p><form class="w3-container" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <?php echo $Information1; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe1"><br/>    
    <?php echo $Information2; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe2"><br/>
    <?php echo $Information3; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe3"><br/>
    <?php echo $Information4; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe4"></p>
    <p><button class="w3-btn w3-green">Senden</button></p>
    </form>
</div>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") 
{
    // Wert des Eingabefeldes sammeln.
    $ergebniss2 = $_POST['ergebnisseingabe1']; trim($ergebniss2);
    $ergebniss3 = $_POST['ergebnisseingabe2']; trim($ergebniss3);
    $ergebniss4 = $_POST['ergebnisseingabe3']; trim($ergebniss4);
    $ergebniss5 = $_POST['ergebnisseingabe4']; trim($ergebniss5);

    if (empty($ergebniss2) or empty($ergebniss3) or empty($ergebniss4) or empty($ergebniss5)) {
        ?>    
        <div class="w3-card-4 w3-sand">
        <h2>Bildschirmausgabe</h2>
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
        <pre> Eingabe ist leer oder unvollständig!</pre></div>
        <?php
    } else {
    $ausgabe=null; $rueckgabewert=null;
    $datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $ergebniss2 $ergebniss3 $ergebniss4 $ergebniss5";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);
    ?> 	
    
    <div class="alert">
    <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
    
        <?php
        foreach ($ausgabe as $bildschirmausgabe)
        {
            echo "<pre>".$bildschirmausgabe."</pre>";
        }
        ?> 
    
    </div> 
    
    <?php
    }
 }
}

// Abfrage mit Titel und Information. Status OK
function abfrage5($funktionsname, $Titel, $Information1, $Information2, $Information3, $Information4, $Information5)
{
?>
<div class="w3-card-4"><div class="w3-container w3-green"><h2><?php echo $Titel; ?></h2></div>
    <p><form class="w3-container" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <?php echo $Information1; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe1"><br/>    
    <?php echo $Information2; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe2"><br/>
    <?php echo $Information3; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe3"><br/>
    <?php echo $Information4; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe4"><br/>
    <?php echo $Information5; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe5"></p>
    <p><button class="w3-btn w3-green">Senden</button></p>
    </form>
</div>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") 
{
    // Wert des Eingabefeldes sammeln.
    $ergebniss2 = $_POST['ergebnisseingabe1']; trim($ergebniss2);
    $ergebniss3 = $_POST['ergebnisseingabe2']; trim($ergebniss3);
    $ergebniss4 = $_POST['ergebnisseingabe3']; trim($ergebniss4);
    $ergebniss5 = $_POST['ergebnisseingabe4']; trim($ergebniss5);
    $ergebniss6 = $_POST['ergebnisseingabe5']; trim($ergebniss6);

    if (empty($ergebniss2) or empty($ergebniss3) or empty($ergebniss4) or empty($ergebniss5) or empty($ergebniss6)) {
        ?>    
        <div class="w3-card-4 w3-sand">
        <h2>Bildschirmausgabe</h2>
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
        <pre> Eingabe ist leer oder unvollständig!</pre></div>
        <?php
    } else {
    $ausgabe=null; $rueckgabewert=null;
    $datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $ergebniss2 $ergebniss3 $ergebniss4 $ergebniss5 $ergebniss6";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);
    ?> 	
    
    <div class="alert">
    <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
    
        <?php
        foreach ($ausgabe as $bildschirmausgabe)
        {
            echo "<pre>".$bildschirmausgabe."</pre>";
        }
        ?> 
    
    </div> 
    
    <?php
    }
 }
}

// Abfrage mit Titel und Information. Status OK
function abfrage6($funktionsname, $Titel, $Information1, $Information2, $Information3, $Information4, $Information5, $Information6)
{
?>
<div class="w3-card-4"><div class="w3-container w3-green"><h2><?php echo $Titel; ?></h2></div>
    <p><form class="w3-container" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <?php echo $Information1; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe1"><br/>    
    <?php echo $Information2; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe2"><br/>
    <?php echo $Information3; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe3"><br/>
    <?php echo $Information4; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe4"><br/>
    <?php echo $Information5; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe5"><br/>
    <?php echo $Information6; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe6"></p>
    <p><button class="w3-btn w3-green">Senden</button></p>
    </form>
</div>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") 
{
    // Wert des Eingabefeldes sammeln.
    $ergebniss2 = $_POST['ergebnisseingabe1']; trim($ergebniss2);
    $ergebniss3 = $_POST['ergebnisseingabe2']; trim($ergebniss3);
    $ergebniss4 = $_POST['ergebnisseingabe3']; trim($ergebniss4);
    $ergebniss5 = $_POST['ergebnisseingabe4']; trim($ergebniss5);
    $ergebniss6 = $_POST['ergebnisseingabe5']; trim($ergebniss6);
    $ergebniss7 = $_POST['ergebnisseingabe6']; trim($ergebniss7);

    if (empty($ergebniss2) or empty($ergebniss3) or empty($ergebniss4) or empty($ergebniss5) or empty($ergebniss6) or empty($ergebniss7)) {
        ?>    
        <div class="w3-card-4 w3-sand">
        <h2>Bildschirmausgabe</h2>
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
        <pre> Eingabe ist leer oder unvollständig!</pre></div>
        <?php
    } else {
    $ausgabe=null; $rueckgabewert=null;
    $datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $ergebniss2 $ergebniss3 $ergebniss4 $ergebniss5 $ergebniss6 $ergebniss7";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);
    ?> 	
    
    <div class="alert">
    <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
    
        <?php
        foreach ($ausgabe as $bildschirmausgabe)
        {
            echo "<pre>".$bildschirmausgabe."</pre>";
        }
        ?> 
    
    </div> 
    
    <?php
    }
 }
}

// Abfrage mit Titel und Information. Status OK
function abfrage7($funktionsname, $Titel, $Information1, $Information2, $Information3, $Information4, $Information5, $Information6, $Information7)
{
?>
<div class="w3-card-4"><div class="w3-container w3-green"><h2><?php echo $Titel; ?></h2></div>
    <p><form class="w3-container" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <?php echo $Information1; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe1"><br/>    
    <?php echo $Information2; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe2"><br/>
    <?php echo $Information3; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe3"><br/>
    <?php echo $Information4; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe4"><br/>
    <?php echo $Information5; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe5"><br/>
    <?php echo $Information6; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe6"><br/>
    <?php echo $Information7; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe7"></p>
    <p><button class="w3-btn w3-green">Senden</button></p>
    </form>
</div>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") 
{
    // Wert des Eingabefeldes sammeln.
    $ergebniss2 = $_POST['ergebnisseingabe1']; trim($ergebniss2);
    $ergebniss3 = $_POST['ergebnisseingabe2']; trim($ergebniss3);
    $ergebniss4 = $_POST['ergebnisseingabe3']; trim($ergebniss4);
    $ergebniss5 = $_POST['ergebnisseingabe4']; trim($ergebniss5);
    $ergebniss6 = $_POST['ergebnisseingabe5']; trim($ergebniss6);
    $ergebniss7 = $_POST['ergebnisseingabe6']; trim($ergebniss7);
    $ergebniss8 = $_POST['ergebnisseingabe7']; trim($ergebniss8);

    if (empty($ergebniss2) or empty($ergebniss3) or empty($ergebniss4) or empty($ergebniss5) or empty($ergebniss6) or empty($ergebniss7) or empty($ergebniss8)) {
        ?>    
        <div class="w3-card-4 w3-sand">
        <h2>Bildschirmausgabe</h2>
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
        <pre> Eingabe ist leer oder unvollständig!</pre></div>
        <?php
    } else {
    $ausgabe=null; $rueckgabewert=null;
    $datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $ergebniss2 $ergebniss3 $ergebniss4 $ergebniss5 $ergebniss6 $ergebniss7 $ergebniss8";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);
    ?> 	
    
    <div class="alert">
    <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
    
        <?php
        foreach ($ausgabe as $bildschirmausgabe)
        {
            echo "<pre>".$bildschirmausgabe."</pre>";
        }
        ?> 
    
    </div> 
    
    <?php
    }
 }
}

// Abfrage mit Titel und Information. Status OK
function abfrage8($funktionsname, $Titel, $Information1, $Information2, $Information3, $Information4, $Information5, $Information6, $Information7, $Information8)
{
?>
<div class="w3-card-4"><div class="w3-container w3-green"><h2><?php echo $Titel; ?></h2></div>
    <p><form class="w3-container" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <?php echo $Information1; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe1"><br/>    
    <?php echo $Information2; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe2"><br/>
    <?php echo $Information3; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe3"><br/>
    <?php echo $Information4; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe4"><br/>
    <?php echo $Information5; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe5"><br/>
    <?php echo $Information6; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe6"><br/>
    <?php echo $Information7; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe7"><br/>
    <?php echo $Information8; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe8"></p>
    <p><button class="w3-btn w3-green">Senden</button></p>
    </form>
</div>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") 
{
    // Wert des Eingabefeldes sammeln.
    $ergebniss2 = $_POST['ergebnisseingabe1']; trim($ergebniss2);
    $ergebniss3 = $_POST['ergebnisseingabe2']; trim($ergebniss3);
    $ergebniss4 = $_POST['ergebnisseingabe3']; trim($ergebniss4);
    $ergebniss5 = $_POST['ergebnisseingabe4']; trim($ergebniss5);
    $ergebniss6 = $_POST['ergebnisseingabe5']; trim($ergebniss6);
    $ergebniss7 = $_POST['ergebnisseingabe6']; trim($ergebniss7);
    $ergebniss8 = $_POST['ergebnisseingabe7']; trim($ergebniss8);
    $ergebniss9 = $_POST['ergebnisseingabe8']; trim($ergebniss9);

    if (empty($ergebniss2) or empty($ergebniss3) or empty($ergebniss4) or empty($ergebniss5) or empty($ergebniss6) or empty($ergebniss7) or empty($ergebniss8) or empty($ergebniss9)) {
        ?>    
        <div class="w3-card-4 w3-sand">
        <h2>Bildschirmausgabe</h2>
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
        <pre> Eingabe ist leer oder unvollständig!</pre></div>
        <?php
    } else {
    $ausgabe=null; $rueckgabewert=null;
    $datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $ergebniss2 $ergebniss3 $ergebniss4 $ergebniss5 $ergebniss6 $ergebniss7 $ergebniss8 $ergebniss9";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);
    ?> 	
    
    <div class="alert">
    <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
    
        <?php
        foreach ($ausgabe as $bildschirmausgabe)
        {
            echo "<pre>".$bildschirmausgabe."</pre>";
        }
        ?> 
    
    </div> 
    
    <?php
    }
 }
}
// Class Ende
?>
