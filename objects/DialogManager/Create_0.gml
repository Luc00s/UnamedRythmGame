// Gerenciador de Diálogo - Evento Create
// Inicializa as variáveis do sistema de diálogo digitado

// Estado do diálogo
dialog_active = false;
dialog_text = "";
dialog_current_text = "";
dialog_position = 0;
dialog_finished = false;

// Configurações de digitação
dialog_speed = 0.5; // Caracteres por step (ajustável)
dialog_speed_counter = 0;

// Configurações de pausa na pontuação
dialog_punctuation_pause_time = 30; // Steps para pausar na pontuação (ajustável)
dialog_punctuation_counter = 0;
dialog_paused_at_punctuation = false;

// Sistema de emoção
dialog_emotion = 0; // Emoção atual (0 = nenhuma, 1 = pergunta)

// Sistema de personagem
dialog_character = ""; // Personagem atual falando (padrão: vazio)

// Sistema FMOD
event_description_ref = -1;
event_description_instance_ref = -1;
fmod_initialized = false;

// Aparência da caixa de diálogo
dialog_x = 50;
dialog_y = room_height - 70;
dialog_width = room_width - 100;
dialog_height = 65;
dialog_margin = 20;

// Renderização do texto
dialog_font = fn1; // Fonte padrão, pode ser alterada
dialog_color = c_white;
dialog_bg_color = c_black;
dialog_bg_alpha = 0.8;

// Sinais de pontuação que acionam pausas
punctuation_marks = [".", "!", "?", ",", ":", ";"];