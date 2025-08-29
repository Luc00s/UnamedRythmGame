battleBoxes = [];
battleBoxActive = false;
battleBoxCount = 1;
battleExitTimer = 0;
battleExitTimeout = 300;

// Rolling counter configuration for HP display
hpCounterConfig = {
    digits: 3,
    width: 5,
    height: 5
};

// Rolling counter configuration for Mana display
manaCounterConfig = {
    digits: 3,
    width: 5,
    height: 5
};

// Rolling counter arrays for each player
hpCounters = {
    violet: {floats: array_create(hpCounterConfig.digits, 0), current_hp: 100},
    red: {floats: array_create(hpCounterConfig.digits, 0), current_hp: 120},
    robot: {floats: array_create(hpCounterConfig.digits, 0), current_hp: 80},
    gang: {floats: array_create(hpCounterConfig.digits, 0), current_hp: 110}
};

// Rolling counter arrays for mana for each player
manaCounters = {
    violet: {floats: array_create(manaCounterConfig.digits, 0), current_mana: 50},
    red: {floats: array_create(manaCounterConfig.digits, 0), current_mana: 40},
    robot: {floats: array_create(manaCounterConfig.digits, 0), current_mana: 70},
    gang: {floats: array_create(manaCounterConfig.digits, 0), current_mana: 35}
};

// Sistema de estatísticas dos personagens
playerStats = {
    violet: {
        name: "Violet",
        health: 100,
        maxHealth: 100,
        mana: 50,
        maxMana: 50,
        status: []
    },
    red: {
        name: "Red",
        health: 120,
        maxHealth: 120,
        mana: 40,
        maxMana: 40,
        status: []
    },
    robot: {
        name: "Robot",
        health: 80,
        maxHealth: 80,
        mana: 70,
        maxMana: 70,
        status: []
    },
    gang: {
        name: "Gang",
        health: 110,
        maxHealth: 110,
        mana: 35,
        maxMana: 35,
        status: []
    }
};

// Conta membros ativos do grupo
function getPartyMemberCount() {
    var count = 0;
    
    if (instance_exists(objPlayer)) {
        count++;
    }
    
    count += instance_number(ObjFollower);
    
    return max(1, count);
}
animationTimer = 0;
movingUp = true;

topBarY = -35;
bottomBarY = room_height + 96;
topBarTargetY = -35;
bottomBarTargetY = room_height + 96;
barAnimSpeed = 6;
barAnimTimer = 0;
topBarLerpSpeed = 0.25;
bottomBarLerpSpeed = 0.22;
topBarScrollX = 0.0;
bottomBarScrollX = 0.0;
barScrollSpeed = 0.2;
textureScrollX = 0.0;
textureScrollY = 0.0;
textureScrollSpeedX = 0.15;
textureScrollSpeedY = 0.12;

// Funções auxiliares para gerenciamento de estatísticas
function damagePlayer(playerName, damage) {
    if (variable_struct_exists(playerStats, playerName)) {
        playerStats[$ playerName].health = max(0, playerStats[$ playerName].health - damage);
        return playerStats[$ playerName].health;
    }
    return -1;
}

function healPlayer(playerName, healAmount) {
    if (variable_struct_exists(playerStats, playerName)) {
        playerStats[$ playerName].health = min(playerStats[$ playerName].maxHealth, playerStats[$ playerName].health + healAmount);
        return playerStats[$ playerName].health;
    }
    return -1;
}

function useMana(playerName, manaUsed) {
    if (variable_struct_exists(playerStats, playerName)) {
        if (playerStats[$ playerName].mana >= manaUsed) {
            playerStats[$ playerName].mana -= manaUsed;
            return true;
        }
        return false;
    }
    return false;
}

function restoreMana(playerName, manaAmount) {
    if (variable_struct_exists(playerStats, playerName)) {
        playerStats[$ playerName].mana = min(playerStats[$ playerName].maxMana, playerStats[$ playerName].mana + manaAmount);
        return playerStats[$ playerName].mana;
    }
    return -1;
}

function addStatus(playerName, statusEffect) {
    if (variable_struct_exists(playerStats, playerName)) {
        var statusArray = playerStats[$ playerName].status;
        if (array_find_index(statusArray, statusEffect) == -1) {
            array_push(statusArray, statusEffect);
        }
    }
}

function removeStatus(playerName, statusEffect) {
    if (variable_struct_exists(playerStats, playerName)) {
        var statusArray = playerStats[$ playerName].status;
        var index = array_find_index(statusArray, statusEffect);
        if (index != -1) {
            array_delete(statusArray, index, 1);
        }
    }
}

function hasStatus(playerName, statusEffect) {
    if (variable_struct_exists(playerStats, playerName)) {
        var statusArray = playerStats[$ playerName].status;
        return array_find_index(statusArray, statusEffect) != -1;
    }
    return false;
}

function getPlayerHealth(playerName) {
    if (variable_struct_exists(playerStats, playerName)) {
        return playerStats[$ playerName].health;
    }
    return -1;
}

function getPlayerMana(playerName) {
    if (variable_struct_exists(playerStats, playerName)) {
        return playerStats[$ playerName].mana;
    }
    return -1;
}

function isPlayerAlive(playerName) {
    if (variable_struct_exists(playerStats, playerName)) {
        return playerStats[$ playerName].health > 0;
    }
    return false;
}

// Rolling counter functions
function updateHPCounter(playerName) {
    if (!variable_struct_exists(hpCounters, playerName) || !variable_struct_exists(playerStats, playerName)) {
        return;
    }
    
    var counter = hpCounters[$ playerName];
    var targetHP = playerStats[$ playerName].health;
    counter.current_hp = targetHP;
    
    // Convert HP to string with leading zeros
    var hpString = "";
    repeat(hpCounterConfig.digits - string_length(string(targetHP))) {
        hpString += "0";
    }
    hpString += string(targetHP);
    
    // Update float values for each digit
    for (var i = 0; i < hpCounterConfig.digits; i++) {
        var targetDigit = real(string_char_at(hpString, i + 1));
        var distance = abs(targetDigit - counter.floats[i]);
        
        if (distance >= 5) {
            if (targetDigit < counter.floats[i]) {
                counter.floats[i] -= 10;
            } else if (counter.floats[i] < targetDigit) {
                counter.floats[i] += 10;
            }
        }
        
        counter.floats[i] = lerp(counter.floats[i], targetDigit, 0.1);
        if (abs(counter.floats[i] - targetDigit) < 0.1) {
            counter.floats[i] = targetDigit;
        }
    }
}

function drawHPCounter(playerName, originX, originY, colorRow = 0) {
    if (!variable_struct_exists(hpCounters, playerName) || !variable_struct_exists(playerStats, playerName)) {
        return;
    }
    
    var counter = hpCounters[$ playerName];
    var targetHP = playerStats[$ playerName].health;
    
    // Calculate leading zero threshold
    var targetThreshold = power(10, hpCounterConfig.digits - 1);
    if (targetHP == 0) {
        targetThreshold = 0;
    } else {
        while (targetThreshold > targetHP && targetThreshold > 1) {
            targetThreshold /= 10;
        }
    }
    
    // Calculate stable current threshold
    var currentValue = 0;
    for (var i = 0; i < hpCounterConfig.digits; i++) {
        currentValue += floor(counter.floats[i]) * power(10, hpCounterConfig.digits - 1 - i);
    }
    var stableValue = max(currentValue, targetHP);
    var currentThreshold = power(10, hpCounterConfig.digits - 1);
    if (stableValue == 0) {
        currentThreshold = 0;
    } else {
        while (currentThreshold > stableValue && currentThreshold > 1) {
            currentThreshold /= 10;
        }
    }
    
    // Draw each digit
    for (var i = 0; i < hpCounterConfig.digits; i++) {
        var floatValue = counter.floats[i];
        if (floatValue < 0) floatValue += 10;
        
        var Frac = frac(floatValue);
        var currentDigit = floor(floatValue) % 10;
        var nextDigit = (currentDigit + 1) % 10;
        var drawX = originX + i * hpCounterConfig.width;
        
        // Get target digit for this position
        var hpString = "";
        repeat(hpCounterConfig.digits - string_length(string(targetHP))) {
            hpString += "0";
        }
        hpString += string(targetHP);
        var targetDigit = real(string_char_at(hpString, i + 1));
        
        // Northern Digit Part (current digit - scrolling out)
        var partLeft = currentDigit * hpCounterConfig.width;
        var digitPlaceValue = power(10, hpCounterConfig.digits - 1 - i);
        var isLeadingZero = (currentDigit == 0 && digitPlaceValue >= currentThreshold);
        var currentColorRow = isLeadingZero ? colorRow + 2 : colorRow;
        var partTop = currentColorRow * hpCounterConfig.height + Frac * hpCounterConfig.height;
        var partHeight = hpCounterConfig.height - (Frac * hpCounterConfig.height);
        var drawY = originY;
        
        draw_sprite_part(SprNumbers, 0, partLeft, partTop, hpCounterConfig.width, partHeight, drawX, drawY);
        
        // Southern Digit Part (next digit - scrolling in)
        partLeft = nextDigit * hpCounterConfig.width;
        var targetIsLeadingZero = (targetDigit == 0 && digitPlaceValue >= targetThreshold);
        var isNextLeadingZero = (nextDigit == 0 && targetIsLeadingZero);
        var nextColorRow = isNextLeadingZero ? colorRow + 2 : colorRow;
        partTop = nextColorRow * hpCounterConfig.height;
        partHeight = Frac * hpCounterConfig.height;
        drawY = originY + hpCounterConfig.height - partHeight;
        
        draw_sprite_part(SprNumbers, 0, partLeft, partTop, hpCounterConfig.width, partHeight, drawX, drawY);
    }
}

// Mana counter functions
function updateManaCounter(playerName) {
    if (!variable_struct_exists(manaCounters, playerName) || !variable_struct_exists(playerStats, playerName)) {
        return;
    }
    
    var counter = manaCounters[$ playerName];
    var targetMana = playerStats[$ playerName].mana;
    counter.current_mana = targetMana;
    
    // Convert mana to string with leading zeros
    var manaString = "";
    repeat(manaCounterConfig.digits - string_length(string(targetMana))) {
        manaString += "0";
    }
    manaString += string(targetMana);
    
    // Update float values for each digit
    for (var i = 0; i < manaCounterConfig.digits; i++) {
        var targetDigit = real(string_char_at(manaString, i + 1));
        var distance = abs(targetDigit - counter.floats[i]);
        
        if (distance >= 5) {
            if (targetDigit < counter.floats[i]) {
                counter.floats[i] -= 10;
            } else if (counter.floats[i] < targetDigit) {
                counter.floats[i] += 10;
            }
        }
        
        counter.floats[i] = lerp(counter.floats[i], targetDigit, 0.1);
        if (abs(counter.floats[i] - targetDigit) < 0.1) {
            counter.floats[i] = targetDigit;
        }
    }
}

function drawManaCounter(playerName, originX, originY, colorRow = 2, hpColorRow = 0) {
    if (!variable_struct_exists(manaCounters, playerName) || !variable_struct_exists(playerStats, playerName)) {
        return;
    }
    
    var counter = manaCounters[$ playerName];
    var targetMana = playerStats[$ playerName].mana;
    
    // Calculate leading zero threshold
    var targetThreshold = power(10, manaCounterConfig.digits - 1);
    if (targetMana == 0) {
        targetThreshold = 0;
    } else {
        while (targetThreshold > targetMana && targetThreshold > 1) {
            targetThreshold /= 10;
        }
    }
    
    // Calculate stable current threshold
    var currentValue = 0;
    for (var i = 0; i < manaCounterConfig.digits; i++) {
        currentValue += floor(counter.floats[i]) * power(10, manaCounterConfig.digits - 1 - i);
    }
    var stableValue = max(currentValue, targetMana);
    var currentThreshold = power(10, manaCounterConfig.digits - 1);
    if (stableValue == 0) {
        currentThreshold = 0;
    } else {
        while (currentThreshold > stableValue && currentThreshold > 1) {
            currentThreshold /= 10;
        }
    }
    
    // Draw each digit
    for (var i = 0; i < manaCounterConfig.digits; i++) {
        var floatValue = counter.floats[i];
        if (floatValue < 0) floatValue += 10;
        
        var Frac = frac(floatValue);
        var currentDigit = floor(floatValue) % 10;
        var nextDigit = (currentDigit + 1) % 10;
        var drawX = originX + i * manaCounterConfig.width;
        
        // Get target digit for this position
        var manaString = "";
        repeat(manaCounterConfig.digits - string_length(string(targetMana))) {
            manaString += "0";
        }
        manaString += string(targetMana);
        var targetDigit = real(string_char_at(manaString, i + 1));
        
        // Northern Digit Part (current digit - scrolling out)
        var partLeft = currentDigit * manaCounterConfig.width;
        var digitPlaceValue = power(10, manaCounterConfig.digits - 1 - i);
        var isLeadingZero = (currentDigit == 0 && digitPlaceValue >= currentThreshold);
        var currentColorRow = isLeadingZero ? hpColorRow + 2 : colorRow;
        var partTop = currentColorRow * manaCounterConfig.height + Frac * manaCounterConfig.height;
        var partHeight = manaCounterConfig.height - (Frac * manaCounterConfig.height);
        var drawY = originY;
        
        draw_sprite_part(SprNumbers, 0, partLeft, partTop, manaCounterConfig.width, partHeight, drawX, drawY);
        
        // Southern Digit Part (next digit - scrolling in)
        partLeft = nextDigit * manaCounterConfig.width;
        var targetIsLeadingZero = (targetDigit == 0 && digitPlaceValue >= targetThreshold);
        var isNextLeadingZero = (nextDigit == 0 && targetIsLeadingZero);
        var nextColorRow = isNextLeadingZero ? hpColorRow + 2 : colorRow;
        partTop = nextColorRow * manaCounterConfig.height;
        partHeight = Frac * manaCounterConfig.height;
        drawY = originY + manaCounterConfig.height - partHeight;
        
        draw_sprite_part(SprNumbers, 0, partLeft, partTop, manaCounterConfig.width, partHeight, drawX, drawY);
    }
}