
// Nodes and Buses

Busses

// To create networks of Synths that interact on the Server, we must understand how Nodes write-to and/or read from Buses. The Server application has 128 buses by default - these can be thought of as mixer busses on which any audio signal can write to and be automatically mixed (added) with any other signals writing to the same bus.

Hardware Busses
// However, the inputs and outputs for your hardware interface always reserve the first contiguous sets of these.  The number of these output and input hardware busses default to 8 of each.  But you can change how many ins and outs your machine has in the ServerOptions class:

// these are the default settings
Server.default.options.numOutputBusChannels // Server.default.options returns a ServerOptions
Server.default.options.numOutputBusChannels = 8;  // set these as per your hardware
Server.default.options.numInputBusChannels = 8;

// ServerOptions also contains settings for other important digital sound parameters.  You must modify any of these before starting a Server, then restart, otherwise they will have no effect.

Server.local.options.sampleRate= 96000;  // default is 44100
 buffer of sound
Server.local.options.memSize= 65536;  // size of server memory, default is 8192

//  Server latency is a Server instance variable
Server.local.latency= 0.05;  // some latency delay is required to precompute each block of audio data -- the default is 0.2 (which is quite a lot,  more than normally required!!)  -- you can set this experimentally lower and when you start receiving "late" warnings, increase the latency

//In.ar gets audio from any specified Bus.  To get the hardware's first audio input, route the first input Bus to the left channel

{Out.ar(0,In.ar(8,1))}.play  // world's most expensive patchcord -- watch out for feedback!!

Audio Busses

// Synths can send audio signals to each other via a single global array of audio buses. Using buses rather than connecting synths to each other directly allows synths to connect themselves to the community of other synths without having to know anything about them specifically.

Control Busses

// Synths can send control signals to each other via a single global array of control buses. Buses are indexed by integers beginning with zero.

Nodes

// A Node means either a Synth or a Group.  A Group is a collection of Nodes represented as an ordered list.  A new Node may be added to the head or tail of the group.  The Nodes within a Group may be controlled together.  These may be both Synths and other Groups.  At startup there is a top level group with an ID of zero that defines the root of the tree.  A Server booted by SCLang will also have a 'default group' with an ID of 1 which is the default target for all new Nodes.

// You can see graph of the Synths and Groups that are running  by selecting  "Dump Node Tree"  from the Server menu (or type command-T).

// If the Out UGen is the first one to touch a bus in a cycle, then it overwrites the contents.  An 'In' UGen that reads from a bus that has not been written to in a buffer write cycle reads silence.  Each subsequent Out ugen mixes to the bus.  If Out ugens were to always mix to the bus, then there the previous cycle's data would never get cleared.

// So, when the Server calculates the audio output of each node, it must do so in context of all the nodes in the graph, by rendering them all in the specified order. The order it does so is referred to as execution order. The inputs of some Synths may depend on calculating some other Synth first: for example, a reverb unit needs its input calculated first, otherwise it can have no input.

(
// a stereo reverb-delay and a stereo impulse generator
SynthDef("reverb",{Out.ar(0,CombN.ar(In.ar(0,2),0.1,0.1,4))}).add;
SynthDef("impulses",{Out.ar(0,Impulse.ar([0.9,1.19],0,0.3))}).a;
)

// first listen to this:
(
Synth("impulses");
Synth("reverb");
)
// Select "Dump Node Tree" from the Server menu to see these Synths and their nodeIDs and Group assignments--  Next, after a command-period, try this:
(
Synth("reverb");
Synth("impulses");
)
// in the first example, the reverb executes before the impulses, and in the second, the order is reversed, so that the reverb has some sound to process!  You can ensure the same result by using the appropriate 'before' or 'after' method to set the desired relationship between the synths Synths:

(
~rvb = Synth("reverb");  // we need to keep track of the node with variable
Synth.before(~rvb,"impulses");
)
// or
(
~synth = Synth("impulses");
Synth.after(~synth,"reverb");  // we need to keep track of the node with variable
)

// Another fix would use the InFeedback UGen, which takes the old value from the bus before this calculation cycle, allowing you to set up feedback cycles, and also circumvent execution order issues like this.  But in more complex cases, you should specify the desired order for the node graph on the Server, by specifying where to put each Synth in the Node tree. You can put new Nodes after or before other Nodes, and at the head or tail of Groups

// here's a rewrite of the above with the same desired outcome
(
g=Group.basicNew(s,1);  // basicNew is safer than new, avoiding possible timing problems
Synth.tail(g, "reverb");
Synth.head(g,"impulses");
)

//or this, because it doesn't matter what order the code is executed  now
(
g=Group.basicNew(s,1);
Synth.head(g,"impulses");
Synth.tail(g,"reverb");
)

// You should have noted by now that all Synths get a number (starting from 1000) and all Groups get a number (starting from 0). The maximum number of Nodes you can have in your graph is set in ServerOptions and defaults to 1024.  For more on the structure, see this helpfile:

[Server-Architecture]
/*from that helpfile:
Audio Buses

Synths send audio signals to each other via a single global array of audio buses. Audio buses are indexed by integers beginning with zero. Using buses rather than connecting synths to each other directly allows synths to connect themselves to the community of other synths without having to know anything about them specifically. The lowest numbered buses get written to the audio hardware outputs. Immediately following the output buses are the input buses, read from the audio hardware inputs. The number of bus channels defined as inputs and outputs do not have to match that of the hardware.

Control Buses

Synths can send control signals to each other via a single global array of control buses. Buses are indexed by integers beginning with zero.
*/

// Here's an example which can demonstrate the value of having control over the order of nodes in a network.  Let's set up a a group of Synths that can be dynamically patched to effects that are in another group

// an effects send network
( // effects SynthDefs+src SynthDef
// each effect Synthdef has an 'inBus' argument, like its effect-send channel, read in by 'In.ar(inBus)'
SynthDef(\rvb,{ arg inBus=16,size=1,damp=0.2,amp=1;
	Out.ar(0,FreeVerb.ar(In.ar(inBus,1),1,size,damp,amp).dup)
}).store;

SynthDef(\rngFlt,{ arg inBus=16,freq=440,decay=0.05,amp=0.25;
	Out.ar(0,Ringz.ar(In.ar(inBus,1),freq,decay,amp).dup);
}).store;

SynthDef(\combDelay,{ arg inBus=16,delay=0.5,decay=4,amp=1;
	Out.ar(0,CombN.ar(In.ar(inBus,1),1.0,delay,decay).dup,amp)
}).store;

SynthDef(\pshift,{ arg inBus=16,wsize=0.2,pRtio=0.5,pDsp=0,tDsp=0.01,amp=1;
	Out.ar(0,PitchShift.ar(In.ar(inBus,1),wsize,pRtio,pDsp,tDsp,amp).dup);
}).store;

// source SynthDefs have an 'effBus' argument, specifying an effect send Bus number
//  an 'effAmp' arg sets the level of the effect send
SynthDef(\effSend_src,{ arg freq=440,range=0.1,spd=5,amp=0.1,effBus=16,effAmp=1;
	var frqRange=freq*range;
	var src=Saw.ar(freq+LFNoise0.kr(spd,frqRange));
	Out.ar(effBus,src*effAmp);
	Out.ar(0,(src*amp).dup);
}).store;
)
(  // this is an intialization block that will need to be compiled again to change effects
~effGroup = Group.tail(1);  // create a Group for effects
// the parenthesis enclosure below creates an Event, a kind of Dictionary that provides a list of  pairs of keys(symbols) associated with things, in this case audio Buses
~effBus = (rvb: Bus.audio(s,1), flt: Bus.audio(s,1), delay: Bus.audio(s,1), pshift:Bus.audio(s,1)  );
// the next Event stores references to the effect Synths
if(~effects.notNil,{~effects.keysValuesDo {|k,v| v.free }; });
~effects = (
	rvb: Synth(\rvb,[\inBus,~effBus[\rvb]],~effGroup),   //  syntax  ' key:  value,' creates the association
	flt: Synth(\rngFlt,[\inBus,~effBus[\flt]],~effGroup),
	delay: Synth(\combDelay,[\inBus,~effBus[\delay]],~effGroup),
	pshift: Synth(\pshift,[\inBus,~effBus[\pshift]],~effGroup)
);
)
x = Synth.before(~effGroup,\effSend_src,[\effBus,~effBus[\rvb],\effAmp,0.2]);
// "Dump Node Tree with Controls" command in the Server menu will print out all currently running Synths with all current values of  their arguments -- the order listed from top to bottom is the execution order of each Synth, so you can confirm that the source synth is executing before the signal processing Synths -- you can also confirm that the effect send bus of the source synth matches the effect in Bus of the processor

~effects[\rvb].set(\amp,0.5)  // change arg values of both the effect and src with 'set'
x.set(\freq,100);
x.set(\amp,0)  // no normal sound, only effect (the effect-send is pre-fader
x.set(\spd,10);
x.set(\effBus,~effBus[\flt]);
~effects[\flt].set(\freq,880)
x.set(\effBus,~effBus[\delay]);
~effects[\delay].set(\delay,0.25)
x.set(\effBus,~effBus[\pshift])
~effects[\pshift].set(\pRtio,2.5)
x.set(\effBus,~effBus[\rvb])
x.free;   // release the source-synth

// instead of switching, the next variation of the effSend_src SynthDef allows sending to multiple effect bus sends
(
SynthDef(\effSend_src,{ arg effBus=16,eff1Amp=0,eff2Amp=0,eff3Amp=0,eff4Amp=0,
	freq=440,range=0.1,spd=5,amp=0.1;
	var frqRange=freq*range;
	var src=Saw.ar(freq+LFNoise0.kr(spd,frqRange));
	Out.ar(effBus,
		[src*eff1Amp,src*eff2Amp,src*eff3Amp,src*eff4Amp]); // write to four effect Buses
	Out.ar(0,(src*amp).dup);  // unprocessed output
}).store;
)
x = Synth.before(~effGroup,\effSend_src,[\effBus,~effBus[\rvb],\eff1Amp,0.2]);

// now you can send the source sound to any combination of effects
x.set(\eff1Amp,0.1)
x.set(\eff2Amp,0.2)
x.set(\eff3Amp,0.2)
x.set(\eff4Amp,0.5)

// or you can send combinations of levels this way
x.setn(1,[0,0,0,0]);   // the first argument value sets the index of the first arg to be set, then the rest of the values in the list set the next 3 arguments

( //  here is an interface to use gui sliders for continuous control
f = FlowView.new(windowTitle: "effect Sends");
EZSlider(f,250@20,"rvb",action: {|sl| x.set(\eff1Amp,sl.value) });
EZSlider(f,250@20,"flt",action: {|sl| x.set(\eff2Amp,sl.value) });
EZSlider(f,250@20,"dly",action: {|sl| x.set(\eff3Amp,sl.value) });
EZSlider(f,250@20,"shift",action: {|sl| x.set(\eff4Amp,sl.value) });
f.startRow;
EZSlider(f,250@20,"freq",\freq.asSpec,action: {|sl| x.set(\freq,sl.value) });
EZSlider(f,250@20,"dry-amp",action: {|sl| x.set(\amp,sl.value) });
)

// you can examine the current value of an arg using 'get'
x.get(\effBus,{|bus| bus.postln })
// or use "Dump Node Tree with Controls" command in the Server menu to see all argument values
// if you want to see the signals running on the effects busses ....
s.scope(4,~effBus[\rvb].index);

( //  turn off effects andeffSend_src, then free the effects Buses so they can be reused
~effects.keysValuesDo ({|name,synth| synth.free });
x.free;
~effBus.do ({|bus| bus.free });
)


/* ASSIGNMENT #3

Make your own collections of signal processing effects  using UGens found by browsing through the following types of UGens found in the Help browser/Browse/UGens:

Filters
Delays
Dynamics
FFT
Reverbs
Convolution
Pitch, FreqShift

....  and then adapt your SynthDef library from Assgn#2 to use them with your effects in a Patterns piece -
*/

(
SynthDef(\saw_src,{ arg effBus=16,eff1Amp=0,eff2Amp=0,eff3Amp=0,eff4Amp=0,
	freq=440,range=0.1,spd=5,amp=0.1,dur=1,gate=1;
	// it's important to use a 'gate', which turns off the Synth after a note is played by the pattern -- and make it be the last of the arguments you declare, because this also marks the end of arguments that are addressable by Patterns
	var env = EnvGen.ar(Env.new([0,1,1,0],[0.02,0.2,dur-0.22]),gate,doneAction:2);  // 'gate' must follow the Env -- don't use '1' here, or the synth won't turn off!
	var src=Saw.ar(
		LFNoise0.kr(spd,(freq-(freq*range).abs),freq),
		env);
	Out.ar(effBus,[src*eff1Amp,src*eff2Amp,src*eff3Amp,src*eff4Amp]); // sends to up to four contiguous effect Busses
	Out.ar(0,(src*amp).dup);  // unprocessed output
}).store;
)
// Re-intialize the effects Busses if needed because you 'free'd them ain the code above, or if you're restarting from scratch -- then  use Pmono to start and changing change arguments for the effects.  Pmono will start the synth whose name is its first argument, and it stays playing until the end of the Pattern, when it turns it off.  This means that you don't need to start or save the Synths using the ~effects code as before for non-Pattern playing.  But you need to be sure  that the effect synth is assigned to the ~effGroup , and the synths that play into it are assigned to Group 1, thus ensuring that they always run before the effects synths do. Here's a template example:

( // re-initialize the Group and audio Busses
~effGroup = Group.tail(1);
// change names of each Bus to match your effect Synth
~effBus = (rvb: Bus.audio(s,1), flt: Bus.audio(s,1), delay: Bus.audio(s,1), pshift:Bus.audio(s,1)  );
)
(
Pdef(\effPat,
	Ppar([
		Pbind(\instrument,\saw_src,
			\group,1,
			\amp, 10.5,
			\effBus, ~effBus[\rvb].index,  // point to the first of four Busses
			\freq, Pseq([200,400,300,200,400,600],inf),
			\range,127/128,
			\spd,5,
			\amp, 0.5,
			// effAmp2 changes volume on effect send to 'flt'
			\eff2Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.2,inf),
			\pitchdecay, 0.001,
			// effAmp3 changes volume on effect send to 'delay'
			\eff3Amp, Pseq([0.5,0,1,0,0.5,0,0.5,0],inf),
			\legato,0.125,
			\dur, Prand([0.33,0.66,1.0,0.33],inf)
		),
		Pmono(\combDelay,
			\group,~effGroup,
			\inBus, ~effBus[\delay].index, // point to the effect 'delay'
			\amp, 1,
			\time, 1,
			\decay, 4,
			\delay,Prand([0.5,0.25,0.125,0.375],inf),
			\decay,4,
			\dur,2
		),
		Pmono(\rngFlt,
			\group,~effGroup,
			\inBus, ~effBus[\flt].index, // point to the effect 'delay'
			\freq,Pwhite(880,1760),
			\decay,0.02,
			\amp,0.5,
			\dur,4
		)
]));
)
Pdef(\effPat).play
Pdef(\effPat).stop

