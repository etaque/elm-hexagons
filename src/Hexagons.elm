module Hexagons (Axial, Point, dims, axialToPoint, pointToAxial, axialLine, axialDistance, axialRange) where

{-| Suite of functions for hexagonal grid computing, focused on horizontal grids ("pointy topped" hexagons) with axial coordinate system.

See http://www.redblobgames.com/grids/hexagons for reference.

# Types
@docs Axial, Point

# Conversions
@docs dims, axialToPoint, pointToAxial

# Measuring
@docs axialDistance

# Drawing
@docs axialLine, axialRange
-}


{-| Cubic coordinates -}
type alias Cube number = (number, number, number)
type alias FloatCube = Cube Float
type alias IntCube = Cube Int

{-| Axial coordinates of an hexagon with a grid -}
type alias Axial = (Int, Int)

{-| Point on screen (pixel) -}
type alias Point = (Float, Float)


{-| Given radius, returns width and height of hexagon
-}
dims : Float -> (Float, Float)
dims hexRadius =
  let
    hexHeight = hexRadius * 2
    hexWidth = (sqrt 3) / 2 * hexHeight
  in
    (hexWidth, hexHeight)


{-| Given hex radius and axial coords, return pixel coords of its center
-}
axialToPoint : Float -> Axial -> Point
axialToPoint axialRadius (i, j) =
  let
    x = axialRadius * (sqrt 3) * (toFloat i + toFloat j / 2)
    y = axialRadius * 3 / 2 * toFloat j
  in
    (x, y)


{-| Given hex radius and pixel coords, returns corresponding axial coords
-}
pointToAxial : Float -> Point -> Axial
pointToAxial axialRadius (x, y) =
  let
    i = (x * (sqrt 3) / 3 - y / 3) / axialRadius
    j = y * (2 / 3) / axialRadius
  in
    axialRound (i, j)


{-| List all hexagons composing a line between two hexagons.

See [Line Drawing](http://www.redblobgames.com/grids/hexagons/#line-drawing) on Red Blob Games
 -}
axialLine : Axial -> Axial -> List Axial
axialLine a b =
  List.map cubeToAxial (cubeLine (axialToCube a) (axialToCube b))


{-| List all hexagons within given distance of this one.

See [Range](http://www.redblobgames.com/grids/hexagons/#range) on Red Blob Games
-}
axialRange : Axial -> Int -> List Axial
axialRange center n =
  let
    mapX dx =
      let
        fromY = max -n (-dx - n)
        toY = min n (-dx + n)
        mapY dy = axialAdd center (dx, dy)
      in
        List.map mapY [ fromY .. toY ]
  in
    List.concatMap mapX [ -n .. n ]


{-| Distance between two axial coordinates -}
axialDistance : Axial -> Axial -> Int
axialDistance a b =
  cubeDistance (axialToCube a) (axialToCube b)


axialRound : (Float, Float) -> Axial
axialRound =
  axialToCube >> cubeRound >> cubeToAxial


cubeRound : FloatCube -> IntCube
cubeRound (x, y, z) =
  let
    rx = round x
    ry = round y
    rz = round z

    xDiff = abs (toFloat rx - x)
    yDiff = abs (toFloat ry - y)
    zDiff = abs (toFloat rz - z)
  in
    if xDiff > yDiff && xDiff > zDiff then
      (-ry-rz, ry, rz)
    else if yDiff > zDiff then
           (rx, -rx-rz, rz)
         else (rx, ry, -rx-ry)


cubeDistance : IntCube -> IntCube -> Int
cubeDistance (ax, ay, az) (bx, by, bz) =
  (abs (ax - bx) + abs (ay - by) + abs (az - bz)) // 2


cubeLinearInterpol : IntCube -> IntCube -> Float -> Cube Float
cubeLinearInterpol a b t =
  let
    (ax, ay, az) = floatCube a
    (bx, by, bz) = floatCube b
    i = ax + (bx - ax) * t
    j = ay + (by - ay) * t
    k = az + (bz - az) * t
  in
    (i, j, k)


floatCube : IntCube -> FloatCube
floatCube (x, y, z) =
  (toFloat x, toFloat y, toFloat z)


cubeLine : IntCube -> IntCube -> List (IntCube)
cubeLine a b =
  let
    n = cubeDistance a b
    offsetMapper i = cubeRound (cubeLinearInterpol a b (1 / (toFloat n) * (toFloat i)))
  in
    List.map offsetMapper [ 0..n ]


axialAdd : Axial -> Axial -> Axial
axialAdd (x, y) (x', y') =
  (x + x', y + y')


cubeAdd : IntCube -> IntCube -> IntCube
cubeAdd (x, y, z) (i, j, k) =
  (x + i, y + j, z + k)


cubeToAxial : Cube number -> (number, number)
cubeToAxial (x, y, z) =
  (x, y)


axialToCube : (number, number) -> Cube number
axialToCube (i, j) =
  (i, j, -i-j)

