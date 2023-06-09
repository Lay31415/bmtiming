# bmtiming
beatmania timing viewer for MAME

## Features

### Timing Viewer

Displays the timing of the notes for each lane when playing beatmania in MAME.  
However, the value of invisible notes may be mixed up in the memory.

To use, set "View timing" to true from the menu.

### Auto Play

Key presses and scratch operations can be made to occur automatically at any desired timing.

To use, set "Auto SCR" or "Auto key" to true from the menu.  
Input timing can be set in "Auto timing".  
The amount of scratch variation can be adjusted by "Rotate angle". (This is an analog value for MAME, not DJ MAIN)  
"On frames" specifies the number of sustained frames of input. if 0, scratching often fails.

## Known Issues

* Sometimes an input occurs in the middle of nothing during autoplay. It seems that there are residual invisible notes in memory, and there is no way to deal with them.

## How to Install

1. Deploy the bmtiming folder in the MAME plugin folder.
2. Activate the bmtiming plugin in the MAME configuration.
3. Activate the required features from the plugin settings menu while the game is running.
