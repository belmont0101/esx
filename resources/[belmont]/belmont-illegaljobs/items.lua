-- ====================================
-- ITEMS FOR OX_INVENTORY
-- ====================================
-- Add these items to your ox_inventory/data/items.lua file

-- RAW MATERIALS
['raw_coke'] = {
    label = 'Rå Kokain',
    weight = 100,
    stack = true,
    close = true,
    description = 'Uforarbejdet kokain - skal forarbejdes før brug',
    client = {
        image = 'coke_brick.png', -- Make sure you have this image
    }
},

['raw_heroin'] = {
    label = 'Rå Heroin',
    weight = 100,
    stack = true,
    close = true,
    description = 'Uforarbejdet heroin - skal forarbejdes før brug',
    client = {
        image = 'heroin_brick.png',
    }
},

['raw_meth'] = {
    label = 'Rå Metamfetamin',
    weight = 100,
    stack = true,
    close = true,
    description = 'Uforarbejdet metamfetamin - skal forarbejdes før brug',
    client = {
        image = 'meth_brick.png',
    }
},

['cannabis'] = {
    label = 'Cannabis',
    weight = 50,
    stack = true,
    close = true,
    description = 'Rå cannabis plante - kan rulles til joints',
    client = {
        image = 'cannabis.png',
    }
},

-- PROCESSED DRUGS
['coke_bag'] = {
    label = 'Kokain Pose',
    weight = 50,
    stack = true,
    close = true,
    description = 'En pose med kokain - klar til salg',
    client = {
        image = 'coke_bag.png',
    }
},

['heroin_bag'] = {
    label = 'Heroin Pose',
    weight = 50,
    stack = true,
    close = true,
    description = 'En pose med heroin - klar til salg',
    client = {
        image = 'heroin_bag.png',
    }
},

['meth_bag'] = {
    label = 'Metamfetamin Pose',
    weight = 50,
    stack = true,
    close = true,
    description = 'En pose med metamfetamin - klar til salg',
    client = {
        image = 'meth_bag.png',
    }
},

['joint'] = {
    label = 'Joint',
    weight = 10,
    stack = true,
    close = true,
    description = 'En joint rullet med cannabis',
    client = {
        image = 'joint.png',
    }
},
