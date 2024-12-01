# GMTK 2024 Game Jam

## Styling guide
- Public vars - ```camelCase```
- "Private" vars - ```_camelCase```
- Duplicate vars ```camelCase_```
- Function names, file names - ```snake_case```
- Node names, folder names, enum names, class names - ```PascalCase```
- Static vars, enum values - ```MACRO_CASE```
- Divide logical blocks (function definition, variables definition, etc.) with one empty line
- Define loaded resources as const, e.g. ```const PLAYER = preload("res://player.tscn")```
- Use ```i``` as counter iterator in one dimensional for loops 
- Use ```x```, ```y``` or ```r```, ```c``` (short for row, column) as counter iterators in two dimensional for loops
- Place comments on same indent level as rest of the code
- Use ```#!``` for important comments, ```#?``` for questions, ```#TODO:``` for todo
- Try making your code understandable at glance. If impossible/unefficient - comment (i.e. don't pollute your code with unneccesary comments)


## Useful tips
- Avoid random values - store them in a variable
- Avoid repeating code - make it into a function
- Avoid handling massive data in code - pull it from resource, csv or json
- Avoid using theme overrides for massive theme changes - create new theme instead
- Avoid creating signal chains - use event singleton
- Use translation codes instead of real text, then add text to translation
- Make your scenes easy to test
- Before making anything from scratch google it first and check if it was already written