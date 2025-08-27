// Sistema de Diálogo - Funções Globais
// Chame essas funções de qualquer lugar para controlar o diálogo digitado

/// @function start_dialogue(text, speed, punctuation_pause, emotion, character)
/// @description Inicia um diálogo digitado com os parâmetros especificados
/// @param {string} text - O texto a ser exibido
/// @param {real} speed - Caracteres por step (padrão: 0.5)
/// @param {real} punctuation_pause - Steps para pausar na pontuação (padrão: 30)
/// @param {real} emotion - Indicador de emoção (0 = nenhuma, 1 = pergunta)
/// @param {string} character - Nome do personagem falando (padrão: "")
function start_dialogue(text, speed = 0.5, punctuation_pause = 30, emotion = 0, character = "") {
    // Garante que o DialogManager existe na room
    var dialog_manager = instance_find(DialogManager, 0);
    if (dialog_manager == noone) {
        // Cria DialogManager se não existir - usa a primeira layer disponível
        var layer_id = layer_get_id(layer_get_name(0));
        if (layer_id == -1) {
            // Se nenhuma layer existir, cria uma
            layer_id = layer_create(0, "DialogLayer");
        }
        dialog_manager = instance_create_layer(0, 0, layer_id, DialogManager);
    }
    
    // Define parâmetros do diálogo
    with (dialog_manager) {
        dialog_text = text;
        dialog_current_text = "";
        dialog_position = 0;
        dialog_finished = false;
        dialog_active = true;
        
        // Define parâmetros ajustáveis
        dialog_speed = speed;
        dialog_punctuation_pause_time = punctuation_pause;
        dialog_emotion = emotion;
        dialog_character = character;
        
        FMODManager.start_fmod_dialogue(text,1,"violet");
        
        // Reseta contadores
        dialog_speed_counter = 0;
        dialog_punctuation_counter = 0;
        dialog_paused_at_punctuation = false;
    }
}

/// @function stop_dialogue()
/// @description Para o diálogo atual
function stop_dialogue() {
    var dialog_manager = instance_find(DialogManager, 0);
    if (dialog_manager != noone) {
        with (dialog_manager) {
            dialog_active = false;
            dialog_finished = false;
            
            interrupt_speech();
        }
    }
}

/// @function is_dialogue_active()
/// @description Retorna true se o diálogo está ativo atualmente
/// @return {bool} Se o diálogo está sendo exibido
function is_dialogue_active() {
    var dialog_manager = instance_find(DialogManager, 0);
    if (dialog_manager != noone) {
        return dialog_manager.dialog_active;
    }
    return false;
}

/// @function is_dialogue_finished()
/// @description Retorna true se o diálogo terminou de digitar
/// @return {bool} Se o diálogo terminou de digitar
function is_dialogue_finished() {
    var dialog_manager = instance_find(DialogManager, 0);
    if (dialog_manager != noone) {
        return dialog_manager.dialog_finished;
    }
    return false;
}

/// @function skip_dialogue()
/// @description Pula para o fim do diálogo atual
function skip_dialogue() {
    var dialog_manager = instance_find(DialogManager, 0);
    if (dialog_manager != noone) {
        with (dialog_manager) {
            if (dialog_active && !dialog_finished) {
                dialog_position = string_length(dialog_text);
                dialog_current_text = dialog_text;
                dialog_finished = true;
                dialog_paused_at_punctuation = false;
            }
        }
    }
}

/// @function get_current_character()
/// @description Retorna o nome do personagem que está falando atualmente
/// @return {string} O nome do personagem ("" se não houver diálogo ou DialogManager não existir)
function get_current_character() {
    var dialog_manager = instance_find(DialogManager, 0);
    if (dialog_manager != noone) {
        return dialog_manager.dialog_character;
    }
    return "";
}

/// @function set_dialogue_style(x, y, width, height, bg_color, text_color, bg_alpha)
/// @description Personaliza a aparência da caixa de diálogo
/// @param {real} x - Posição X da caixa de diálogo
/// @param {real} y - Posição Y da caixa de diálogo
/// @param {real} width - Largura da caixa de diálogo
/// @param {real} height - Altura da caixa de diálogo
/// @param {real} bg_color - Cor do fundo (opcional)
/// @param {real} text_color - Cor do texto (opcional)
/// @param {real} bg_alpha - Alpha do fundo (opcional)
function set_dialogue_style(x, y, width, height, bg_color = c_black, text_color = c_white, bg_alpha = 0.8) {
    var dialog_manager = instance_find(DialogManager, 0);
    if (dialog_manager == noone) {
        // Cria DialogManager se não existir - usa a primeira layer disponível
        var layer_id = layer_get_id(layer_get_name(0));
        if (layer_id == -1) {
            // Se nenhuma layer existir, cria uma
            layer_id = layer_create(0, "DialogLayer");
        }
        dialog_manager = instance_create_layer(0, 0, layer_id, DialogManager);
    }
    
    with (dialog_manager) {
        dialog_x = x;
        dialog_y = y;
        dialog_width = width;
        dialog_height = height;
        dialog_bg_color = bg_color;
        dialog_color = text_color;
        dialog_bg_alpha = bg_alpha;
    }
}