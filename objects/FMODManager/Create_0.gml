var _max_channels = 1024
var _flags_core = FMOD_INIT.NORMAL;
var _flags_studio = FMOD_STUDIO_INIT.LIVEUPDATE;



show_debug_overlay(true);
fmod_studio_system_create();
	show_debug_message("fmod_studio_system_create: " + string(fmod_last_result()));

	fmod_studio_system_init(_max_channels, _flags_studio, _flags_core);
	show_debug_message("fmod_studio_system_init: " + string(fmod_last_result()));

	/*
		FMOD Studio will create an initialize an underlying core system to work with.
	*/
	fmod_main_system = fmod_studio_system_get_core_system();

bank_ref = fmod_studio_system_load_bank_file(fmod_path_bundle("Master.bank"), FMOD_STUDIO_LOAD_BANK.NORMAL);
strings_bank_ref = fmod_studio_system_load_bank_file(fmod_path_bundle("Master.strings.bank"), FMOD_STUDIO_LOAD_BANK.NORMAL);
event_description_ref = fmod_studio_system_get_event("event:/voices/violet/violet");
event_description_instance_ref = fmod_studio_event_description_create_instance(event_description_ref);
fmod_studio_event_instance_start(event_description_instance_ref);

// HOW TO USE:

// CHANGE EMOTION = fmod_studio_event_instance_set_parameter_by_name(event_description_instance_ref, "EMOTION", 1);
// 1 = question
// ...

// TOGGLE SPEECH = fmod_studio_event_instance_set_parameter_by_name(event_description_instance_ref, "SHOULD_SPEAK", 1); (1 or 0)

