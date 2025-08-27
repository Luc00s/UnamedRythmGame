// Sistema de Diálogo - Exemplos de Uso
// Essas são funções exemplo mostrando como usar o sistema de diálogo

/// @function example_basic_dialogue()
/// @description Mostra um exemplo básico de diálogo
function example_basic_dialogue() {
    start_dialogue("Hello! This is a basic dialogue example.");
}

/// @function example_fast_dialogue()
/// @description Mostra diálogo com velocidade de digitação mais rápida
function example_fast_dialogue() {
    start_dialogue("Este texto digita mais rápido!", 1.0); // 1.0 caracteres por step
}

/// @function example_slow_dialogue()
/// @description Mostra diálogo com velocidade de digitação mais lenta
function example_slow_dialogue() {
    start_dialogue("Este... texto... digita... devagar...", 0.2); // 0.2 caracteres por step
}

/// @function example_question_dialogue()
/// @description Mostra diálogo com emoção de pergunta
function example_question_dialogue() {
    start_dialogue("Você está pronto para começar?", 0.5, 30, 1); // emotion = 1 (pergunta)
}

/// @function example_character_dialogue()
/// @description Mostra diálogo com diferentes personagens falando
function example_character_dialogue() {
    start_dialogue("Olá, eu sou a Violet!", 0.5, 30, 0, "violet"); // character = "violet"
    // Mais tarde no seu código, você poderia ter:
    // start_dialogue("E eu sou outro personagem!", 0.5, 30, 0, "outro"); // character = "outro"
}

/// @function example_punctuation_dialogue()
/// @description Mostra diálogo com pausas de pontuação personalizadas
function example_punctuation_dialogue() {
    start_dialogue("Este texto pausa mais na pontuação! Viu? Está funcionando.", 0.5, 60); // 60 steps de pausa
}

/// @function example_custom_style()
/// @description Mostra como personalizar a aparência da caixa de diálogo
function example_custom_style() {
    // Define estilo personalizado da caixa de diálogo (centralizada, caixa menor)
    set_dialogue_style(room_width/2 - 200, room_height/2 - 50, 400, 100, c_blue, c_yellow, 0.9);
    start_dialogue("Este diálogo tem um estilo personalizado!");
}

/// @function example_fmod_dialogue()
/// @description Mostra como usar o sistema FMOD com diferentes personagens e emoções
function example_fmod_dialogue() {
    // Violet falando com emoção neutra
    start_dialogue("Olá! Sou a Violet e estou falando normalmente.", 0.5, 30, 0, "violet");
    
    // Violet fazendo uma pergunta (emoção 1)
    // start_dialogue("Você consegue ouvir a diferença na minha voz?", 0.5, 30, 1, "violet");
    
    // Outro personagem (precisa ter o evento FMOD configurado)
    // start_dialogue("E eu sou outro personagem com voz diferente!", 0.5, 30, 0, "outro_personagem");
}