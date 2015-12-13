# Elm Hexagons

An Elm library for hexagonal grids handling, based on the awesome
[Hexagonal Grids Reference](http://www.redblobgames.com/grids/hexagons) from Red Blob Games
and extracted from [Tacks](https://github.com/etaque/tacks/) source code.

For now this lib is focused on axial coordinates for horizontal (pointy-topped) hexagons.


## What's available

Coordinates handling (`Hexagons` module):

* Find pixel center of an hexagon: `axialToPoint`
* Find hexagon containing a pixel point: `pointToAxial`
* Compute "hexagonal distance" between two hexagons: `axialDistance`
* Compute line between to hexagons: `axialLine`
* Compute all hexagons within distance from an hexagon (area): `axialRange`

Naive grid storage (`Hexagons.Grid` module):

* A grid is a `Dict Int (Dict Int a)`
* Get, set and remove data on grid: `getTile`, `createTile`, `deleteTile`
* List all tiles in grid: `getTilesList`


## What's next

* Deal with vertical (flat-topped) hexagons
* Expose cubic functions (split `Hexagons` main module into coordinates systems' specific modules?)
* Tests, tests, test!

