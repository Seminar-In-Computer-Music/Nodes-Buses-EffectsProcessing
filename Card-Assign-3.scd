(
SynthDef(\waves,{
	arg freq = 60, rq = 1, pan = 0, amp = 0.5, legato, dur = 5, outBus = 0,
	effBus = 16, eff1Amp = 0, eff2Amp = 0, eff3Amp = 0, eff4Amp = 0, gate = 1;
	var sig, env, wave;
	sig = BPF.ar(BrownNoise.ar, freq, rq);
	env = EnvGen.kr(Env.adsr(1, 3, 0.1, 1, 0.2, [2, -3]), gate, doneAction: 2);
	wave = sig * env;
	Out.ar(effBus, [wave*eff1Amp, wave*eff2Amp, wave*eff3Amp, wave*eff4Amp]);
	Out.ar(outBus, wave);
}).send;

SynthDef(\walking, {
	arg freq = 60, dur = 0.2, amp = 0.01, outBus = 0, pan = 0,
	effBus = 16, eff1Amp = 0, eff2Amp = 0, eff3Amp = 0, eff4Amp = 0, gate = 1;
	var sig, env;
	env = EnvGen.kr(Env.perc(0.1, dur, 0.01), gate, doneAction: 2);
	sig = (BrownNoise.ar + SinOsc.ar(freq)) * env;
	Out.ar(effBus, [sig*eff1Amp, sig*eff2Amp, sig*eff3Amp, sig*eff4Amp]);
	Out.ar(outBus, sig)
}).send;

SynthDef(\birds, {                                                                          // need to finesse synth
	arg freq = 800, dur = 0.2, amp = 0.5, outBus = 0,
	effBus = 16, eff1Amp = 0, eff2Amp = 0, eff3Amp = 0, eff4Amp = 0, gate = 1;
	var sig, env, caw;
	sig = Saw.ar(freq)+Saw.ar(freq*0.5)+Saw.ar(freq*0.8);
	env = EnvGen.kr(Env.perc(0.01, 0.21, 0.8), gate, doneAction: 2);
	caw = (sig * SinOsc.ar(freq*3)) * env;
	Out.ar(effBus, [sig*eff1Amp, sig*eff2Amp, sig*eff3Amp, sig*eff4Amp]);
	Out.ar(outBus, caw)
}).send;

SynthDef(\normDelay,{ arg inBus = 16, maxdelay = 0.5, delay = 0.25, amp = 0.5;
	Out.ar(0, DelayN.ar(In.ar(inBus, 1), maxdelay, delay, amp).dup)
}).send;

SynthDef(\reVerb,{ arg inBus = 16, mix = 1, room = 0.3, damp = 0.5, amp = 0.5;
	Out.ar(0, FreeVerb.ar(In.ar(inBus, 1), mix, room, damp, amp).dup)
}).send;

SynthDef(\rbpFlt,{ arg inBus = 16, freq = 440, decay = 0.5, amp = 0.25;
	Out.ar(0, Ringz.ar(In.ar(inBus, 1), freq, decay, amp).dup);
}).send;

SynthDef(\combDelay,{ arg inBus = 16, delay = 0.5, decay = 4, amp = 1;
	Out.ar(0, CombN.ar(In.ar(inBus, 1), 1, delay, decay, amp).dup)
}).send;

)


(
~synthGroup = Group.basicNew(s, 1);
~effGroup = Group.after(~synthGroup);
// Bus.audio(s,2);

~effBus = (
	delay: Bus.audio(s,1), verb: Bus.audio(s,1), rbp: Bus.audio(s,1), comb: Bus.audio(s,1),
	masterdyn: Bus.audio(s,1), masterrvb: Bus.audio(s,1)
          );
)

/*

this works to set the busnum:

a = Synth(\waves)
a.set(\eff4Amp, 0.5)
Pmono(\combDelay).play

but the ppar/pmono isn't setting the path - why?
*/
(
a = Ppar([
	    Ppar([
	        Pbind(
			    \instrument, \waves,
			    \group, ~synthGroup,
			    \dur, Pwhite(4, 10, inf),
		        \amp, 0.5,
			    \legato, 0.9,
			    \pan, 0,                                             //how do I make a pan slide across the field? (ping pong)
			    \freq, Pwhite(20, 800, inf),
		        \effBus, ~effBus[\delay].index,
		        \eff4Amp, 0.75
		    ),
		    Pmono(
			    \combDelay,
			    \group, ~effGroup,
			    \inBus, ~effBus[\comb].index,
			    \delay, 0.5,
			    \decay, 6,
			    \amp, 0.5
	  	    ),
	    ]).play
	 	Ppar([
	        Pbind(
		        \instrument, \walking,
		        \delta, 0.5,    //Prand([2, 0.1, 0.5, 5, 8, 10, 0.2, 0.1, 3, 4, 5], inf)
			    \amp, 0.7,
			    \freq, Pwhite(60, 120, inf),
			    \pan, 0,
			    \dur, Pwhite(0.05, 1, inf),
		        \effBus, ~effBus[\delay].index,
		        \eff2Amp, 0.9
	        ),
			Pmono(                                                                               // why no worky?
			    \reVerb,
			    \group, ~effGroup,
			    \inBus, ~effBus[\verb].index,
			    \mix, 1,
			    \room, 0.8,
			    \damp, 0.1,
			    \amp, 0.9
		   ),
		]).play
]);

~ampseq = [0.4, 0.3, 0.2, 0.2, 0.1, 0.1, 0.07, 0.05];
~noteseq = [800, 700, 700, 700, 700, 500, 500, 500];
~d1 = Ppar([
	    Pbind(
		    \instrument, \caws,
		    \amp, Pseq(~ampseq, inf),
		    \freq, Pseq(~noteseq, inf),
		    \dur, 0.8,
	        \effBus, ~effBuss[\delay].index,
	        \eff3Amp, 0.5
	    ),
		Pmono(
			\rbpFlt
			\group, ~effGroup,
			\inBus, ~effBus[\rbp].index,
			\freq, Pwhite(60, 1000, inf),
			\decay, 0.5,
			\amp, 0.5
	    ),
]);
)

a.play
a.free
s.plotTree

~d1.play
~d1.free
