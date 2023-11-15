# Egg Calculator
A Lua script to help with *Egg, Inc.* contracts by the HomeDataRoom team. **Currently in active development. Expect bugs and weird behavior for now.**

When you run this script, it will ask you several questions about your farm (and co-op if applicable). It then makes predictions about what your farm will be like by the end of the contract and whether or not you will be able to meet the contract goal.
## Disclaimer
This is a Lua script that performs calculations using numbers manually provided to it by the user. It does not interact with your Egg, Inc. game in any way.
## Prerequisites
This script was written for [Lua 5.4.6](https://www.lua.org/). However, it should work with any recent version of Lua.
## Installation
1. Install [Lua](https://www.lua.org/).
2. Download the latest version of the script from the [releases](https://github.com/HomeDataRoom/egg-calculator/releases) page.
3. Extract the zipped folder.
4. Run ``egg.bat`` if using Windows, or run ``egg.lua`` in any Lua environment.
   - If the batch file doesn't work, change the first file path to use the folder Lua is installed in.
## Limitations
This script does not (directly) take into account the effects of research, boosts, egg value, your mystical egg bonus, artifacts, events, or bonuses from in-app purchases or subscriptions. However, since many of these mechanics are interconnected, they are indirectly taken into account by the numbers you input into the script.

The script assumes your maximum shipping rate is higher than your actual shipping rate, and that there are no bottlenecks as a result. If the shipping rate *is* being bottlenecked, that's OK.
## Credits
<a href="https://github.com/homedataroom/egg-calculator/graphs/contributors"><img src="https://contrib.rocks/image?repo=homedataroom/egg-calculator"></a>
