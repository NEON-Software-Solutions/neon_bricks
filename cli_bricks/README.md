# NEON CLI Bricks 🧱

Developed mit 💙 von NEON Software Solutions

---

Alle Bricks für das Command Line Interface für Dart, das nur ein Gas kennt.

## Wie man eine neue Option zur NEON Core App hinzufügt

Du möchtest ein zusätzliches Feature für die *NEON Core App* entwickeln, das heißt, dein Ausgangspunkt ist das [Template Project][template_project_link]? Dann bist du hier genau richtig.

Im Wesentlichen läuft das Ganze auf Mason-Bricks und deren Generierung hinaus. Keine Ahnung wovon ich spreche? Dann empfehle ich dir [Mason für Dummies][mason_link].

### Feature entwickeln

Es handelt sich also um ein zusätzliches Feature für die *NEON Core App*, das heißt, dein Ausgangspunkt ist das [Template Project][template_project_link]. Lasse dir entweder von der CLI ein neues Projekt generieren, wobei du NICHTS auswählst, oder du checkoutest im [Template Project][template_project_link] einen eigenen Branch vom ```basic``` Branch aus. Auf diesem neuen Branch kann das Feature dann wunderbar getestet werden.

### Feature testen (?!)

Klar schlägt kein Test deine zwei Buttontaps, die genau das machen, was sie sollen, aber automagische Tests lassen uns einfach nochmal ein µ professioneller aussehen. Dann schaut das ganze auch schön aus 🌈

### Brick für dein Feature erstellen

#### Feature Brick

Jetzt wird es eklig und du musst dein Feature in ein Brick übersetzen! Wenn du nicht weißt, wie das geht, sprich mit mir (Julien), schau dir die bereits bestehenden Bricks in dem Repo an oder lies dir [das][mason_link] durch.

Am einfachsten ist es, wenn du beim Erstellen deines Bricks nur Brick-Variablen nutzt, die ein Verweis auf bereits bestehende Bricks sind. Ein Beispiel: das Authentication mit eigenem Backend Feature benötigt die Info, ob der Toast Service verwendet wird. Die dazugehörige Variable findest du unter ```bricks/authentication_feature/brick.yaml```, wo sie als ```toast_service``` deklariert ist. Wenn du dir jetzt ```bricks/template/brick.yaml``` ansiehst, wirst du feststellen, dass die Variable, die codiert, ob das neue Projekt den ```ToastService``` nutzt, auch ```toast_service``` heißt! Zufall? Ich glaube nicht.

Natürlich kannst du auch neue Variablen deklarieren (s. dazu das User Feature Brick, das die Variablen ```authentication_own_backend_feature``` und ```authentication_firebase_auth_feature``` deklariert, weil es gewisse Widgets abhängig vom Auth Typ (eigenes Backend oder Firebase) generiert). Solltest du eigene Variablen deklarieren, musst du diese in der Funktion ```getAdditionalBrickVariables```, die du bei den ganzen Gettern in den den ```CreationOptions``` findest, auflisten. (mehr Infos dazu [unten](#neue-creation-option-in-die-cli-einfügen)).

#### Tests im Feature Brick

Wenn du Tests implementiert hast (dicker 😘 an der Stelle), achte dabei bitte darauf, die Ordner-Struktur des *fertig generierten* Bricks zu kopieren! Beispiel: dein Brick wird folgendes File generieren: ```meine_app/lib/features/mein_feature/mein_feature.dart```. Und du hast den Inhalt von ```mein_feature.dart``` im File ```mein_feature_test.dart``` getestet. Dann muss der Test *nach Generierung* auch im Ordner ```meine_app/test/features/mein_feature/mein_feature_test.dart``` liegen.

Deshalb solltest du *ALLE* Tests deines Features innerhalb deines Bricks in einen Ordner ```test``` packen (den Ordner kannst du auch anders nennen, mehr dazu [unten](#neue-creation-option-in-die-cli-einfügen)) und innerhalb dieses Ordners die Brickstruktur nachbauen.

### Template Brick updaten (?!)

Hat dein neues Feature Änderungen im ```template```-Brick verursacht (z.B. in ```lib/main.dart```, was ein File ist, dass das ```template```-Brick generiert)? Dann musst du jetzt ein paar Setup-Schritte durchführen. Wenn nicht, dann überspringe diesen Absatz.

Du hast gerade der *NEON Core App* ein Feature hinzugefügt, das das Template erweitert. Diese Erweiterung muss natürlich auch im ```template```-Brick gespiegelt werden. Füge dem ```template```-Brick als erstes eine Variable hinzu, die dein neues Feature kodiert. Beispiel: dein neues Brick heißt ```new_feature```. Füge der ```template/brick.yaml``` die Variable ```new_feature``` unter dem Bereich ```vars``` hinzu (mit ```type: boolean```, da es sich um ein Ein/Aus Toggle handelt und im Idealfall noch einer kleinen Beschreibung).

Hat die Entwicklung deines neuen Features Files außerhalb des Feature-Ordners verändert (z.B. einen neuen BlocProvider in ```main_app_loader.dart```)? Dann musst du weitere Änderungen am ```template```-Brick vornehmen. Sieh dir dazu sowohl ```hooks/pre_gen.dart```, als auch ```hooks/post_gen.dart``` des ```template```-Bricks an, die die Imports von ```app.dart``` und ```main_app_loader.dart``` verwalten, bzw. ein File-Cleanup Post-Gen durchführen. Und sollte das nicht reichen, dann ändere selbstverständlich auch andere Files im Brick. Der Bums muss natürlich laufen 🏃🏾!

Ich sag es nochmal, weil ich hier gerade um 3:34 Uhr morgens einen 💩-Bug fixe... Schau dir die Pre- und Post-Gen-Hooks vom template Brick an!!! Schreibt dein Brick irgendwas in ```injectable_module.dart```? Dann stelle sicher, dass es in der Bedingung für die Löschung davon im ```post_gen.dart``` mit drin steht! Analog dazu, falls es etwas in ```app_settings.dart``` schreibt!

### Pubspec Brick updaten (?!)

Höchstwahrscheinlich hat dein neues Feature neue Dependencies in das Projekt gebracht. Wenn nicht, dann überspringe diesen Absatz.

Als ersten Schritt müssen wir das gleich machen, wie beim ```template```-Brick: dein Brick hieß ```new_feature``` und wir haben im ```template```-Brick eine Variable hinzugefügt, die exakt so heißt. Das musst du für das Pubspec Brick auch machen!!! (Wenn du einen Blick in die ```brick.yaml``` des ```pubspec```-Brick wirfst, wird dir die große Ähnlichkeit zu dem ```brick.yaml``` des ```template```-Bricks auffallen).
🚨🚨🚨
GANZ GANZ WICHTIG: Der Variablenname deines neuen Bricks MUSS im ```template```- und ```pubspec```-Brick IDENTISCH SEIN!🚨🚨🚨

Weiter im Text.

Es können jetzt genau zwei Fälle eintreten:

1. Es gibt schon andere Features in der *NEON Core App*, die diese Dependency auch nutzen
2. Diese Dependency wird zum ersten Mal in der *NEON Core App* genutzt.

Fall 1:

Nehmen wir an, dein neues Feature benötigt das package ```hydrated_bloc```. Dieses Package wird bereits von anderen Features genutzt und im ```pubspec```-Brick durch die Variable ```needs_hydrated_bloc``` kodiert. Schaue dir dazu im ```pubspec```-Brick das File ```hooks/pre_gen.dart``` an, insbesondere die Funktion ```_getPubspecPackages```. Diese Funktion ermittelt anhand der übergebenen Brick-Variablen die Packages, die in die generierte ```pubspec.yaml``` geschrieben werden müssen. Da dein Feature ein bereits verwendetes Package nutzt (```hydrated_bloc```), reicht es, die Zeile, die das Feld ```needs_hydrated_bloc``` um die Bedingung ```|| vars['new_feature']``` zu erweitern (wir erinnern uns: diese Variable beschreibt dein neues Brick und ist sowohl im ```template```-, als auch ```pubspec```-Brick deklariert).

Fall 2:

Du hast eine komplett neue Dependency in die *NEON Core App* gebracht. Füge sie als erstes in die ```pubspec.yaml``` des ```pubspec```-Bricks ein. Wrappe sie anschließend mit einer Variable (z.B. die neue Dependency ist ```go_router```? Dann wrappe die Dependency zu ```go_router``` in der ```pubspec.yaml``` mit der Mustache-Syntax ```{{#needs_go_router}}{{/needs_go_router}}```). Diese Variable muss jetzt in der ```pre_gen.dart``` des ```pubspec```-Bricks deklariert werden. Sieh dir dazu die Funktion ```_getPubspecPackages``` an und erweitere die Map, die zurückgegeben wird, um folgende Zeile:

```dart
'needs_go_router': vars['new_feature'], // Du erinnerst dich: 'new_feature' war der Name der Variable, die wir sowohl dem template, als auch pubspec Brick neu hinzugefügt hatten und die dein neues Feature kodiert!
```

Wenn du ganz fancy sein willst (NEON Best Practice) und die neue Dependency sich nicht in die bereits bestehenden Abschnitte der ```pubspec.yaml``` einfügen lasst, dann füge auch noch einen neuen Abschnittstitel via ```_getPubspecSectionTitles``` hinzu (erweitere wieder die Rückgabe-Map um ein Feld, für unser Beispiel ```go_router``` würde sich ```needs_navigation_title``` anbieten) und packe den expliziten Titel (für unser Beispiel würde sich "Navigation" anbieten) in die generierte ```pubspec.yaml```, wieder mit dem Wrapper ```{{#needs_go_router}}{{/needs_go_router}}```.

### Neue Creation Option in die CLI einfügen

Jetzt hast du alle Änderungen, die dein neues Feature am existenten Core auslöst, vermerkt und es ist an der Zeit, dein neues Brick in die CLI einzufügen!

In der [CLI][cli_link] wird das enum ```CreationOptions``` definiert, das (wie der Name verrät) alle Optionen beschreibt, die wir beim Aufsetzen eines neuen Projekts anhand der *NEON Core App* haben. Füge einen neuen Wert für ```CreationOptions``` in ```lib/src/commands/abfahrt/creation_options.dart``` ein, der dein Feature adäquat beschreibt und implementiere im Anschluss alle Getter (der Compiler wird dir überall Faxen anzeigen, weil die Getter per ```switch```-Statement auf dem Enum gebaut sind).

Die Getter sollten so selbsterklärend wie möglich sein, ich habe mir trotzdem mal die Mühe gemacht, dir hier eine kleine erklärende Übersicht zu erstellen (gern geschehen 😘):

- ```description```: Dieser String wird im Terminal angezeigt werden, wenn dich die CLI nach den Optionen fragt, die du einbauen möchtest
- ```defaultValue```: Soll dein Feature by default ausgewählt sein? (Höchstwahrscheinlich nicht, daher den Wert in den meisten Fällen auf ```false``` setzen)
- ```mason_var_name```: Dieser String ist SEHR wichtig, falls dein neues Feature eine Änderung im ```template```- und/oder ```pubspec```-Brick verursacht hat. Unser Beispiel von vorhin (```new_feature```) hat das getan, also muss der Rückgabewert von ```mason_var_name``` *EXAKT* der Name der Variable sein, die wir im ```template```- und/oder ```pubspec```-Brick vorhin definiert hatten! Sollte dein Brick weder ```template```-, noch ```pubspec```-Brick verändern (wie z.B. das ```mason_integration_feature```-Brick), dann gib hier den leeren String ```''``` zurück.
- ```brickVariablesRelatedToOtherBricks```: Das ist eine Liste an *bereits existierenden Variablen*, von denen dein neues Feature abhängt. Beispiel: dein neues Brick muss wissen, wie das Projekt heißt und ob der ```ToastService``` genutzt wird? Dann hast du im ```brick.yaml``` deines Bricks diese Variablen hoffentlich so genannt, wie sie auch im ```mason_var_name``` des jeweiligen Bricks definiert sind (in diesem Fall also ```project_name``` und ```toast_service```) und gibst in dieser Methode folgende Liste zurück:

```dart
case CreationOptions.myNewFeature:
 return [
          projectNameVar,
          CreationOptions.toastService.masonVarName,
        ];
```

🚨🚨🚨 Ich kann nicht genug betonen, wie wichtig es ist, dass Variablennamen, die bereits existieren (d.h. Abhängigkeiten deines neuen Features von bereits implementierten Features) EXAKT GLEICH SEIN MÜSSEN 🚨🚨🚨

Sollte dein neues Feature nur eigene Variablen haben oder gar keine, dann gib die leere Liste zurück

- ```getAdditionalBrickVariables```: Hier gibst du die Name der gerade erwähnten eigenen Variablen zurück. Dein neues Feature-Brick hat keine eigenen Variablen? Dann gibt die leere Map ```{}``` zurück. Dein neues Feature-Brick hat die Variable ```hasSwag``` deklariert? Dann muss diese Funktion so erweitert werden:

```dart
case CreationOptions.myNewFeature:
 return {
    'hasSwag': _berechneDenWertDieserVariable(),
 };
```

- ```getBrickGenerationDirectoryPath```: Der Pfad zu dem Verzeichnis, in dem dein Brick generiert werden soll. Dein Brick ist ein Feature? Dann würde ```projectDirectoryPath/lib/features``` Sinn machen. Du hast einen neuen Core-Service (wie z.B. ```ToastService```) implementiert? Dann gib ```projectDirectoryPath/core/services``` zurück. Wenn dein Brick gar keine neuen Files generiert (sondern z.B. nur Files aus dem ```template```-Brick ändert), dann gib hier den leeren String zurück.
- ```brickPath```: Der Pfad, unter dem dein neues Brick in dem Repo hier gespeichert ist (ausgehend vom Ordner ```NEON_bricks/cli_bricks/bricks```). Für das ```template```-Brick wäre der Rückgabewert von ```brickPath``` einfach ```template```. Sollte dein neues Brick keine neuen Files generieren, gib auch hier wieder den leeren String zurück.

- ```creationOptionDependencies```: Die Liste der *HARTEN* Abhängigkeiten deines Bricks. Dein Brick funktioniert *NUR UND WIRKLICH NUR*, falls der ```ToastService``` in der App vorhanden ist? Dann gib hier ```[CreationOptions.toastService]``` zurück. Das führt dazu, dass ein Dev, sobald er im Terminal dein Feature auswählt, aber nicht den ```ToastService```, über die Abhängigkeit benachrichtigt und sie automatisch zu den "Generierungs-TODOs" hinzugefügt wird. Keine Abhängigkeiten? Dann leere Liste zurückgeben.
- ```getTestsDirectory```: Der Pfad, unter dem die Tests deines Bricks abgelegt sind. Keine Tests? Dann ```null``` zurückgeben. Du kannst zum Vergleich mal einen Blick in das ```authentication_feature```-Brick werfen. (Funfact: GitHub Copilot hat mir beim Schreiben dieses Readmes einfach gerade vorgeschlagen "Das ist sehr schlecht, Tests sind wichtig". Chill mal.).
- ```generationErrorMessage```: Die Fehlermeldung, die ausgegeben werden soll, falls bei Generierung deines Bricks etwas schiefgeht. Dein Feature generiert keine eigenen Files (sondern ändert nur Files z.B. im ```template```-Brick)? Leeren String zurückgeben.
- ```getSetupReadmeGenerationPath```: Dein Feature benötigt extra Setup, das du selbstverständlich schon in der [Doku der CLI][cli_docs_repo_link] eingepflegt hast? Dann gib hier den Pfad zu dem passenden Readme zurück. Keine Setup-Files? Dann ```null``` zurück!

### Testen

Führe die CLI jetzt aus und wähle deine *NUR* deine neue Option aus. Funktioniert? Dann führe die CLI nochmal aus und füge ein paar andere, bereits bestehende Optionen hinzu. Funktioniert auch? Dann:

### Abfahren

🏎🏎🏎

[template_project_link]: https://github.com/NEON-Software-Solutions/NEON_template_project
[cli_link]: https://github.com/NEON-Software-Solutions/NEON_cli/tree/dev
[mason_link]: https://pub.dev/packages/mason_cli
[cli_docs_repo_link]: https://github.com/julien-neon/NEON_cli_docs
