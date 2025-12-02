# Advent of Code 2025

## About

[Advent of Code](https://adventofcode.com/) is an annual programming puzzle challenge oragized by [Eric Wastl](http://was.tl/). Between December 1 and December 12, a new programming puzzle is posted daily. This repo contains my solutions for the [2025 puzzles](https://adventofcode.com/2025). I encourage everyone to solve the puzzles on their own before looking at my solutions.

## Running the Code

Puzzle solutions will be stored in the `lib/` folder as `XX.lua`, where `XX` is the date of the puzzle, `01` through `12`. Puzzle inputs are not provided in this repo, but the scripts will look for them in the `data/` folder as `XX.txt`. To run the solutions, you must have [LuaJIT 2.1](https://luajit.org/) installed.

Open the repo on the command line and run a solution with:

```sh
luajit lib/XX.lua
```

Where `XX` is the date of the puzzle, `01` through `12`.

All of the scripts should be platform-agnostic and run wherever LuaJIT is supported.
