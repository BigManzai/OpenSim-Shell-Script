# BulletSim 3.26 extra für Ubuntu 22.04 gebaut.
Die Datei (umbenannt damit man die Konfiguration nicht ändern muss):

    libBulletSim-3.26-20231207-x86_64.so

ist die eigentliche Datei:

    libBulletSim-3.26-20231209-x86_64.so

Das einfachste ist die Datei /opt/opensim/bin/lib64/libBulletSim-3.26-20231207-x86_64.so auszutauschen.

Möchte man aber die Versionsnamen behalten muss die Datei /opt/opensim/bin/OpenSim.Region.PhysicsModule.BulletS.dll.config zusätzlich angepasst werden.

## Fazit
Die Original libBulletSim ist auf Ubuntu 20 gebaut worden und ich habe den Eindruck das diese auf einem Ubuntu 22 Server langsamer läuft.
