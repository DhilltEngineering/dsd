# dsd
source code of the Dhillt Software Distribution for ComputerCraft

## `dpak` (**D**hillt **Pa**c**k**age Manager)
`dpak` is essentially the backbone of DSD. it installs, upgrades, and uninstalls packages.

### default packages
#### programs
* `binarc`: file archiving tool (without compression)
* `dpak`: command-line interface to `dpak-lib`

#### libraries
* `binarc-lib`: file archiving library
* `dpak-lib`: the package manager itself. it gets called on boot to initialize the `/prg` and `/lib` folders.
* `moonscript-lib`: MoonScript compiler library
* `urn-lib`: Urn (Lua implementation of Lisp) compiler library

## structure of a DSD installation
DSD installations follow the same basic folder structure, with folders having special properties.

### `/prg`: `dpak` programs
programs installed using `dpak` reside in `/prg`. for one program `x`, there exists two items in `/prg`:
* `x.lua`: the executable program itself
* `x/`: a folder containing relevant files for the program, most notably help texts and autocompletion functions

`/prg` is added to `PATH` on boot, therefore installed programs are directly usable in the command line.

### `/lib`: `dpak` libraries
`/lib` contains libraries used system-wide or by specific programs, installed and maintained by dpak. libraries usually either exist as lua modules in a folder containing an `init.lua` (which is imported by the program), relevant files, and possibly some developer documentation.