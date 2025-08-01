# This is version 1.0.4a which is the same version that can be found here:
- https://github.com/TheErrantVenture/gtzombies_qbx/releases/tag/V.1.0.4a
- I suck at github, and the fork only shows an out-dated version of the gtzombies script.  This is posted so people can compare, review, quick reference the files in the release, without having to download or unzip.
- Future maybe(s) edit wise:
  - Remove big ass green boxes for immersion purposes.
# GT Zombies Qbox Version
- Converted on 8.1.25 by TheErrantVenture to QBox
- All credits for the original ESX / QBCore version goes to D3IM4N & @WeRBorg
- Original script can be found here: https://github.com/D3IM4N/ZOMBIES_PROJECT/releases/tag/v1.0.4
- WeRBorg: https://github.com/WeRBorg
- This includes the dependencies for gtzombies:
  - Xsound by Xogy: https://github.com/Xogy/xsound
  - PolyZone 2.6.2 by mkafrin: https://github.com/mkafrin/PolyZone/releases
- Please note, the folders have been renamed as I utilize a [plugin] resource folder.  The renames allow Xsound + PolyZones to correctly load before gtzombies (zeds_qbx).  If you don't use a similar resource folder to mass load, do the following in your server configuration:
   ```
   ensure PolyZone
   ensure sound
   ensure zeds_qbx
   ```
- Per D3IM4N's original readme / license: This script is made to be OPEN SOURCE. You can edit the code and share improvements for it. I hope yall enjoy :)

## Description
GT Zombies is a script for the QB/ESX framework that introduces zombie NPCs into the game. This script enhances the gameplay experience by adding a new layer of challenge and excitement.

## Features
- Spawn zombie NPCs at specific locations.
- Customizable zombie behavior and attributes.
- Zombie bosses.
- 3D Sound for zombies.
- Circle or Polyzones for Redzones and Safezones.
- And more!

## Installation
1. Download the script and place it in the resources folder
2. Add the script to your server configuration file:
   ```
   ensure gtzombies_esx or gtzombies_qb
   ```

## Usage
- Configure the script settings in the `config.lua` file to customize zombie behavior and attributes.
- Start your server and enjoy the new zombie NPCs in your game.

## Configuration
The `config.lua` file contains various settings that you can adjust to customize the script to your needs.

## Contributing
If you would like to contribute to the development of this script, please fork the repository and submit a pull request with your changes. Or join the discord.
