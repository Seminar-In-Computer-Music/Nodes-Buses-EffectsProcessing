(
s.boot;
Server.local.scope(2);
)
//effectsynthdefs
(
SynthDef(\decimator,{|inBus=16,rate=0,bits=0,amp=1|
	Out.ar(0,Pan2.ar(Decimator.ar(In.ar(inBus,1),TRand.kr(0.0, 44100, PinkNoise.kr), TRand.kr(0.0, 24.0, Crackle.kr(2.1)), amp), 0))
}).store;
SynthDef(\glitch,{|inBus=16,freq=0,rq=0,amp=1|
	Out.ar(0,Pan2.ar(Limiter.ar(GlitchRHPF.ar(In.ar(inBus,1),TRand.kr(0, 10, Crackle.kr(0.9)), Logistic.kr(3.85, 5, 0.15, 10.0), amp), 0.1, 0.01), 0))
}).store;
SynthDef(\verb,{|inBus=16,mix=0,room=0,damp=0,amp=1|
	Out.ar(0,Pan2.ar(FreeVerb.ar(In.ar(inBus,1), TRand.kr(0.0, 1.0, Crackle.kr(1.5)), Dust.kr(15), ClipNoise.kr(0.5), amp), 0))
}).store;
SynthDef(\comb,{|inBus=16,mdt=0,dt=0,decay=0,amp=1|
	Out.ar(0,Pan2.ar(CombC.ar(In.ar(inBus,1), TRand.kr(0.0, 1.0, Crackle.kr(1.5)), TRand.kr(0.0, 1.0, Dust2.kr(15)), Hasher.kr(GrayNoise.kr(0.5), 0.5), amp), 0))
}).store;
)
//effGroup/Bus
(
~effGroup = Group.tail(1);
~effBus = (decimator: Bus.audio(s,1), glitch: Bus.audio(s,1), verb: Bus.audio(s,1), comb:Bus.audio(s,1)  );
~effects = (
	decimator: Synth(\decimator,[\inBus,~effBus[\decimator]],~effGroup),
	glitch: Synth(\glitch,[\inBus,~effBus[\glitch]],~effGroup),
	verb: Synth(\verb,[\inBus,~effBus[\verb]],~effGroup),
	comb: Synth(\comb,[\inBus,~effBus[\comb]],~effGroup)
);
)
//Synthdefs
(
SynthDef(\synthy,{|effBus=16,eff1Amp=0,eff2Amp=0,eff3Amp=0,eff4Amp=0,
	range=0.1,spd=5,amp=1, dur=1|
    var ctls, mods, freq, env, src;
	env = Linen.kr(Impulse.kr(0), Rand(0.125, 5.5), Rand(0.5, Rand(1.5, 5.0)), Rand(0.125, 5.5), doneAction: Done.freeSelf);
    freq = Dust.kr(Rand(0.1, 25.0), 1.5, 0.5).exprange(20, 3100);
    ctls = [
        [freq, 0, 1],
        [freq, 0, 1],
        [Crackle.kr(0.5).exprange(3, 80), 0, 1],
		[GrayNoise.kr(SampleRate.ir/(Rand(0.01, 4.0))).exprange(3, 800), 0, 1],
        [Dust.kr(0.5).exprange(3, 800), 0, 1],
        [PinkNoise.kr(0.5).exprange(0.3, 10), 0, 1]
    ];
    mods = [
		{ LFNoise0.kr(SampleRate.ir/Rand(0.01, 10.0)).max(0) } ! 6 * LFNoise0.kr(0, 3),
        { LFNoise0.kr(SampleRate.ir/Rand(0.01, 10.0)).max(0) } ! 6 * GrayNoise.kr(0.5),
		{ LFNoise0.kr(SampleRate.ir/Rand(0.01, 10.0)).max(0) } ! 6 * LFNoise0.kr(SampleRate.ir/Rand(0.01, 4.0), 1.5, 0.5),
		{ LFNoise1.kr(Rand(0.01, 0.5)).max(0) } ! 6 * Dust.kr(Rand(0.1, 25.0), 1.5, 0.5),
		{ LFNoise1.kr(Rand(0.01, 0.5)).max(0) } ! 6 * Crackle.kr(1.5),
        { LFNoise1.kr(Rand(0.01, 0.5)).max(0) } ! 6 * LFNoise2.kr(50, 3)
    ];
	src = Limiter.ar(GlitchRHPF.ar(Decimator.ar(FM7.ar(ctls, mods).slice([0, 1]) * -12.dbamp, Rand(0.0, 44100.0), Rand(0.1, 24.0), env), Rand(0.01, 10.0), Rand(0.0, 1.0), 0.125), 0.03, 0.01);
	Out.ar(effBus,[src*eff1Amp,src*eff2Amp,src*eff3Amp,src*eff4Amp]);
	Out.ar(0, src*amp);
}).store;
SynthDef(\dusty, { |effBus=16,eff1Amp=0,eff2Amp=0,eff3Amp=0,eff4Amp=0,
	range=0.1,spd=5,amp=0.125, dur=1|
	var env, d, u, s, t, src;
	env = Linen.kr(Impulse.kr(0), Rand(0.0, Rand(0.1, 10.3)), Rand(0.01, Rand(0.1, 10.3)), Rand(0.01, Rand(0.1, Rand(0.3, 10.3))), doneAction: Done.freeSelf);
	d = Dust.ar(Rand(0.1, 25.0), 1.5, 0.5);
	u = GbmanN.ar(LFNoise0.kr(Rand(1.0, 20000.0), 1, 0), Rand(0.0, 2.0), Rand(0.0, 2.0), 1, 0);
	s = SinOscFB.ar(LinLin.kr(d, 0.0, 1.0, 50.0, 10000.0), LinLin.kr(u, -1.0, 1.0, 0.0, 1.0), 0.5, 0.9);
	t = Ringz.ar(d, Rand(1000.0, 5000.0), Dust.kr(Rand(0.1, 25.0)), 0.25, 0);
	src = Spring.ar(t, s, 0.5);
	Out.ar(effBus,[src*eff1Amp,src*eff2Amp,src*eff3Amp,src*eff4Amp]);
	Out.ar(0, src*amp);
}).store;
SynthDef(\noise, { |effBus=16,eff1Amp=0,eff2Amp=0,eff3Amp=0,eff4Amp=0,
	range=0.1,spd=5,amp=1, dur=1|
	var f, sf, g, src, env;
	env = Linen.kr(Impulse.kr(0), Rand(0.0, Rand(0.03, 0.05)), Rand(0.01, Rand(0.03, 20.05)), Rand(0.01, Rand(0.03, 0.05)), doneAction: Done.freeSelf);
	f = LFNoise2.kr(SampleRate.ir/4, 1.5, 0.5);
	sf = CuspN.ar(SampleRate.ir/4, Rand(-3.0, 3.0), Rand(-3.0, 3.0), Rand(0.5, 1.5));
	g = Ball.kr(f, sf, 0, 0.01);
	g = g * 140 + 1000;
	src = SinOscFB.ar(sf, g, env, 0.9);
	Out.ar(effBus,[src*eff1Amp,src*eff2Amp,src*eff3Amp,src*eff4Amp]);
	Out.ar(0, src*amp);
}).store;
SynthDef(\hen, { |effBus=16,eff1Amp=0,eff2Amp=0,eff3Amp=0,eff4Amp=0,
	range=0.1,spd=5,amp=0.5, dur=1|
	var env, src, h, e, n;
	h = LFNoise2.kr(Crackle.kr(Dust2.kr(Rand(0, 5), 0.0), 0.2, 0.2));
	e = Spring.kr(h, Rand(0.1, 1.0), 0);
	n = GbmanL.ar(Rand(0, 20500), e, Rand(0, 5));
	env = Linen.kr(Impulse.kr(0), Rand(0.0, Rand(0.01, 0.03)), Rand(0.01, Rand(0.02, 0.04)), Rand(0.01, Rand(0.02, 0.04)), doneAction: Done.freeSelf);
	src = HenonL.ar(Rand(0, 20000), n, h, Dust2.ar(2, 1, 0.5), e, env);
	Out.ar(effBus,[src*eff1Amp,src*eff2Amp,src*eff3Amp,src*eff4Amp]);
	Out.ar(0, src*amp);
}).store;
)
//Ppars
(
a = Ppar([
    Pbind(\instrument,\synthy,
        \effBus,~effBus[\comb],
		\eff1Amp,Prand([0,0.25,0.5,0.75,1], inf),
        \eff2Amp,Prand([0,0.25,0.5,0.75,1], inf),
        \eff3Amp,Prand([0,0.25,0.5,0.75,1], inf),
        \eff4Amp,Prand([0,0.25,0.5,0.75,1], inf),
		\amp,Prand([0,0.25,0.5,0.75,1], inf),
		\dur,Pwhite(1.0, 10.0, inf),
		\tempo, Pbrown(0.25, 100.0, 0.1, inf),
		\stretch, Ppoisson(10.0, inf),
	),
    Pmono(\verb,
        \amp,Prand([0,0.25,0.5,0.75,1], inf),
		\dur,Ppoisson(100.0, inf)),
    Pmono(\decimator,
        \amp,Pwhite(0.0, 1.0, inf),
		\dur,Prand([0,0.25,0.5,0.75,1], inf)),
    Pmono(\glitch,
		\amp,Prand([0,0.25,0.5,0.75,1], inf),
		\dur,Pbrown(0.01, 100.0, 0.1, inf)), inf
]);
b = Ppar([
    Pbind(\instrument,\hen,
		\effBus, ~effBus[\decimator],
		\eff1Amp,Prand([0,0.25,0.5,0.75,1], inf),
        \eff2Amp,Prand([0,0.25,0.5,0.75,1], inf),
        \eff3Amp,Prand([0,0.25,0.5,0.75,1], inf),
        \eff4Amp,Prand([0,0.25,0.5,0.75,1], inf),
		\amp,Prand([0,0.25,0.5,0.75,1], inf),
		\dur, Pbeta(0.0, 1.0, 100.0, 1.0, inf),
		\tempo, Pbrown(0.25, 100.0, 0.1, inf),
		\stretch, Ppoisson(10.0, inf)
	),
    Pmono(\verb,
        \amp,Pbrown(0.125, 1.0, 0.1, inf),
		\dur,Ppoisson(100.0, inf)),
    Pmono(\comb,
		\amp,Pwhite(0.0, 1.0, inf),
		\dur,Pbrown(0.01, 100.0, 0.1, inf)),
    Pmono(\glitch,
		\amp,Pbeta(0.0, 1.0, 1.0, 1.0, inf),
		\dur,Prand([0,0.25,0.5,0.75,1], inf))
]);
c = Ppar([
    Pbind(\instrument,\dusty,
        \effBus,~effBus[\verb],
		\eff1Amp,Prand([0,0.25,0.5,0.75,1], inf),
        \eff2Amp,Prand([0,0.25,0.5,0.75,1], inf),
        \eff3Amp,Prand([0,0.25,0.5,0.75,1], inf),
        \eff4Amp,Prand([0,0.25,0.5,0.75,1], inf),
		\amp,Prand([0,0.25,0.5,0.075,0.1], inf),
		\dur,Pwhite(1.0, 10.0, inf),
		\tempo, Pbeta(0.0, 100.0, 1.0, 1.0, inf),
		\stretch, Pwhite(0.0, 10.0, inf)
	),
    Pmono(\comb,
        \amp,Prand([0,0.25,0.5,0.75,1], inf),
		\dur,Pbrown(0.01, 100.0, 0.1, inf)),
    Pmono(\decimator,
        \amp,Pwhite(0.0, 1.0, inf),
		\dur,Ppoisson(100.0, inf)),
    Pmono(\glitch,
		\amp,Prand([0,0.25,0.5,0.75,1], inf),
		\dur,Pbrown(0.01, 100.0, 0.1, inf))
]);
d = Ppar([
    Pbind(\instrument,\noise,
        \effBus,~effBus[\glitch],
		\eff1Amp,Prand([0,0.25,0.5,0.75,1.0], inf),
        \eff2Amp,Prand([0,0.125,0.25,0.275,0.1], inf),
        \eff3Amp,Prand([0,0.25,0.5,0.75,1.0], inf),
        \eff4Amp,Prand([0,0.25,0.5,0.75,1.0], inf),
		\amp,Prand([0,0.125,0.25,0.275,0.1], inf),
		\dur,Pwhite(1.0, 100.0, inf),
		\tempo, Pbrown(0.01, 100.0, 1.0, inf),
		\stretch, Pbeta(0.0, 10.0, 1.0, 1.0, inf)
	),
    Pmono(\verb,
        \dur, Pwhite(0.25, 100.0, inf),
		\amp,Pwhite(1.0, 1.0, inf)),
    Pmono(\decimator,
        \amp,Pbeta(0.0, 1.0, 1.0, 1.0, inf),
		\dur,Ppoisson(100.0, inf)),
	Pmono(\comb,
		\amp,Prand([0,0.25,0.5,0.75,1], inf),
		\dur,Pbrown(0.01, 100.0, 0.1, inf))
]);
)
a=a.play;
b=b.play;
c=c.play;
d=d.play;
a.stop;
b.stop;
c.stop;
d.stop;

( //  turn off effects andeffSend_src, then free the effects Buses so they can be reused
~effects.keysValuesDo ({|name,synth| synth.free });
x.free;
~effBus.do ({|bus| bus.free });
)

