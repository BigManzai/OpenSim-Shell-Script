<!-- TUTORIAL-ARTIKEL: http://www-coding.de/so-gehts-eigenes-captcha-mit-php/ -->

<!--
		1. Teil
		
		Binde diesen Code dort ein, wo das Captcha angezeigt werden soll, also innerhalb eines Formulars.
		Wenn die captcha.php nicht im selben Verzeichnis liegt musst Du diesen Pfad (src="") entsprechend anpassen.
-->
<img src="captcha.php?RELOAD=" alt="Captcha" title="Klicken, um das Captcha neu zu laden" onclick="this.src+=1;document.getElementById('captcha_code').value='';" width=140 height=40 />

<!--
		2. Teil
		
		Außerdem benötigst Du noch ein Textfeld mit dem Namen "captcha_code", welches auch in das Formular eingebaut werden muss.
		Das Textfeld kann zum Beispiel so aussehen:
-->
<input type="text" name="captcha_code" id="captcha_code" size=10 />


<!--
		3. Teil
		
		Sobald das Formular abgesendet wurde, musst du den Code auf einer PHP-Seite prüfen.
		Dieser Ausschnitt zeigt Dir, welche Code-Teile in deiner PHP-Seite enthalten sein müssen.
-->
<?php
	// Ganz oben, vor irgendeiner Ausgabe: //
	session_start();
	
	// Bearbeiten des Formulars //
	if ($_POST['captcha_code'] == $_SESSION['captcha_spam']) {
		// Das Captcha wurde korrekt ausgefüllt //
		
		// [HIER] kann jetzt der PHP-Code hin, den vorher ohnehin genutzt hast, um das Formular zu verarbeiten.

	} else {
		// Captcha wurde falsch ausgefüllt, Fehler ausgeben. //
		echo 'Du hast den Captcha-Code falsch eingegeben!';
	}
?>

<!--
		4. Hinweis
		
		Wir hoffen, dass Dir dieses Captcha geholfen hat.
		Solltest du Fragen oder Verbesserungsvorschläge haben, so kannst Du Dich über die folgende Seite mit uns in Verbindung setzen:
		http://www-coding.de/so-gehts-eigenes-captcha-mit-php/
-->
