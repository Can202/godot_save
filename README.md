# Godot Save
Godot Save is created for new users, who need to save data, but it is easy

This script contains parts of Screenshot queue but modified by me, 
but the original author is fractilegames.

GitHub: https://github.com/fractilegames/godot-screenshot-queue

and inspired by the project "PersistenceNode" by MatiasVME

GitHub: https://github.com/MatiasVME/Persistence

<h1>Usage</h1>
<h2>Saving</h2>
<h3>save_data(data: Dictionary, profile: String = "save", typefile: String = ".json")</h3>

```gdscript
var data = {"yourmom":"fat"}
Addonsave.save_data(data,"yourmoms",".json")
```
<h2>Loading / Editing</h2>
<h3>edit_data(profile: String = "save", typefile: String = ".json")</h3>

```gdscript
var player_data = Addonsave.edit_data("player_data",".json")
```
<h2>Removing</h2>
<h3>remove_data(profile: String = "save", typefile: String = ".json")</h3>

```gdscript
Addonsave.remove_data("player_data",".json")
```
