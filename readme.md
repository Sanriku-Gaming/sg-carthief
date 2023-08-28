# Installation Instructions:
## Step 1:
- Drag and drop `sg-carthief` into your [standalone] folder
`or`
- Drag and drop `sg-carthief` into you resources folder and add `#ensure sg-carthief` on the server.cfg

## Step 2:
- Open the [assets] folder in `sg-carthief` and add the item(s) from `items.lua` to `qb-core\shared\items.lua`

## Step 3:
- Open the [img] folder in `sg-carthief\assets` and add the file to `qb-inventory\html\images`

## Step 4:
- Open `sg-carthief\config.lua` and adjust as necessary

## Step 5:
- In the server console type `ensure sg-carthief` or restart the server

### Optional Step:
- In `sg-carthief\client\client.lua` lines 7-70 is the CallCops() function.
- Locate your dispatch type and adjust values as needed

### Optional Step:
- In `sg-carthief\client\client.lua` lines 124-134 is the minigame for searching.
- Adjust the values, or change to your preferred minigame.