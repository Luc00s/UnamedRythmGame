// Dialog Manager - Draw GUI Event
// Render the dialog box and text

// Check if dialog is active and variables exist
if (!variable_instance_exists(id, "dialog_active") || !dialog_active) {
    exit;
}

// Set font if specified
if (variable_instance_exists(id, "dialog_font") && dialog_font != -1) {
    draw_set_font(dialog_font);
}

// Only draw if all required variables exist
if (variable_instance_exists(id, "dialog_x") && variable_instance_exists(id, "dialog_y") && 
    variable_instance_exists(id, "dialog_width") && variable_instance_exists(id, "dialog_height") &&
    variable_instance_exists(id, "dialog_bg_alpha") && variable_instance_exists(id, "dialog_bg_color")) {
    
    // Draw dialog box background
    draw_set_alpha(dialog_bg_alpha);
    draw_set_color(dialog_bg_color);
    draw_rectangle(dialog_x, dialog_y, dialog_x + dialog_width, dialog_y + dialog_height, false);

    // Draw dialog box border
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(dialog_x, dialog_y, dialog_x + dialog_width, dialog_y + dialog_height, true);

    // Draw emotion indicator (for question emotion)
    if (variable_instance_exists(id, "dialog_emotion") && dialog_emotion == 1) { // Question emotion
        draw_set_color(c_yellow);
        draw_text(dialog_x + dialog_width - 30, dialog_y + 5, "?");
    }

    // Draw the current text
    if (variable_instance_exists(id, "dialog_color") && variable_instance_exists(id, "dialog_margin") && 
        variable_instance_exists(id, "dialog_current_text")) {
        draw_set_color(dialog_color);
        draw_text_ext(dialog_x + dialog_margin, dialog_y + dialog_margin, dialog_current_text, -1, dialog_width - (dialog_margin * 2));
    }

    // Draw cursor if finished typing
    if (variable_instance_exists(id, "dialog_finished") && dialog_finished && 
        variable_instance_exists(id, "dialog_current_text") && variable_instance_exists(id, "dialog_margin")) {
        var text_width = string_width_ext(dialog_current_text, -1, dialog_width - (dialog_margin * 2));
        var text_height = string_height_ext(dialog_current_text, -1, dialog_width - (dialog_margin * 2));
        
        // Blinking cursor
        if (floor(current_time / 500) % 2 == 0) {
            draw_text(dialog_x + dialog_margin + text_width, dialog_y + dialog_margin + text_height - string_height("A"), "_");
        }
    }
}

// Reset drawing settings
draw_set_alpha(1);
draw_set_color(c_white);