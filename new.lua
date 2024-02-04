local rednetSide = "left"
local channel = 69
local torchSlot = 16
local chestSlot = 15

local function turtleCheck()
	while turtle.detect() do
		os.sleep(5)
	end
end


local function placeTorchLeft()
  if turtle.getItemCount(torchSlot) > 0 then
    turtle.select(torchSlot)
    turtle.turnLeft() -- Face left before placing torch
    turtle.place()
    turtle.turnRight() -- Face back to the original direction
  else
    print("No torches available in the inventory!")
  end
end

local function returnAndDropItems()
  print("Dropping all items and continuing mining...")

  -- Dig down and place a chest
  turtle.digDown()
  turtle.placeDown("minecraft:chest")

  -- Drop all items into the chest below
  for slot = 1, 16 do
    turtle.select(slot)
    turtle.dropDown()
  end

  -- Move forward to continue mining
  turtleCheck()
end



-- Main program
rednet.open(rednetSide)

parallel.waitForAny(
  function()
    while true do
      rednet.broadcast("StartMining", tostring(channel))
      os.sleep(1)  -- Wait for a short duration to avoid flooding the network
    end
  end,
  synchronizeTurtles
)

rednet.close(rednetSide)
