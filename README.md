# Park Valley backend

Dit is de backend van de app Park Valley.  
Zie GitHub link: https://github.com/RobbeRamon/park-valley

## Algemene uitleg
Deze backend (REST API) is geschreven in Vapor.  
Er is persistentie aanwezig aan de hand van sqlite.
Enkel en alleen user accounts worden gepersisteerd, om te tonen dat ik capabel om te werken met een persistentielaag in vapor.
Echter wegens tijdgebrek heb ik niet voor alles persistentie kunnen voorzien.
Aangezien dit project voornamelijk gefocust is op de app en niet op de backend viel de noodzaak ook weg.
De architectuur is op een zodanige manier opgesteld dat het persisteteren van alle objecten geen wijzigingen vraagt van de structuur in de backend.

## Aan de slag
Install de brew package Vapor indien dit nog niet gebeurt is.
```
brew install vapor
```
Hierna heb je de mogelijkheid om de Vapor server te starten door "build & run" in xcode.
