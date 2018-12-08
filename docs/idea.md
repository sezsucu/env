## Plugins
* [BashSupport](https://plugins.jetbrains.com/plugin/4230-bashsupport)
* [Python Community Edition](https://plugins.jetbrains.com/plugin/7322-python-community-edition)
* [Scala](https://plugins.jetbrains.com/plugin/1347-scala)
* [Markdown Navigator](https://plugins.jetbrains.com/plugin/7896-markdown-navigator)
* [Key Promoter X](https://plugins.jetbrains.com/plugin/9792-key-promoter-x)

## Change the terminal path
**File | Settings | Tools | Terminal | Shell Path**. Use bash, instead of windows default
command line.

## Command shortcuts
* `ALT-1`: Project
* `ALT-9`: Version Control
* `ALT-F12`: Terminal`
* `ESC`: Editor

## Nice features
* Distraction Free Mode
* `Ctr*l-Shift-F12`: Hide/Unhide all windows except editor
* `ALT-Home`: Go to **Navigation Bar** 

## Speed search
Just start typing the name of the item you are looking for and it will highlight the found items.
If a folder is not expanded, it will not search there, so the item must be visible.

### How to expand all nodes in a tool window
Just keep pressing `right-arrow` until all nodes are expanded

## [Keymap](https://resources.jetbrains.com/storage/products/intellij-idea/docs/IntelliJIDEA_ReferenceCard.pdf)

### Editor Basics
* Move the current line `Ctrl-Shift-Up` or `Ctrl-Shift-Down`
* Duplicate a line of code `Ctrl-D`
* Remove a line of code `Ctrl-Y`
* Comment or uncomment a line of code `Ctrl-/`
* Comment a block of code `Ctrl-Shift-/`
* Find in current file `Ctrl-F`
* Replace in current file `Ctrl-R`
* Code completion `Ctrl-Space`
* Smart code completion `Ctrl-Shift-Space`

### Navigation
* Recent files `Ctrl-E`
* Navigate class `Ctrl-N`
* Navigate files `Ctrl-Shift-N`
* Navigate symbols `Ctrl-Shift-Alt-N`
* Navigate within the file (Structure) `Ctrl-F12`
* Navigate type hierarchy `Ctrl-H`
* Navigate to pop-up documentation `Ctrl-Q`
* Navigate to quick definition `Ctrl-Shift-I`
* Show usages `Ctrl-Alt-F7`
* Show implementation `Ctrl-Alt-B`

### Refactoring
* Rename `Shift-F6`
* Extract variable `Ctrl-Alt-V`
* Extract field `Ctrl-Alt-F`
* Extract a constant `Ctrl-Alt-C`
* Extract a method `Ctrl-Alt-M`
* Extract a parameter `Ctrl-Alt-P`
* Inline `Ctrl-Alt-N`
* Copy `F5`
* Move `F6`
* Refactor this `Ctrl-Shift-Alt-T`

### Finding usages
* All usages of a symbol at the carrot `Alt-F7`
* All usages of a symbol in plain text `Ctrl-Shift-F`

### Inspections
* To quickly fix it `Alt-Enter`
* To list the intentions `Alt-Enter`

### Code Style and Formatting
* Reformat code `Ctrl-Alt-L`
* Auto indent lines `Ctrl-Alt-I`
* Optimize imports `Ctrl-Alt-O`

### Version Control Basics
* VCS operations ``Alt-` ``
* Version control windows `Alt-9`
* Commit changes `Ctrl-K`
* Update project `Ctrl-T`
* Push commits `Ctrl-Shift-K`

### Make
* Building `Ctrl-F9`

### Running and Debugging
* Run `Shift-F10`
* Debug `Shift-F9`

### Debugging mode
* Toggle breakpoint `Ctrl-F8`
* Step into `F7`
* Smart stepping `Shift-F7`
* Step over `F8`
* Step out `Shift-F8`
* Resume `F9`
* Evaluate expression `Alt-F8`

### Others
* Run anything `Ctrl-Ctrl`
* Search everywhere `Shift-Shift`
* Find action `Ctrl-Alt-A`
* Find class `Ctrl-N`
* Find a file `Ctrl-Shift-N`
* Find a symbol `Ctrl-Shift-Alt-N`
* View recent files `Ctrl-E`
* Show intention actions `Alt-Enter`
* Basic code completition `Ctrl-Space`
* Add/remove line or block comment `Ctrl-/` or `Ctrl-Shift-/`

### Coding Assitance
* Type info `Ctrl-Q`

### Structural search templates
* **Settings | Editor | Inspections | Structural Search Inspection**
* **Edit | Find | Search/Replace Structurally...**

### Editor tabs
* Hold `Alt` while pressing the close button of a tab to close all other tabs
* Open a file in a new window `Shift-Enter`
* In the open file dialog box type `Ctrl-Space` to invoke path suggestions after typing few characters

### Other Commands
* Select 2 files and press `Ctrl-D`.
* Paste from history `Ctrl-Shift-V`
* Multiple selections `Alt-J` or `Shift-Alt-J`. You can replace the text easily.
* When entering a regex you can do `Alt-Enter` and check the regex against a string
* Find and replace feature supports captured groups in replacement expressions
* Select a class file and **View | Show Bytecode**
* While pressing `Shift` click on the gutter to evaluate an expressiong without stopping at the breakpoint
* Field watchpoints can be created by holding `Alt` and clicking on the gutter

### Custom Data Renderers
Using Debug tool window, you can add custom renderers for any class. During
the debug, from the Debug tool context menu choose "Customize data views".

#### Drop frame
In case you want to go back in time, you can do it via the Drop Frame action.
This will not revert the global state of the application though.

#### Force return
If you want to jump to the future, force return from the current method without
executing any more instructions from it, use Force Return.

#### Hot swap
You can't add new methods or new fields, but you can change method bodies. However,
using Dynamic Code Evaluation, you can do that.

### Productivity Guide
**Help | Productivity Guide**










