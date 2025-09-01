// Draw Enemy Selection Arrow in world coordinates (in front of enemies)
if (battleBoxActive && enemySelectionArrowVisible && battleGUIState == "enemy_selection") {
    var sortedEnemies = getEnemiesSortedByX();
    var enemyCount = array_length(sortedEnemies);
    
    if (enemyCount > 0 && selectedEnemyIndex < enemyCount) {
        var selectedEnemyData = sortedEnemies[selectedEnemyIndex];
        
        if (instance_exists(selectedEnemyData.instance)) {
            // Draw the SprSelectEnemieArrow sprite with animated position and rotation
            // Use a very high depth (very front) to ensure visibility
            var originalDepth = depth;
            depth = -10000;
            
            draw_sprite_ext(SprSelectEnemieArrow, 0, arrowCurrentX, arrowCurrentY, 1, 1, 0, c_white, arrowCurrentAlpha);
            
            // Restore original depth
            depth = originalDepth;
        }
    }
}