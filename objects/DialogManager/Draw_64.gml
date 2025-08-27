// Gerenciador de Diálogo - Evento Draw GUI
// Renderiza a caixa de diálogo e o texto

// Verifica se o diálogo está ativo e as variáveis existem
if (!variable_instance_exists(id, "dialog_active") || !dialog_active) {
    exit;
}

// Define fonte se especificada
if (variable_instance_exists(id, "dialog_font") && dialog_font != -1) {
    draw_set_font(dialog_font);
}

// Só desenha se todas as variáveis necessárias existirem
if (variable_instance_exists(id, "dialog_x") && variable_instance_exists(id, "dialog_y") && 
    variable_instance_exists(id, "dialog_width") && variable_instance_exists(id, "dialog_height") &&
    variable_instance_exists(id, "dialog_bg_alpha") && variable_instance_exists(id, "dialog_bg_color")) {
    
    // Desenha o fundo da caixa de diálogo
    draw_set_alpha(dialog_bg_alpha);
    draw_set_color(dialog_bg_color);
    draw_rectangle(dialog_x, dialog_y, dialog_x + dialog_width, dialog_y + dialog_height, false);

    // Desenha a borda da caixa de diálogo
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(dialog_x, dialog_y, dialog_x + dialog_width, dialog_y + dialog_height, true);
	
    // Desenha o texto atual
    if (variable_instance_exists(id, "dialog_color") && variable_instance_exists(id, "dialog_margin") && 
        variable_instance_exists(id, "dialog_current_text")) {
        draw_set_color(dialog_color);
        draw_text_ext(dialog_x + dialog_margin, dialog_y + dialog_margin, dialog_current_text, -1, dialog_width - (dialog_margin * 2));
    }
}

// Reseta configurações de desenho
draw_set_alpha(1);
draw_set_color(c_white);