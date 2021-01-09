# Minetest Liquid_Restriction Mod

restricts players from placing liquids via the node or bucket unless they have a the spill priv  

## About

born out of me not being able to find a good public spill mod. mod is ment for creative worlds. licensed under MIT.

## Links

* [Github](https://github.com/wsor4035/liquid_restriction)
* [Contentdb](https://content.minetest.net/packages/wsor4035/liquid_restriction/)
* [forums](not avaible yet)

## Setup

download mod, make sure its named liquid_restriction

## FAQ

__buckets don't work(place liquid) when used.__   
please update the mod, this has since been fixed as of commit `1e33fd0`

__how do I use this mod for random liquid__  
simple, add random liquids mod to the depends.txt file,
and the modname:node_name(source and flowing) to to the 
liquid_list. if it has a bucket form, add its 
bucket:node_name to liquid_list as well.
