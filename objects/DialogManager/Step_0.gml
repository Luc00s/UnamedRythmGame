// Gerenciador de Diálogo - Evento Step
// Gerencia a animação de digitação e pausas na pontuação

// Verifica se as variáveis existem e se o diálogo está ativo
if (!variable_instance_exists(id, "dialog_active") || !dialog_active) {
    exit;
}

// Gerencia pausa na pontuação
if (variable_instance_exists(id, "dialog_paused_at_punctuation") && dialog_paused_at_punctuation) {
    if (variable_instance_exists(id, "dialog_punctuation_counter")) {
        dialog_punctuation_counter--;
        if (dialog_punctuation_counter <= 0) {
            dialog_paused_at_punctuation = false;
        }
    }
    exit;
}

// Gerencia animação de digitação
if (variable_instance_exists(id, "dialog_finished") && !dialog_finished) {
    if (variable_instance_exists(id, "dialog_speed_counter") && variable_instance_exists(id, "dialog_speed")) {
        dialog_speed_counter += dialog_speed;
        
        if (dialog_speed_counter >= 1) {
            dialog_speed_counter -= 1;
            
            // Adiciona próximo caractere
            if (variable_instance_exists(id, "dialog_position") && variable_instance_exists(id, "dialog_text") && 
                dialog_position < string_length(dialog_text)) {
                
                dialog_position++;
                
                if (variable_instance_exists(id, "dialog_current_text")) {
                    dialog_current_text = string_copy(dialog_text, 1, dialog_position);
                }
                
                // Verifica se o caractere atual é pontuação
                var current_char = string_char_at(dialog_text, dialog_position);
                if (variable_instance_exists(id, "punctuation_marks")) {
                    for (var i = 0; i < array_length(punctuation_marks); i++) {
                        if (current_char == punctuation_marks[i]) {
                            dialog_paused_at_punctuation = true;
                            if (variable_instance_exists(id, "dialog_punctuation_pause_time")) {
                                dialog_punctuation_counter = dialog_punctuation_pause_time;
                            }
                            break;
                        }
                    }
                }
            } else if (variable_instance_exists(id, "dialog_position") && variable_instance_exists(id, "dialog_text") && 
                      dialog_position >= string_length(dialog_text)) {
                // Terminou de digitar
                dialog_finished = true;
            }
        }
    }
}