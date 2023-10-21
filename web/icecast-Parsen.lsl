key http_request_id;  // Variable zur Speicherung der HTTP-Anfragen-ID

default
{
    state_entry()
    {
        // Diese Funktion wird beim Start des Skripts aufgerufen.
        llOwnerSay("Starte HTTP-Anfrage...");
        // Senden einer HTTP-GET-Anfrage an die gewünschte URL
        http_request_id = llHTTPRequest("https://openmanniland.de/icecasttxt.php", [HTTP_METHOD, "GET"], "");
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        // Diese Funktion wird aufgerufen, wenn eine HTTP-Antwort empfangen wird.

        if (request_id == http_request_id)
        {
            if (status == 200)
            {
                // 200 bedeutet Erfolg, die Anfrage war erfolgreich
                llOwnerSay("HTTP-Anfrage erfolgreich!");
                llOwnerSay("----------------------------------------");
                //llOwnerSay("Antwortinhalt: " + body); // Testausgabe des Roh Webseitentext im Chat.
                // Hier können Sie den Webseitentext in 'body' verarbeiten.
                
                // Webseitentext Parsen.
                list infoList = [];  // Eine Liste zur Speicherung der extrahierten Informationen

                // Teilen Sie den Text anhand der "<b>"-Tags auf
                list splitText = llParseString2List(body, ["<b>"], []);
                
                integer count = llGetListLength(splitText);
                
                for (integer i = 1; i < count; i++)
                {
                    // Extrahieren Sie den Text zwischen "<b>" und "</b>" und entfernen Sie "</b>"
                    string info = llStringTrim(llGetSubString(llList2String(splitText, i), 0, -5), STRING_TRIM);
                    info = llReplaceSubString(info, "</b>", " ", 2);
                    info = llReplaceSubString(info, "<br>", " ", 2);
                    info = llReplaceSubString(info, "</body>", " ", 2);
                    info = llReplaceSubString(info, "</h", " ", 2);
                    infoList += info;
                }
                
                // Geben Sie die extrahierten Informationen aus
                integer infoCount = llGetListLength(infoList);
                for (integer j = 0; j < infoCount; j += 2)
                {
                    string label = llList2String(infoList, j);
                    string value = llList2String(infoList, j + 1);
                    //llOwnerSay("Bezeichnung: " + label);
                    //llOwnerSay("Wert: " + value);
                    llOwnerSay(label);
                    llOwnerSay(value);
                }
            }
            else
            {
                llOwnerSay("Fehler bei der HTTP-Anfrage. Statuscode: " + (string)status);
            }
        }
    }
}
