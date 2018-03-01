// Initialization of Busses & Samples


Server.local.options.sampleRate= 48000;
Server.local.options.memSize= 65536;
Server.local.latency= 0.05; //make bigger if recieving "late" warnings

Server.default.options.numOutputBusChannels = 8;
Server.default.options.numInputBusChannels = 8;
Server.default.options.numOutputBusChannels

---

// Path Directory

[
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/ellen reverb.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/ellen w: synth.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/ellen.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/ellen1.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/noise.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/st.rhondi.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/st.rhondi bass.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/st.rhondi reverb.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/st.rhondi w: synth.wav"
]

---

// Little Deer

(

t = TempoClock(87.9/60);

// synth, buffer, & piece variables
var ellen, noise, strhondi, bass, synthMel, oohs, waves, walking, forest, birds, breath, wind, crickets, littleDeer;

// sequence variables
var a, b, c , d, b1, b2, b3, b4, d1, d2, d3, d4, d5, d6, littleDeer;

// time variables
var bassTime, synthTime, oohsTime1, oohsTime2, birdsTime, breathTime1, breathTime2, cricketsTime, forestTime, windTime, bTime, cTime, dTime;

// reading buffers
(
ellen = Buffer.alloc(s, 120*48000, 1, bufnum: 1);
ellen = Buffer.read(s, "/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/ellen.wav",, bufnum: 1);

noise = Buffer.alloc(s, 120*48000, 1, bufnum: 2);
noise = Buffer.read(s, "/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/noise.wav",bufnum: 2);

strhondi = Buffer.alloc(s, 120*48000, 1, bufnum: 3);
strhondi = Buffer.read(s, "/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/st.rhondi.wav", bufnum: 3);
)

// synthdefs
(
SynthDef(\bass{}).send;

SynthDef(\synthMel{}).send;

SynthDef(\oohs{}).send;

SynthDef(\waves,{}).send;

SynthDef(\walking, {}).send;

SynthDef(\forest{}).send;

SynthDef(\birds{}).send;

SynthDef(\wind{}).send;

SynthDef(\crickets{}).send;

SynthDef(\eff1,{}).send;

SynthDef(\eff2,{}).send;

SynthDef(\eff3,{}).send;

SynthDef(\eff4,{}).send;
)

// effects
(
~synthGroup = Group.basicNew(s, 1);
~effects = Group.after(~synthGroup);
b = Bus.audio(s,2);

~effBus = (
	eff1: Bus.audio(s,1), eff2: Bus.audio(s,1), eff3: Bus.audio(s,1), eff4: Bus.audio(s,1),
	masterdyn: Bus.audio(s,1), masterrvb: Bus.audio(s,1)
          )
)

// patterns
(
a = Ppar([Pbind(\waves), Pbind(\walking)]);

b1 = Pbind(\bass);
b2 = Pbind(\synthMel);
b3 = Pbind(\oohs);
b4 = Pbind(\oohs);
b = Ptpar([bassTime, b1, synthTime, b2, oohsTime1, b3, oohsTime2, b4]);

c = Pbind(\voices); // Pstutter, Prand, Pxrand

d1 = Pbind(\birds);
d2 = Pbind(\breath);
d3 = Pbind(\crickets);
d4 = Pbind(\forest);
d5 = Pbind(\wind);
d6 = Pbind(\breath);
d  = Ptpar([birdsTime, d1, breathTime1, d2, cricketsTime, d3, forestTime, d4, windTime, d5, breathTime2, d6]);

littleDeer = Ptpar([0, a, bTime, b, cTime, c, dTime, d]);
littleDeer.play(t);
)

)
