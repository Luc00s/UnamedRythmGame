// Battle Enemy Create Event
enemyName = "Unknown";
currentHp = 50;
maxHp = 50;
dmg = 10;
defense = 2;
ability = "Attack";

battleIndex = 0;
isSelected = false;
isDead = false;

// Visual properties
image_speed = 1;
image_xscale = 1;
image_yscale = 1;

// Battle animation states
battleState = "idle";
animTimer = 0;

// Smooth movement properties
targetX = x;
targetY = y;
moveSpeed = 0.15; // Lerp speed for smooth movement

// Depth for proper layering
depth = -y;