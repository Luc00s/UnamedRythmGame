battleBoxes = [];
battleBoxActive = false;
battleBoxCount = 1;
battleExitTimer = 0;
battleExitTimeout = 300;

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