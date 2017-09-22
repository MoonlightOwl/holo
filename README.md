# holo
Hologram editor written for mod OpenComputers (MineCraft).

This distribution includes two files / components.

### `holo.lua`
The editor itself. For correct work you will need:
* Screen - Tier 3
* GPU/APU - Tier 2+
* RAM - Tier 2+, x2
* Internet card (optional, required for installation from repository)
* Hologram projector (optional, required to preview models)

### `holo-view.lua`
The models viewer. You do not need the full editor installation to deploy your model to projector.
Only the viewer.

Command syntax:

```sh
holo-view filename[.3d/.3dx] [scale]
```

## Hologram formats
The basic hologram format is `*.3d` file.

It is easier to parse, and uses around *19KiB* per model.

Since `0.7.0` version, the editor supports a new file format: `*.3dx`. 
It features *x15* compression rate (thanks Zer0Galaxy for helping with this).

Both editor and viewer of new versions supports the old `*.3d` format for backward compatibility.

## Changelog

### 0.7.1
* Refactored textboxes
* Localization table for viewer
* Bugfixes

### 0.7.0
* Tier 2 GPU support
* New `*.3dx` file format with insane compression rate (thanks Zer0Galaxy :))
* Improved UI interaction
* Localization table
* Fixed old bugs, added a bunch of new ones

### 0.6.0
* Two new projection screens (side, front)
* "Ghost" layer, to facilitate modelling process
* Additional hotkeys

### 0.5.5
First viable version of editor.
