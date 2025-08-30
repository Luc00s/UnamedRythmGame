// Handle movement delay for smooth entrance
moveTimer++;

// Only move after delay has passed
if (moveTimer >= moveDelay) {
    // Smooth movement toward target position
    x = lerp(x, targetX, moveSpeed);
    y = lerp(y, targetY, moveSpeed);
}

// Update depth for proper layering
depth = -y;

// Handle death
if (currentHp <= 0 && !isDead) {
    isDead = true;
}

// Simple idle animation
animTimer++;
if (battleState == "idle") {
    // Idle behavior can be added here
}