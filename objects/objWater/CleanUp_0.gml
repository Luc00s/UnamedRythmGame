if (surface_exists(waterSurface)) {
    surface_free(waterSurface);
}
if (surface_exists(backgroundSurface)) {
    surface_free(backgroundSurface);
}
if (surface_exists(distortedTemp)) {
    surface_free(distortedTemp);
}
if (surface_exists(waterOverlaySurface)) {
    surface_free(waterOverlaySurface);
}
if (surface_exists(reflectionTemp)) {
    surface_free(reflectionTemp);
}
if (surface_exists(maskedReflection)) {
    surface_free(maskedReflection);
}
if (surface_exists(outlineSurface)) {
    surface_free(outlineSurface);
}
if (surface_exists(tileMaskSurface)) {
    surface_free(tileMaskSurface);
}
