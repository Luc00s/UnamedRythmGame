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

// Function to calculate enemy positions based on count
function calculateEnemyPositions(enemyCount) {
    var positions = [];
    var screenWidth = 320;
    var screenHeight = 240;
    var centerY = screenHeight / 2;
    
    if (enemyCount <= 0) return positions;
    
    // Calculate spacing and starting position
    var spacing = 60; // Distance between enemies
    var totalWidth = (enemyCount - 1) * spacing;
    var startX = (screenWidth - totalWidth) / 2;
    
    // Create position array
    for (var i = 0; i < enemyCount; i++) {
        var enemyX = startX + (i * spacing);
        var enemyY = centerY;
        
        array_push(positions, {x: enemyX, y: enemyY});
    }
    
    return positions;
}

// Function to spawn battle enemies
function spawnBattleEnemies(enemyTypes) {
    // Clear existing battle enemies first
    with (objBattleEnemy) {
        instance_destroy();
    }
    
    var enemyCount = array_length(enemyTypes);
    enemyCount = min(enemyCount, 5); // Max 5 enemies
    
    var positions = calculateEnemyPositions(enemyCount);
    
    for (var i = 0; i < enemyCount; i++) {
        var enemyType = enemyTypes[i];
        var prefab = getEnemyPrefab(enemyType);
        var pos = positions[i];
        
        // Create battle enemy instance
        var enemy = instance_create_depth(pos.x, pos.y, -100, objBattleEnemy);
        
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
            
            // Set battle position index
            battleIndex = i;
        }
    }
}