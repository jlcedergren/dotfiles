/*
* startup.scd - SuperDirt setup
*
*/

s = Server.local;
s.reboot {
	// s.options.device = "ASIO : ASIO Fireface USB";
	s.options.sampleRate = 96000;
	s.options.numBuffers = 1024 * 256;    // increase this if you need to load more samples
	s.options.memSize = 8192 * 32;        // increase this if you get "alloc failed" messages
	s.options.numWireBufs = 128;          // increase this if you get "exceeded number of interconnect buffers" messages
	s.options.maxNodes = 1024 * 32;       // increase this if you are getting drop outs and the message "too many nodes"
	s.options.numOutputBusChannels = 2;   // set this to your hardware output channel size, if necessary
	s.options.numInputBusChannels = 2;    // set this to your hardware input channel size, if necessary
	s.volume = -6.0;
	s.waitForBoot {
		~dirt = SuperDirt(2, s);
		~dirt.loadSoundFiles;
		//Set path to your samples-extra files
		~dirt.loadSoundFiles("C:/Users/tadok/AppData/Local/SuperCollider/downloaded-quarks/samples-extra/*");
		~dirt.start(57120, 0!12);
		
		/*
		//MIDI setup
		MIDIClient.init;
		~midiOut = MIDIOut.newByName("loopMIDI Port", "loopMIDI Port");
		~dirt.soundLibrary.addMIDI(\midi, ~midiOut);
		*/
		
		/*
		//Ableton to Tidal
		~dirt.soundLibrary.addSynth(\play, (play: {
		~midiOut.control(3, 100, 127);
		}));
		~dirt.soundLibrary.addSynth(\stop, (play: {
		~midiOut.control(3, 101, 127);
		}));
		~dirt.soundLibrary.addSynth(\rec, (play: {
		~midiOut.control(3, 102, 127);
		}));
		*/
	};
};


a = NetAddr.new("localhost", 3333);
OSCdef(\tidalplay, {
	arg msg;
	a.sendMsg(*msg);
}, '/dirt/play', n);