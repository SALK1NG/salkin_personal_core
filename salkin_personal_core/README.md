# FiveM Script - Various Functionalities

This is a custom FiveM script that introduces several features to enhance your roleplaying experience. The functionalities include the ability to display 3D text, carry other players, trigger ragdoll animations, and roll dice with animations and results. It’s designed to be used on a FiveM server for custom roleplay scenarios. 

## Features

- **3D Text Display:** Displays 3D text above a player's head when within range and line of sight.
- **Carrying Players:** Allows players to carry others in different animations.
- **Ragdoll Animations:** Lets players toggle ragdoll state (falling down animations) either manually or automatically when being stunned.
- **Dice Rolling:** Players can roll dice with a custom animation and a result displayed in 3D space.
- **Damage Rag Dolling:** Automatically disarms a player if they are hit in specific body parts (damaged bones).
  
## Requirements

- ESX Framework
- FiveM Server

## Installation

1. Download the script files.
2. Place them in your resources folder.
3. Add the resource to your `server.cfg`:
   ```
   ensure salkin_personal_core
   ```
4. Make sure to adjust the `Config` values in the script to match your server's needs (for example, language, animation settings).

## Configuration

You can modify the configuration values located in the `Config` object within the script. For example:
- **language:** Choose the language for chat commands.
- **color:** Customize the color for the 3D text display.
- **scale:** Control the size of the 3D text.
- **time:** The duration for which the text will remain visible.
  
## Commands

- **/carry**: Pick up the nearest player (within range).
- **/rag**: Toggle the ragdoll state for your character.
- **/dice**: Roll the dice and trigger a custom animation.
  
### Events

- **3dme:shareDisplay**: Shares 3D text display with another player.
- **CarryPeople:sync**: Syncs the carry animation across clients.
- **CarryPeople:stop**: Stops the carry animation.
- **CarryPeople:syncTarget**: Syncs the animation for the carried player.
- **dh_ragdoll:toggle**: Toggles the ragdoll state for the player.
- **esx_dice:roll**: Triggers a dice roll and sends the result to other players.
  
## Customization

### Carry Animation
- Modify the `lib`, `anim1`, `anim2`, and other carry-related variables to change the animation for carrying players. You can add your own animation dictionaries as well.

### Ragdoll
- Modify the **Ragdoll** feature settings like `Config.stunShouldRagdoll` to control whether a player should ragdoll when stunned.

### Dice Roll
- The dice roll animation uses the `anim@mp_player_intcelebrationmale@wank` animation. You can customize it by changing the animation dictionary and the task played.

## Known Issues

- **Carry Animation Delays:** Depending on server performance or animation loading, there may be minor delays before the animation starts.
- **Ragdoll State Persistence:** The ragdoll state may sometimes stay active until toggled off manually.


## License

This script is free to use under the MIT License. You are welcome to modify it for your own use, but please do not redistribute it as your own work.