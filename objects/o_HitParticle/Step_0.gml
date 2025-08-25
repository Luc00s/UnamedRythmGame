speed = max(0, speed - friction);
life--;

if (life <= 0) {
    instance_destroy();
}