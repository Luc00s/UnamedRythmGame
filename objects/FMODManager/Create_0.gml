var _max_channels = 1024
var _flags_core = FMOD_INIT.NORMAL;
var _flags_studio = FMOD_STUDIO_INIT.LIVEUPDATE;

emotion = 0;
should_speak = 0;
character = "";


fmod_studio_system_create();
show_debug_message("fmod_studio_system_create: " + string(fmod_last_result()));
fmod_studio_system_init(_max_channels, _flags_studio, _flags_core);
show_debug_message("fmod_studio_system_init: " + string(fmod_last_result()));
fmod_main_system = fmod_studio_system_get_core_system();

bank_ref = fmod_studio_system_load_bank_file(fmod_path_bundle("Master.bank"), FMOD_STUDIO_LOAD_BANK.NORMAL);
strings_bank_ref = fmod_studio_system_load_bank_file(fmod_path_bundle("Master.strings.bank"), FMOD_STUDIO_LOAD_BANK.NORMAL);
bank_ref_sfx = fmod_studio_system_load_bank_file(fmod_path_bundle("SFX.bank"), FMOD_STUDIO_LOAD_BANK.NORMAL);
bank_ref_music = fmod_studio_system_load_bank_file(fmod_path_bundle("OST.bank"), FMOD_STUDIO_LOAD_BANK.NORMAL);

// CHARACTERS
event_description_ref = fmod_studio_system_get_event("event:/voices/violet/violet");
violet = fmod_studio_event_description_create_instance(event_description_ref);
fmod_studio_event_instance_start(violet);

// HOW TO USE:

// CHANGE EMOTION = fmod_studio_event_instance_set_parameter_by_name(event_description_instance_ref, "EMOTION", 1);
// 1 = question
// ...

// TOGGLE SPEECH = fmod_studio_event_instance_set_parameter_by_name(event_description_instance_ref, "SHOULD_SPEAK", 1); (1 or 0)


start_fmod_dialogue = function (text, emotion, character){
	
	switch(character){
		case "violet":
			current_ref = violet
	}
	
	fmod_studio_event_instance_set_parameter_by_name(current_ref, "EMOTION", emotion);
	fmod_studio_event_instance_set_parameter_by_name(current_ref, "SHOULD_SPEAK", 1);
}

interrupt_speech = function (){
	fmod_studio_event_instance_set_parameter_by_name(current_ref, "SHOULD_SPEAK", 0);
}

resume_speech = function (){
	fmod_studio_event_instance_set_parameter_by_name(current_ref, "SHOULD_SPEAK", 1);
}