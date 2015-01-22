#Add View Stack for easy navigating between menus.
pop off to previous location, etc.
^^ Wont work as currently orchestrated
Instead of a view stack made up of method calls, we need to separate the presentation layer from the ui_loop. A single ui_loop which displays only a single instance of a view. That view will have a method that returns what to display on each loop iteration and a set of actions that it responds to in addition to the standard actions.

- standarize global navigation
- create standard per-view menus



# 'prefill' answers with default values, for easier entry. 
highlight default option on screen.
provide feedback for which item was chosen
__DONE__
