# ✅ Items Successfully Added to ox_inventory

## Items Added to `ox_inventory/data/items.lua`

### Raw Materials (3 items):
1. ✅ **raw_coke** - Rå Kokain (100g weight)
2. ✅ **raw_heroin** - Rå Heroin (100g weight)
3. ✅ **raw_meth** - Rå Metamfetamin (100g weight)

### Processed Drugs (4 items):
4. ✅ **coke_bag** - Kokain Pose (50g weight)
5. ✅ **heroin_bag** - Heroin Pose (50g weight)
6. ✅ **meth_bag** - Metamfetamin Pose (50g weight)
7. ✅ **joint** - Joint (10g weight)

### Note:
- **cannabis** item already exists in ox_inventory (line 247)
- Using the existing cannabis item for joint crafting
- Total: 7 new items added

---

## Item Details

### Raw Materials
```lua
["raw_coke"] = {
    label = "Rå Kokain",
    weight = 100,
    stack = true,
    close = true,
    description = "Uforarbejdet kokain - skal forarbejdes før brug",
    client = { image = "coke_brick.png" }
}

["raw_heroin"] = {
    label = "Rå Heroin",
    weight = 100,
    stack = true,
    close = true,
    description = "Uforarbejdet heroin - skal forarbejdes før brug",
    client = { image = "heroin_brick.png" }
}

["raw_meth"] = {
    label = "Rå Metamfetamin",
    weight = 100,
    stack = true,
    close = true,
    description = "Uforarbejdet metamfetamin - skal forarbejdes før brug",
    client = { image = "meth_brick.png" }
}
```

### Processed Drugs
```lua
["coke_bag"] = {
    label = "Kokain Pose",
    weight = 50,
    stack = true,
    close = true,
    description = "En pose med kokain - klar til salg",
    client = { image = "coke_bag.png" }
}

["heroin_bag"] = {
    label = "Heroin Pose",
    weight = 50,
    stack = true,
    close = true,
    description = "En pose med heroin - klar til salg",
    client = { image = "heroin_bag.png" }
}

["meth_bag"] = {
    label = "Metamfetamin Pose",
    weight = 50,
    stack = true,
    close = true,
    description = "En pose med metamfetamin - klar til salg",
    client = { image = "meth_bag.png" }
}

["joint"] = {
    label = "Joint",
    weight = 10,
    stack = true,
    close = true,
    description = "En joint rullet med cannabis",
    client = { image = "joint.png" }
}
```

---

## Next Steps

### 1. Add Item Images (Optional but Recommended)
Create or download PNG images (512x512) and place them in:
`ox_inventory/web/images/`

**Required images:**
- `coke_brick.png` (for raw_coke)
- `heroin_brick.png` (for raw_heroin)
- `meth_brick.png` (for raw_meth)
- `cannabis.png` (existing item)
- `coke_bag.png` (for coke_bag)
- `heroin_bag.png` (for heroin_bag)
- `meth_bag.png` (for meth_bag)
- `joint.png` (for joint)

**If images don't exist:** Items will still work but show a placeholder image.

### 2. Restart ox_inventory
```
restart ox_inventory
```

### 3. Test Items
Give yourself test items:
```
/giveitem [your_id] raw_coke 10
/giveitem [your_id] raw_heroin 10
/giveitem [your_id] raw_meth 10
/giveitem [your_id] cannabis 20
```

---

## Item Compatibility

✅ **All items are compatible with:**
- ox_inventory (native support)
- ESX framework
- belmont-illegaljobs script

✅ **Item Properties:**
- All items are stackable
- All items close inventory when used
- All items have Danish descriptions
- All items have appropriate weights

---

## Verification

✅ No duplicate items (cannabis was already present)
✅ No syntax errors
✅ All items properly formatted
✅ Items added at end of file (lines 429-511)
✅ Ready for production use

---

**Status: Complete!** ✅

Your ox_inventory now has all required items for the illegal jobs script.
