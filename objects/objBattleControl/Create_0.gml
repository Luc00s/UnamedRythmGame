battleBoxes = [];
battleBoxActive = false;
battleBoxCount = 1;
battleExitTimer = 0;
battleExitTimeout = 300;
previousRoom = -1;

// Enemy system
battleEnemies = [];
maxEnemies = 5;

// Enemy spawning system
pendingEnemyTypes = [];
shouldSpawnEnemies = false;

// Enemy prefab definitions
function getEnemyPrefab(enemyType) {
    switch(enemyType) {
        case "gnome":
            return {
                name: "Gnome",
                currentHp: 50,
                maxHp: 50,
                dmg: 12,
                defense: 5,
                ability: "Earth Strike",
                spriteIndex: SprEnemieGnome,
                imageIndex: 0,
                imageSpeed: 1,
                xScale: 1,
                yScale: 1
            };
            
        // Add more enemy types here later
        default:
            return {
                name: "Unknown",
                currentHp: 1,
                maxHp: 1,
                dmg: 1,
                defense: 0,
                ability: "None",
                spriteIndex: SprEnemieGnome,
                imageIndex: 0,
                imageSpeed: 1,
                xScale: 1,
                yScale: 1
            };
    }
}

// Function to calculate enemy positions with alternating zigzag
function calculateEnemyPositions(enemyCount) {
    var positions = [];
    
    if (enemyCount <= 0) return positions;
    
    var centerX = room_width / 2;
    var centerY = (room_height / 2) - 16;
    
    // Get sprite width from existing enemies, or default if none exist
    var spriteWidth = 32; // Default fallback width
    var centerEnemy = instance_find(objBattleEnemy, 0);
    if (instance_exists(centerEnemy)) {
        // Get the sprite width from the center enemy
        spriteWidth = sprite_get_width(centerEnemy.sprite_index);
    } else {
        // If no enemies exist yet, use a default sprite
        spriteWidth = sprite_get_width(SprEnemieGnome);
    }
    
    var spacing = spriteWidth - 4; // Sprite width + 4 pixels spacing
    var verticalOffset = 10; // How many pixels up/down from center
    
    // First enemy always in center
    positions[0] = {x: centerX, y: centerY};
    
    if (enemyCount == 1) return positions;
    
    // Generate positions dynamically for any number of enemies
    var side = 1; // 1 = right, -1 = left
    var upDown = -1; // Start with up (-1 = up, 1 = down)
    var distance = 1; // How far from center
    
    for (var i = 1; i < enemyCount; i++) {
        var xPos = centerX + (side * distance * spacing);
        var yPos = centerY;
        
        // Only apply vertical offset for "up" position
        if (upDown == -1) {
            yPos = centerY - verticalOffset; // Up position
        }
        // Down position stays at centerY (no offset)
        
        positions[i] = {x: xPos, y: yPos};
        
        // Alternate between right and left
        if (side == 1) {
            // Was right, now go left (same distance)
            side = -1;
        } else {
            // Was left, now go right (increase distance)
            side = 1;
            distance++;
        }
        
        // Alternate up and down every 2 enemies
        if (i % 2 == 0) {
            upDown = -upDown;
        }
    }
    
    return positions;
}

// Function to spawn battle enemies (additive)
function spawnBattleEnemies(enemyTypes) {
    // Safety check for undefined or invalid arrays
    if (enemyTypes == undefined || !is_array(enemyTypes)) {
        return;
    }
    
    var newEnemyCount = array_length(enemyTypes);
    var currentEnemyCount = instance_number(objBattleEnemy);
    var totalEnemyCount = min(currentEnemyCount + newEnemyCount, maxEnemies);
    
    // Only spawn if we haven't reached the maximum
    if (currentEnemyCount >= maxEnemies) {
        return; // Already at max capacity
    }
    
    // Calculate how many new enemies we can actually spawn
    var actualNewCount = min(newEnemyCount, maxEnemies - currentEnemyCount);
    
    // Reposition all enemies (existing + new) to maintain proper alignment
    var allPositions = calculateEnemyPositions(totalEnemyCount);
    
    // Keep existing enemies in their current positions - DON'T move them
    
    // Create new enemies starting from center position
    var centerX = room_width / 2;
    var centerY = (room_height / 2) - 16;
    
    for (var i = 0; i < actualNewCount; i++) {
        var enemyType = enemyTypes[i];
        var prefab = getEnemyPrefab(enemyType);
        var posIndex = currentEnemyCount + i;
        var pos = allPositions[posIndex];
        
        // Create battle enemy at center position (will move to target)
        var enemy = instance_create_depth(centerX, centerY, -100, objBattleEnemy);
        
        with (enemy) {
            // Set stats from prefab
            enemyName = prefab.name;
            currentHp = prefab.currentHp;
            maxHp = prefab.maxHp;
            dmg = prefab.dmg;
            defense = prefab.defense;
            ability = prefab.ability;
            
            // Set sprite properties
            sprite_index = prefab.spriteIndex;
            image_index = prefab.imageIndex;
            image_speed = prefab.imageSpeed;
            image_xscale = prefab.xScale;
            image_yscale = prefab.yScale;
            
            // Set movement targets (smooth movement to formation)
            targetX = pos.x;
            targetY = pos.y;
            
            // Set battle position index
            battleIndex = posIndex;
            
            // Add a small delay for staggered movement
            moveDelay = i * 5; // Each enemy waits 5 frames more than the previous
            moveTimer = 0;
        }
    }
}

// Function to clear all enemies
function clearAllEnemies() {
    with (objBattleEnemy) {
        instance_destroy();
    }
}

// Function to reset counters to 0 and prepare for animation (but don't disable)
function startCounterAnimation() {
    // Reset all counter display values to 0 but keep animation enabled
    var playerNames = ["violet", "red", "robot", "gang"];
    
    for (var p = 0; p < array_length(playerNames); p++) {
        var playerName = playerNames[p];
        
        // Reset HP counter display only
        if (variable_struct_exists(hpCounters, playerName)) {
            hpCounters[$ playerName].display_hp = 0;
            hpCounters[$ playerName].animTimer = 0;
            for (var i = 0; i < hpCounterConfig.digits; i++) {
                hpCounters[$ playerName].floats[i] = 0;
            }
        }
        
        // Reset Mana counter display only
        if (variable_struct_exists(manaCounters, playerName)) {
            manaCounters[$ playerName].display_mana = 0;
            manaCounters[$ playerName].animTimer = 0;
            for (var i = 0; i < manaCounterConfig.digits; i++) {
                manaCounters[$ playerName].floats[i] = 0;
            }
        }
    }
}


// Start all counter animations immediately when intro begins
function startAllCounterAnimations() {
    var playerNames = ["violet", "red", "robot", "gang"];
    
    for (var p = 0; p < array_length(playerNames); p++) {
        var playerName = playerNames[p];
        
        // Start HP counter animation
        if (variable_struct_exists(hpCounters, playerName) && variable_struct_exists(playerStats, playerName)) {
            hpCounters[$ playerName].shouldAnimate = true;
            hpCounters[$ playerName].animTimer = 0;
        }
        
        // Start Mana counter animation
        if (variable_struct_exists(manaCounters, playerName) && variable_struct_exists(playerStats, playerName)) {
            manaCounters[$ playerName].shouldAnimate = true;
            manaCounters[$ playerName].animTimer = 0;
        }
    }
}

// Ensure battle GUI renders on top of transitions
depth = -10000;

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

// Rolling counter arrays for each player - start at 0 for animation effect
hpCounters = {
    violet: {floats: array_create(hpCounterConfig.digits, 0), current_hp: 0, display_hp: 0, shouldAnimate: false, animStartFrame: 0, animTimer: 0},
    red: {floats: array_create(hpCounterConfig.digits, 0), current_hp: 0, display_hp: 0, shouldAnimate: false, animStartFrame: 0, animTimer: 0},
    robot: {floats: array_create(hpCounterConfig.digits, 0), current_hp: 0, display_hp: 0, shouldAnimate: false, animStartFrame: 0, animTimer: 0},
    gang: {floats: array_create(hpCounterConfig.digits, 0), current_hp: 0, display_hp: 0, shouldAnimate: false, animStartFrame: 0, animTimer: 0}
};

// Rolling counter arrays for mana for each player - start at 0 for animation effect
manaCounters = {
    violet: {floats: array_create(manaCounterConfig.digits, 0), current_mana: 0, display_mana: 0, shouldAnimate: false, animStartFrame: 0, animTimer: 0},
    red: {floats: array_create(manaCounterConfig.digits, 0), current_mana: 0, display_mana: 0, shouldAnimate: false, animStartFrame: 0, animTimer: 0},
    robot: {floats: array_create(manaCounterConfig.digits, 0), current_mana: 0, display_mana: 0, shouldAnimate: false, animStartFrame: 0, animTimer: 0},
    gang: {floats: array_create(manaCounterConfig.digits, 0), current_mana: 0, display_mana: 0, shouldAnimate: false, animStartFrame: 0, animTimer: 0}
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

// Carousel Button System
carouselButtons = [];
carouselSelectedIndex = 0;
carouselTargetIndex = 0;
carouselCenterX = 12 + 22 + 6; // 12px padding + 22px horizontal radius + 6px right adjustment
carouselCenterY = 6 + 10 + 6;  // 6px padding + 10px vertical radius + 6px down adjustment
carouselRadiusX = 22;      // Horizontal radius (+6px)
carouselRadiusY = 8;       // Vertical radius
carouselRotationSpeed = 0.35; // Fast rotation interpolation speed

// Animation properties
carouselAnimationEase = 0.45;  // Fast easing factor for quick movement

// Initialize carousel buttons (4 buttons matching sprite frames)
for (var i = 0; i < 4; i++) {
    var button = {
        index: i,
        currentAngle: (i / 4) * 2 * pi, // Evenly spaced around ellipse
        targetAngle: (i / 4) * 2 * pi,
        x: 0,
        y: 0,
        // Intro/Outro animation properties
        introY: -50, // Start position (above screen)
        targetY: 0,  // Target position (will be calculated)
        currentOffsetY: -50, // Current Y offset from target
        introDelay: i * 3, // Fast staggered intro timing
        introTimer: 0,
        introActive: false,
        outroActive: false
    };
    array_push(carouselButtons, button);
}

// Input handling for carousel
carouselInputTimer = 0;
carouselInputDelay = 12;     // Initial delay before repeating
carouselInputRepeatRate = 6; // Frames between repeats when holding
carouselLeftPressed = false;
carouselRightPressed = false;
carouselUpPressed = false;
carouselDownPressed = false;

// Button animation states
carouselIntroActive = false;
carouselOutroActive = false;
carouselAnimationTimer = 0;

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
    var targetHP = counter.shouldAnimate ? playerStats[$ playerName].health : 0;
    
    // Simple frame-based counter system - all counters finish in exactly 1.5 seconds
    if (counter.shouldAnimate) {
        var animationDurationFrames = 90; // 1.5 seconds at 60 FPS
        counter.animTimer++;
        
        var progress = min(counter.animTimer / animationDurationFrames, 1.0);
        counter.display_hp = floor(targetHP * progress);
        
        // Stop animation when complete but keep final value
        if (counter.animTimer >= animationDurationFrames) {
            counter.display_hp = targetHP;
            counter.shouldAnimate = false;
        }
    } else if (counter.animTimer == 0) {
        counter.display_hp = 0; // Only stay at 0 when not started animating
    }
    
    // Convert display HP to string with leading zeros for target digits
    var displayValue = counter.display_hp;
    var hpString = "";
    repeat(hpCounterConfig.digits - string_length(string(displayValue))) {
        hpString += "0";
    }
    hpString += string(displayValue);
    
    // Update float values with smooth rolling effect toward target digits
    for (var i = 0; i < hpCounterConfig.digits; i++) {
        var targetDigit = real(string_char_at(hpString, i + 1));
        var distance = abs(targetDigit - counter.floats[i]);
        
        // Handle wrap-around for rolling effect
        if (distance >= 5) {
            if (targetDigit < counter.floats[i]) {
                counter.floats[i] -= 10;
            } else if (counter.floats[i] < targetDigit) {
                counter.floats[i] += 10;
            }
        }
        
        // Smooth roll animation toward the target digit
        counter.floats[i] = lerp(counter.floats[i], targetDigit, 0.15);
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
    var targetMana = counter.shouldAnimate ? playerStats[$ playerName].mana : 0;
    
    // Simple frame-based counter system - all counters finish in exactly 1.5 seconds
    if (counter.shouldAnimate) {
        var animationDurationFrames = 90; // 1.5 seconds at 60 FPS
        counter.animTimer++;
        
        var progress = min(counter.animTimer / animationDurationFrames, 1.0);
        counter.display_mana = floor(targetMana * progress);
        
        // Stop animation when complete but keep final value
        if (counter.animTimer >= animationDurationFrames) {
            counter.display_mana = targetMana;
            counter.shouldAnimate = false;
        }
    } else if (counter.animTimer == 0) {
        counter.display_mana = 0; // Only stay at 0 when not started animating
    }
    
    // Convert display mana to string with leading zeros for target digits
    var displayValue = counter.display_mana;
    var manaString = "";
    repeat(manaCounterConfig.digits - string_length(string(displayValue))) {
        manaString += "0";
    }
    manaString += string(displayValue);
    
    // Update float values with smooth rolling effect toward target digits
    for (var i = 0; i < manaCounterConfig.digits; i++) {
        var targetDigit = real(string_char_at(manaString, i + 1));
        var distance = abs(targetDigit - counter.floats[i]);
        
        // Handle wrap-around for rolling effect
        if (distance >= 5) {
            if (targetDigit < counter.floats[i]) {
                counter.floats[i] -= 10;
            } else if (counter.floats[i] < targetDigit) {
                counter.floats[i] += 10;
            }
        }
        
        // Smooth roll animation toward the target digit
        counter.floats[i] = lerp(counter.floats[i], targetDigit, 0.15);
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