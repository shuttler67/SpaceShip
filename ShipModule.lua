ShipModule = Class()

ShipModule.unitWidth = 32
ShipModule.unitHeight = 32
ShipModule.unitWidthHalf = 16
ShipModule.unitHeightHalf = 16

ShipModule.NORTH = 0
ShipModule.EAST = math.pi/2
ShipModule.SOUTH = math.pi
ShipModule.WEST = math.pi * 1.5

function ShipModule:init()
    self.orientation = ShipModule.EAST
    self.attachedToShip = false
    