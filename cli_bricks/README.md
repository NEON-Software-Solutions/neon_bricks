# NEON CLI Bricks 🧱

Developed mit 💙 von NEON Software Solutions

---

Alle Bricks für das Command Line Interface für Dart, das nur ein Gas kennt.

## Wie man eine neue Option zur CLI hinzufügt

### Feature entwickeln

Entwickle zuerst das neue Feature völlig funktional ausgehend vom ```basic``` Brick. Lass dir dazu entweder von der CLI ein neues Projekt generieren, in dem du NICHTS auswählst, oder du checkoutest im [Template Project][template_project_link] einen eigenen Branch vom ```basic``` Branch aus. Auf diesem neuen Branch kann das Feature dann wunderbar getestet werden.

### Feature testen (?!)

Klar schlägt kein Test deine zwei Buttontaps, die genau das machen, was sie sollen, aber automagische Tests lassen uns einfach nochmal ein µ professioneller aussehen.  Dann schaut das ganze auch schön aus 🌈

### Brick für dein Feature erstellen

#### Feature Brick

Jetzt wird es eklig und du musst dein Feature in ein Brick übersetzen! Wenn du nicht weißt, wie das geht, sprich mit mir (Julien), schau dir die bereits bestehenden Bricks in dem Repo an oder lies dir [das][mason_link] durch.

Am Einfachsten ist es, wenn du beim Erstellen deines Bricks nur Brick-Variablen nutzt, die ein Verweis auf bereits bestehende Bricks sind (z.B. benötigt das Authentication mit eigenem Backend Feature die Info, ob der Toast Service verwendet wird. Eine Variable, die auch das Template Brick benötigt.)

Natürlich kannst du auch neue Variablen deklarieren (s. dazu das User Feature Brick, das die Variable ```authentication_feature``` deklariert, weil es gewissen Widgets generiert, wenn irgendeine Auth vorhanden ist, sei es nun per eigenes Backend oder Firebase). Nutze hierfür die Funktion ```getAdditionalBrickVariables```, die du bei den ganzen Gettern in den den ```CreationOptions``` findest (mehr Infos dazu [unten](#neue-creation-option-in-die-cli-einfügen)).

#### Tests im Feature Brick

Wenn du Tests implementiert hast (dicker 😘 an der Stelle), achte dabei bitte darauf, die Ordner-Struktur des *fertig generierten* Bricks zu kopieren! Beispiel: dein Brick wird folgendes File generieren: ```meine_app/lib/features/mein_feature/mein_feature.dart```. Und du hast den Inhalt von ```mein_feature.dart``` im File ```mein_feature_test.dart``` getestet. Dann muss der Test *nach Generierung* auch im Ordner ```meine_app/test/features/mein_feature/mein_feature_test.dart``` liegen.

Deshalb solltest du *ALLE* Tests deines Features innerhalb deines Bricks in einen Ordner ```test``` packen (den Ordner kannst du auch anders nennen, mehr dazu [unten](#neue-creation-option-in-die-cli-einfügen)) und innerhalb dieses Ordners die Brickstruktur nachbauen.

### Pubspec Brick updaten (?!)

Höchstwahrscheinlich hat dein neues Feature neue Dependencies in das Projekt gebracht.

🚨 ACHTUNG: "neu" bedeutet hier ausgehend vom ```basic``` Branch des Template Projektes! Sollte dein Feature eine Dependency nutzen, die von Brick-Variablen gesteuert wird (z.B.```hydrated_bloc```), dann könnte dir auffallen, dass diese schon im ```pubspec``` Brick liegt. ABER: wenn du das ```pubspec``` Brick nicht updatest und mal ein armer Dev nur eine einzige Option in der CLI auswählt (nämlich deine gerade frisch erstellte), dann wird die Dependency nicht in der ```pubspec.yaml``` auftauchen!

Jetzt also die Frage: Hat dein neues Brick neue Dependencies in das Projekt gebracht (oder bereits bestehende, durch Brick-Variablen gesteuerte ebenfalls genutzt)?

Wenn nicht, dann überspringe diesen Absatz.

Wenn doch, dann musst du auch das ```pubspec``` brick updaten. Schaue dir dazu ```pre_gen.dart``` vom ```pubspec``` Brick an. Dort kannst du anhand der übergebenen Brick-Variablen ermitteln, welche Packages benötigt werden, diese dann in neue ```HookContext.vars``` schreiben und diese dann in der ```pubspec.yaml``` des Bricks verwenden.

### Template Brick updaten (?!)

Hat die Entwicklung deines neuen Features Files außerhalb des Feature-Ordners verändert (z.B. einen neuen BlocProvider in ```main_app_loader.dart```)? Dann musst du auch das ```template``` Brick dementsprechend updaten. Sieh dir dazu sowohl ```pre_gen.dart```, als auch ```post_gen.dart``` des ```template```-Bricks an, die die Imports von ```app.dart``` und ```main_app_loader.dart``` verwalten, bzw. ein File-Cleanup Post-Gen durchführen. Und sollte das nicht reichen, dann ändere selbstverständlich auch andere Files im Brick. Der Bums muss natürlich laufen 🏃🏾!

Ich sag es nochmal, weil ich hier gerade um 3:34 Uhr morgens einen 💩-Bug fixe... Schau dir die Pre- und Post-Gen-Hooks vom template Brick an!!! Schreibt dein Brick irgendwas in ```injectable_module.dart```? Dann stelle sicher, dass es in der Bedingung für die Löschung davon im ```post_gen.dart``` mit drin steht! Analog dazu, falls es etwas in ```app_settings.dart``` schreibt!

### Bundle(s) in die CLI einfügen

Jetzt ist dein neues Brick endlich fertig, Zeit es zu bundlen!

🚨 Natürlich auch ```pubspec``` oder ```template```, solltest du diese verändert haben.

Zum Bundlen kannst du ganz entspannt das ```./bundle_brick.sh``` Skript nutzen. Das Skript funktioniert nur, wenn du [mason](mason_link) installiert hast. Solte das noch nicht der Fall sein, dann führe folgenden Befehl aus:

```bash
dart pub global activate mason_cli
```

Übergib jetzt um das ```./bundle_brick.sh``` Skript auszuführen, als Argument den Namen deines Bricks. Beispiel: dein Brick heißt ```awesome_feature```, dann:

```bash
./bundle_brick.sh awesome_feature
```

Die/das neue(n) Bundle(s) erscheinen automagisch im Ordner ```lib/src/commands/abfahrt/options/mason_bundles/```. Anschließend ein neues Barrel File generieren (falls du neue Bundles erzeugt hast) nicht vergessen!

### Neue Creation Option in die CLI einfügen

In der [CLI][cli_link] einen neuen Wert vom Enum ```CreationOptions``` in ```lib/src/commands/abfahrt/creation_options.dart``` erstellen und alle fehlenden Getter ausfüllen.

Die [CLI][cli_link] unterstützt natürlich auch neue Bricks mit Tests 😎 (Funfact: GitHub Copilot hat mir beim Schreiben dieses Readmes einfach gerade vorgeschlagen "und das ist auch gut so". Chill mal.). Daher wird dir der Getter ```getTestsDirectory``` über den Weg laufen. Dieser definiert, wo du dein Brick-Tests-Verzeichnis abgelegt hast. Wenn dein Brick keine Tests definiert, gib einfach ```null``` zurück. Wenn deine Tests unter ```__brick__/authentication/tests``` liegen, dann gib dort ```<pfad_zum_brick>/authentication/tests``` zurück. Den ```<pfad_zum_brick>``` kannst du dir über den anderen Getter ```getBrickGenerationDirectoryPath```, den du davor definiert haben solltest (🧐), holen. Note: der ```__brick__``` Odner verschwindet natürlich nach der Generierung ([Mason für Dummies][mason_link]).

### Testen

Führe die CLI jetzt aus und wähle deine neue Option aus. Funktioniert? Dann:

### Abfahren

🏎🏎🏎

[template_project_link]: https://github.com/NEON-Software-Solutions/NEON_template_project
[cli_link]: https://github.com/NEON-Software-Solutions/NEON_cli/tree/dev
[mason_link]: https://pub.dev/packages/mason_cli
