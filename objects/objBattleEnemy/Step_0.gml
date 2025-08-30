// Battle Enemy Step Event

// Smooth movement toward target position
x = lerp(x, targetX, moveSpeed);
y = lerp(y, targetY, moveSpeed);

// Update depth for proper layering
depth = -y;

// Handle death
if (currentHp <= 0 && !isDead) {
    isDead = true;
    // Could add death animation here
}

// Simple idle animation
animTimer++;
if (battleState == "idle") {
    // Simple breathing animation or idle behavior
}