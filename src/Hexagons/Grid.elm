module Hexagons.Grid (Grid, Row, Tile, get, set, delete, list, getPoint) where

{-| A naive grid storage for hexagons: `Dict Int (Dict Int a)`

# Types
@docs Grid, Row, Tile

# Finders
@docs get, list, getPoint

# Modifiers
@docs set, delete
-}


import Dict exposing (Dict)
import Hexagons exposing (..)


{-| A grid is a Dict of rows -}
type alias Grid a = Dict Int (Row a)


{-| A row is a Dict of values -}
type alias Row a = Dict Int a


{-| A tile has coords and some content -}
type alias Tile a =
  { content : a
  , coords : Axial
  }


{-| Find eventual content in grid on those axial coordinates -}
get : Grid a -> Axial -> Maybe a
get grid (i, j) =
  (Dict.get i grid) `Maybe.andThen` (Dict.get j)


{-| Add or update content to grid on those axial coordinates -}
set : a -> Axial -> Grid a -> Grid a
set tile (i,j) grid =
  let
    updateRow maybeRow =
      case maybeRow of
        Just row ->
          Dict.insert j tile row
        Nothing ->
          Dict.singleton j tile
  in
    Dict.insert i (updateRow (Dict.get i grid)) grid


{-| Remove content from those axial coordinates within grid -}
delete : Axial -> Grid a -> Grid a
delete (i, j) grid =
  let
    deleteInRow maybeRow =
      case maybeRow of
        Just row ->
          Dict.remove j row
        Nothing ->
          Dict.empty
  in
    Dict.insert i (deleteInRow (Dict.get i grid)) grid


{-| Produce a list of all tiles within grid -}
list : Grid a -> List (Tile a)
list grid =
  let
    rows =
      Dict.toList grid

    mapRow (i, row) =
      List.map (mapTile i) (Dict.toList row)

    mapTile i (j, kind) =
      Tile kind (i, j)
  in
    List.concatMap mapRow rows


{-| Given an hexagonal grid definition (radius and grid),
what's in the hexagon holding this point?
-}
getPoint : Float -> Grid a -> Point -> Maybe a
getPoint hexRadius grid p =
  Hexagons.pointToAxial hexRadius p
    |> get grid
