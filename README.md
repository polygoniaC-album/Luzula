# Luzula

Luzula est un framwork pour Godot Engine permettant de faire des labyrinthes mémoriels. Il a été conçu pour le jeu [La maison de Tante Luzerne](https://obeqaen.itch.io/tante-luzerne).  
Il a été conçu pour pouvoir être utilisé sans aucune connaissance en code. Des bases dans l'utilisation de Godot sont cependant nécessaires.

## Scène

Les scènes peuvent être construites à partir de n'imoprte quel type de node. Elles doivent utiliser le script /Luzula/scene.gd. Par défaut, l'extension **.tscn** doit être utilisée.

Pour chaque scène, trois fichiers doivent être ajoutés :

 - /scene/$nom$.tscn : Le fichier scène proprement dit
 - /scene/icon/$nom$_normal.png - 160x160px
 - /scene/icon/$nom$_hover.png - 160x160px

où $nom$ est le nom du fichier scène.

Deux scènes au moins sont nécessaires :

 - La scène de début.
 - La scène de fin, qui ne doit pas être accessible par les madeleines, et qui sera rendue accessible quand toutes les autres auront-été visitées.

Le nom de ces deux scènes peut-être configuré dans les **Paramètres du projet**.


## Madeleines

Le node permettant de passer d'une scène à l'autre s'appelle une **madeleine**. Il se trouve dans le dossier Luzula.

C'est un node de type Area2D, il doit donc contenir un node de type CollisionShape2D ou CollisionPolygon2D.

**Variables :**

 - text : texte de transition
 - scene : nom de la scene à charger, sans l'extension.

L'effet de particule peut-être configurer dans le nœud **particle** du princeps
