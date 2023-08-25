<?php
	/* DIESEN CODE AN OBERSTER STELLE BELASSEN */
	header('Content-Type: text/html; charset=utf-8'); // WENN DU KEIN UTF-8 NUTZT, DIESE ZEILE LÖSCHEN UND DAS SKRIPT ENTSPRECHEND ANPASSEN!
	session_start();
?>


<!-- Hier kann der Inhalt deiner Seite vor das OpenSim Registrierung platziert werden -->
<?php
// Verbinden mit deiner E-Mail
	$adminMail = 'deine@email.de';

	/* Tristan Radtke, 2022.
	 * Dieses Skript darf frei verwendet werden. Bitte entferne nicht die Urheber- und Anleitungshinweise.
	 * http://www-coding.de/individuelles-kontaktformular-mit-captcha-in-php/ (MEHR INFORMATIONEN UND ANLEITUNG)
	 *
	 * [VERSION MIT CAPTCHA]
	 *
	 * Dieser 1. Teil kann angepasst werden, um die Formularfelder zu beeinflussen ($fields)
	 * Außerdem solltest Du in $adminMail deine E-Mail-Adresse speichern, $fromMail kannst du anpassen (wenn gewünscht)
	 * $formTitle beinhaltet die Überschrift des Formulars
	 * In $msgInfo ist der Hinweistext gespeichert, der angezeigt werden soll
	 * $datenschutzLink erhält den Link auf deine Datenschutz-Erklärung (WICHTIG: Link anpassen!)
	 * $msgError wird angezeigt, wenn nicht alle Pflichtfelder ausgefüllt wurden
	 * $msgSent hingegen beinhaltet eine Erfolgsmeldung, wenn die Anfrage verschickt wurde
	 * Speichere in $captchaPath den Pfad von der aktuellen Datei aus zur captcha.php
	 */
	
	
	$fromMail = "noreply@".$_SERVER['HTTP_HOST'];	
	$formTitle = 'OpenSim Registrierung';
	$msgInfo = 'Mit * gekennzeichnete Felder sind Pflichtfelder.';
	$msgError = 'Es ist ein Fehler aufgetreten: Es wurden nicht alle Felder korrekt ausgefüllt oder das Formular wurde mehrmals hintereinander abgeschickt.';
	$msgSent = 'Ihre Anfrage wurde erfolgreich verschickt.';
	$datenschutzLink = "/LINK-ZUR-DATENSCHUTZERKLAERUNG";
	$captchaPath = 'captcha/captcha.php';
	
	$fields = array	(
						// 'Feldname'		=> Typ (select/text/url/tel/email/textarea/radio/checkbox/date/datetime-local/file/_copy/_consent), Pflichtfeld?, Placeholder (insb. bei checkbox ignoriert), Ergänzungen (z.B. bei select-, radio-, checkbox- und file-Feld)
						'Anrede' 			=> array('select', true, 'Anrede', array('Frau', 'Herr', 'divers')),
		//Alternativ:  	'Anrede' 			=> array('radio', true, '', array('Frau', 'Herr', 'divers')),
						'Vorname' 			=> array('text', true, 'Vorname'),
						'Nachname'			=> array('text', true, 'Nachname'),
						'Straße'			=> array('text', false, 'Straße Hausnr.'),
						'PLZ und Stadt'		=> array('text', false, 'PLZ Stadt'),
						//'Telefon'			=> array('tel', false, 'Telefon'),
						//'Website'			=> array('url', false, 'Website'),
						'E-Mail-Adresse'	=> array('email', true, 'E-Mail-Adresse'), // Wichtig: Feldname darf nicht 'email'/'Email' lauten!
						//'Betreff' 			=> array('text', false, 'Betreff'),
						'Mitteilung' 		=> array('textarea', false, 'Hier können Sie eine Mitteilung eingeben...'),
						//'Newsletter' 		=> array('checkbox', false, '', 'Ich möchte den Newsletter empfangen'),
						//'Erreichbarkeit'	=> array('checkbox', false, '', array('tel' => 'Telefon', 'email' => 'E-Mail', 'post' => 'Post')),
						//'Gewünschter Termin' 	=> array('date', false, ''),
						//ACHTUNG: Versand von Viren möglich! 'Datei'			=> array('file', false, '', array('max_size' => 5 * 1024 * 1024, 'accept' => 'image/png, image/jpeg')), // Dateigröße entspricht 5 MB
						'Kopie an mich'		=> array('_copy', false, '', 'Ich möchte eine Kopie der E-Mail erhalten'),
						//'Einwilligung'		=> array('_consent', true, '', "Ich willige ein, dass für die Bearbeitung der Anfrage die übermittelten Daten gemäß der <a href=\"".$datenschutzLink."\">Datenschutz-Erklärung</a> verarbeitet werden. Die Einwilligung kann jederzeit mit Wirkung für die Zukunft widerrufen werden."),
						'Avatar Vorname' 			=> array('text', true, 'Avatar_Vorname'),
						'Avatar Nachname'			=> array('text', true, 'Avatar_Nachname'),
						'Avatar Passwort'			=> array('password', true, 'Avatar_Passwort'),
					);
	
	/* Funktion um aus den Feldnamen eine URL-Form zu erstellen (AB HIER BITTE NUR NOCH EVENTUELLE TEXTE ANPASSEN) */
	function field2url($fieldname) {
		return "f_".preg_replace('/([^a-z0-9-_]+)/', '', strtolower($fieldname));
	}

	function gen_uuid() {
		$uuid = array(
		 'time_low'  => 0,
		 'time_mid'  => 0,
		 'time_hi'  => 0,
		 'clock_seq_hi' => 0,
		 'clock_seq_low' => 0,
		 'node'   => array()
		);
		
		$uuid['time_low'] = mt_rand(0, 0xffff) + (mt_rand(0, 0xffff) << 16);
		$uuid['time_mid'] = mt_rand(0, 0xffff);
		$uuid['time_hi'] = (4 << 12) | (mt_rand(0, 0x1000));
		$uuid['clock_seq_hi'] = (1 << 7) | (mt_rand(0, 128));
		$uuid['clock_seq_low'] = mt_rand(0, 255);
		
		for ($i = 0; $i < 6; $i++) {
		 $uuid['node'][$i] = mt_rand(0, 255);
		}
		
		$uuid = sprintf('%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x',
		 $uuid['time_low'],
		 $uuid['time_mid'],
		 $uuid['time_hi'],
		 $uuid['clock_seq_hi'],
		 $uuid['clock_seq_low'],
		 $uuid['node'][0],
		 $uuid['node'][1],
		 $uuid['node'][2],
		 $uuid['node'][3],
		 $uuid['node'][4],
		 $uuid['node'][5]
		);
		
		return $uuid;
	   }
	
	/* Ausgabe des Formulars  */
	if (isset($_POST['send']) && isset($_POST['captcha_code'])) {
		// 2. Eingaben prüfen //
		$mailSubject = 'OpenSim Grid Registrierungsanfrage';
		$mailText = "Die OpenSim Registrierung deiner Website wurde dazu verwendet, Dir diese Nachricht zukommen zulassen.\r\n\r\n";
		$mailTextCopy = "Hiermit erhalten Sie eine Kopie Ihrer Kontaktanfrage.\r\n\r\n";
		$mailHeader = "From: ".$fromMail."\r\n"."Mime-Version: 1.0\r\n"."Content-type: text/plain; charset=utf-8"."\r\n";
		$email = null;		
		$mailCopy = false;

		// Einzelne Felder auslesen //
		foreach ($fields AS $name => $settings) {
			$fname = field2url($name);

			if ($settings[0] == 'file') {
				// Dateiupload //
				$acceptFiles = array();				

				if (isset($settings[3]['accept'])) {
					// Aufbereitung der akzeptierten Dateitypen für sogleich folgende Prüfung //
					$acceptFiles = explode(",", str_replace(' ', '', strtolower($settings[3]['accept'])));
				}				

				if ( (!isset($_FILES[$fname]['size'])) || $_FILES[$fname]['size'] == 0 || $_FILES[$fname]['error'] > 0) {
					if ($settings[1]) {
						// Pflichtupload nicht durchgeführt => Abbruch //
						$sent = false;
						break;
					} else {
						// Keine Datei hochgeladen => Ignorieren //
						continue;
					}
				} else if (isset($settings[3]['max_size']) && $_FILES[$fname]['size'] > $settings[3]['max_size'])  {
					// Datei zu groß //
					$sent = false;
					break;
				} else if (is_array($acceptFiles) && count($acceptFiles) > 0 && !in_array(strtolower($_FILES[$fname]['type']), $acceptFiles) ) {
					// Unzulässiger Dateityp //
					$sent = false;
					break;
				} else {
					// Datei anhängen //
					$mailAttachments[] = array(
						'name' => $_FILES[$fname]['name'],
						'type' => $_FILES[$fname]['type'],
						'path' => $_FILES[$fname]['tmp_name']);
				}	
			} else if ( !( !$settings[1] || ( $settings[1] && isset($_POST[$fname]) && $_POST[$fname] != '' ) ) ) {
				// Pflichtfeld nicht ausgefüllt => Abbruch //
				$sent = false;
				break;
			} else if (isset($_POST[$fname]) && $_POST[$fname] != '') {
				// Inhalt (wenn nicht leer) in die E-Mail schreiben //
				$mailText .= $name.": ".((is_array($_POST[$fname])) ? implode(", ", $_POST[$fname]) : $_POST[$fname])."\r\n";
				
				// E-Mail-Adresse als Absender setzen //
				if ($settings[0] == 'email' && filter_var($_POST[$fname], FILTER_VALIDATE_EMAIL)) {
					$mailHeader = "From: ".$_POST[$fname]."\r\n";	
					$email = $_POST[$fname];
				}
				
				// Betreff auch in den Betreff der E-Mail übernehmen //
				if ($name == "Betreff") {
					$mailSubject .= ": ".$_POST[$fname];
				}

				// E-Mail Kopie verschicken //
				if ($settings[0] == '_copy' && $_POST[$fname] == 'gesetzt') {
					$mailCopy = true;											
				}
			}
		}
		
		// Kurzer Spam-Check inkl. Captcha-Check //
		if ( ( isset($_POST['email']) && $_POST['email'] != '' ) || ( $_POST['captcha_code'] != $_SESSION['captcha_spam'] ) ) {
			// Bot => Abbruch //
			$sent = false;
		}

		// Doppeltes Senden verhindern //
		if (isset($_SESSION['contactFormSent']) && hash('sha256', $mailText) == $_SESSION['contactFormSent']) {
			$sent = false;
		}
		
		if (!isset($sent)) {
			// Nach erfolgreicher Überprüfung E-Mail verschicken //			
			
			if (is_countable($mailAttachments) && count($mailAttachments) == 0) {
				// E-Mail ohne Anhänge //
				mail($adminMail, $mailSubject, $mailText, $mailHeader."Content-type: text/plain; charset=utf-8"."\r\n");
			
				// Gegebenfalls Kopie für Versender //
				if ($mailCopy && !empty($email)) {
					mail($email, "Kopie: ".$mailSubject, $mailTextCopy.$mailText, "From: ".$fromMail."\r\n"."Mime-Version: 1.0\r\n"."Content-type: text/plain; charset=utf-8"."\r\n");
				}
			} else {
				// E-Mail mit Anhängen //
				$mime_boundary = md5(uniqid(microtime(), true));

				$addMailHeader = 	"MIME-Version: 1.0\r\n". 
							"Content-Type: multipart/mixed; boundary=\"".$mime_boundary."\"\r\n";
 
 				$content  = 	"This is a multi-part message in MIME format.\r\n\r\n" .
						"--".$mime_boundary."\r\n" .
						"Content-Type: text/plain; charset=utf-8\r\n" .
						"Content-Transfer-Encoding: 8bit\r\n\r\n" .
						"__PLACEHOLDER_COPY__".$mailText."\r\n";

				foreach ($mailAttachments AS $att) {
					$content .= 	"--".$mime_boundary."\r\n" .
							"Content-Type: ".$att['type']."; name=\"".$att['name']."\"\r\n" .    			    				
							"Content-Transfer-Encoding: base64\r\n" .
							"Content-Disposition: attachment\r\n\r\n" .
         						chunk_split(base64_encode(file_get_contents($att['path'])))."\n";
				}

				mail($adminMail, $mailSubject, preg_replace('/__PLACEHOLDER_COPY__/', '', $content, 1)."\r\n--".$mime_boundary."--", $mailHeader.$addMailHeader);

				// Gegebenfalls Kopie für Versender //
				if ($mailCopy && !empty($email)) {
					mail($email, "Kopie: ".$mailSubject, preg_replace('/__PLACEHOLDER_COPY__/', $mailTextCopy, $content, 1)."\r\n--".$mime_boundary."--", "From: ".$fromMail."\r\n".$addMailHeader);
				}
			}

			// Verschicken

			echo "<h1>".$formTitle."</h1>" .
					"<p>".$msgSent."</p>";

			$sent = true;

			// Erfolgreiches Senden speichern, um direkt erneutes Senden zu verhindern //
			$_SESSION['contactFormSent'] = hash('sha256', $mailText);
		}
	} else {
		$sent = false;

		// Aufruf ohne Senden -> Variable löschen, um Senden wieder zu ermöglichen //
		unset($_SESSION['contactFormSent']);
	}

	if (!$sent) {
		// 3. Formular ausgeben (Beginn des Formulars) //
		echo "<h1>".$formTitle."</h1>" .
			 "<title>OpenSim login system</title>" .
			 "<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor\" crossorigin=\"anonymous\">" .
			 "<link rel=\"stylesheet\" href=\"./css/main.css\">" .
			 "<p>".$msgInfo."</p>" .
				((isset($_POST['send'])) ? "<p class=\"contactError\">".$msgError."</p>" : '') .
				"<form enctype=\"multipart/form-data\" action=\"?".$_SERVER['QUERY_STRING']."\" method=\"POST\">" .
					'<table>';
				
		// Felder auslesen //
		$i = 0;

		foreach ($fields AS $name => $settings) {
			// Ausgabe je nach Typ //
			switch ($settings[0]) {
				case 'select':
					// Select-Feld //
					echo "<tr><td class=\"contactSubjectTd\">".$name.":".(($settings[1]) ? ' (*)' : '')."</td><td class=\"contactInputTd\"><select class=\"contactField\" name=\"".field2url($name)."\"".(($settings[1]) ? ' required' : '').">";
					
					// Select-Felder auslesen //
					echo "<option value=\"\" disabled selected hidden>".((!empty($settings[2])) ? $settings[2] : 'Bitte wählen...')."</option>";

					foreach ($settings[3] AS $f) {
						echo "<option".((isset($_POST[field2url($name)]) && $_POST[field2url($name)] == $f) ? ' selected' : '').">".$f."</option>";
					}
					
					// Ende des Select-Feldes //
					echo '</select></td></tr>';
				break;
				
				case 'radio':
					// Radio-Buttons //
					echo "<tr><td class=\"contactSubjectTd\">".$name.":".(($settings[1]) ? ' (*)' : '')."</td><td class=\"contactInputTd\">";
					
					// Optionen auslesen //
					$i2 = 0;
	
					foreach ($settings[3] AS $f) {
						echo "<input type=\"radio\" name=\"".field2url($name)."\" value=\"".$f."\" id=\"radio".$i."_".$i2."\"".((isset($_POST[field2url($name)]) && $_POST[field2url($name)] == $f) ? ' checked' : '').(($settings[1]) ? ' required' : '')."><label for=\"radio".$i."_".$i2."\">".$f."</label>";
						
						$i2++;
					}					
				
					// Ende der radio-Buttons //					
					echo "</td></tr>";
				break;

				case 'file':
					// Dateiupload //
					echo "<tr><td class=\"contactSubjectTd\">".$name.":".(($settings[1]) ? ' (*)' : '')."</td><td class=\"contactInputTd\">".$settings[2]." ".((isset($settings[3]['max_size'])) ? "<input type=\"hidden\" name=\"MAX_FILE_SIZE\" value=\"".$settings[3]['max_size']."\">" : '')."<input type=\"".$settings[0]."\" name=\"".field2url($name)."\"".((isset($settings[3]['accept'])) ? " accept=\"".$settings[3]['accept']."\"" : '').(($settings[1]) ? ' required' : '')." /></td></tr>";
				break;
				
				case 'text':
				case 'email':
				case 'tel':
				case 'url':
				case 'date':
				case 'password':
				case 'datetime-local':
					// Text-Feld, ggf. spezieller Typ wie email/tel/url //
					echo "<tr><td class=\"contactSubjectTd\">".$name.":".(($settings[1]) ? ' (*)' : '')."</td><td class=\"contactInputTd\"><input type=\"".$settings[0]."\" class=\"contactField\" name=\"".field2url($name)."\" placeholder=\"".$settings[2]."\" value=\"".((isset($_POST[field2url($name)])) ? htmlspecialchars($_POST[field2url($name)]) : '')."\"".(($settings[1]) ? ' required' : '')." /></td></tr>";
				break;
				
				case 'textarea':
					// Mehrzeiliges Textfeld //
					echo "<tr><td class=\"contactSubjectTd\">".$name.":".(($settings[1]) ? ' (*)' : '')."</td><td class=\"contactInputTd\"><textarea class=\"contactTextarea\" name=\"".field2url($name)."\" placeholder=\"".$settings[2]."\"".(($settings[1]) ? ' required' : '').">".((isset($_POST[field2url($name)])) ? htmlspecialchars($_POST[field2url($name)]) : '')."</textarea></td></tr>";
				break;
				
				case 'checkbox':
				case '_copy':
				case '_consent':
					// Checkbox (ggf. auch für E-Mail-Kopie und Einwilligung) //
					if (isset($settings[3]) && is_array($settings[3])) {
						// Checkbox mit mehreren Optionen //
						echo "<tr><td class=\"contactSubjectTd\">".$name.":</td><td class=\"contactInputTd\">";

						foreach ($settings[3] AS $i => $f) {
							echo "<label><input type=\"checkbox\" name=\"".field2url($name)."[]\" value=\"".$i."\"".((isset($_POST[field2url($name)]) && in_array($i, $_POST[field2url($name)]) != false) ? ' checked' : '')." /> ".$f."</label> ";
						}

						echo "</td></tr>";
					} else {
						echo "<tr><td class=\"contactSubjectTd\">".$name.":".(($settings[1]) ? ' (*)' : '')."</td><td class=\"contactInputTd\"><label><input type=\"checkbox\" name=\"".field2url($name)."\" value=\"gesetzt\"".((isset($_POST[field2url($name)])) ? ' checked' : '').(($settings[1]) ? ' required' : '')." /> ".((isset($settings[3])) ? $settings[3] : '')."</td></label></tr>";
					}
				break;
			}

			$i++;
		}
		
		// Formular-Ausgabe abschließen und Captcha einbinden //
		echo 			"<tr><td class=\"contactSubjectTd\">Spam-Schutz: (*)</td><td class=\"contactInputTd\"><img src=\"".$captchaPath."?RELOAD=\" alt=\"Captcha\" title=\"Klicken, um das Captcha neu zu laden\" onclick=\"this.src+=1;document.getElementById('captcha_code').value='';\" width=\"140\" height=\"40\"><br><input type=\"text\" name=\"captcha_code\" id=\"captcha_code\" size=\"9\" maxlength=\"5\" required></td></tr>" .
					'</table>' .
					'<input type="email" name="email" style="display:none;" />' .
					'<input type="hidden" name="send" value="1" />' .
					'<input class="btn btn-primary" type="submit" value="Formular abschicken" />'.
				'</form>';
	}
	
?>

<!-- Hier kann der Inhalt deiner Seite hinter das OpenSim Registrierung platziert werden -->

