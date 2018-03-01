//SYNTHDEFS, BUFFERS AND CONTROLSPECS
(
ControlSpec.specs[\freq1]=[0.01,20000,\exp].asSpec;
ControlSpec.specs[\freq2]=[0.01,20000,\exp].asSpec;
ControlSpec.specs[\vol1]=[0,1,\lin].asSpec;
ControlSpec.specs[\vol2]=[0,1,\lin].asSpec;
ControlSpec.specs[\fltr1]=[0.01,20000,\exp].asSpec;
ControlSpec.specs[\fltr2]=[0.01,20000,\exp].asSpec;
ControlSpec.specs[\pitchdecay]=[0.001,10,\exp].asSpec;
ControlSpec.specs[\voldecay]=[0.001,10,\exp].asSpec;
ControlSpec.specs[\fltrdecay]=[0.001,10,\exp].asSpec;
ControlSpec.specs[\q]=[0.001,5,\lin].asSpec;
ControlSpec.specs[\pan]=[-1,1,\lin].asSpec;
ControlSpec.specs[\trem]=[0,1000,\lin].asSpec;
ControlSpec.specs[\mfreq1]=[0.01,20000,\exp].asSpec;
ControlSpec.specs[\mfreq2]=[0.01,20000,\exp].asSpec;
ControlSpec.specs[\mfreqdecay]=[0.001,10,\exp].asSpec;
ControlSpec.specs[\cfreq1]=[0.01,20000,\exp].asSpec;
ControlSpec.specs[\cfreq2]=[0.01,20000,\exp].asSpec;
ControlSpec.specs[\cfreqdecay]=[0.001,10,\exp].asSpec;
ControlSpec.specs[\tfreq1]=[0,20000,\exp].asSpec;
ControlSpec.specs[\tfreq2]=[0,20000,\exp].asSpec;
ControlSpec.specs[\tfreqdecay]=[0,10,\exp].asSpec;
ControlSpec.specs[\pfreq1]=[0,20000,\exp].asSpec;
ControlSpec.specs[\pfreq2]=[0,20000,\exp].asSpec;
ControlSpec.specs[\pfreqdecay]=[0.001,10,\exp].asSpec;
ControlSpec.specs[\lfo]=[0,20000,\exp].asSpec;
ControlSpec.specs[\lfoamount]=[0,100,\lin].asSpec;
ControlSpec.specs[\amp]=[0,1,\lin].asSpec;
ControlSpec.specs[\multi]=[0,10,\lin].asSpec;
ControlSpec.specs[\effBus1]=[0,128,\lin].asSpec;
ControlSpec.specs[\effBus2]=[0,128,\lin].asSpec;
ControlSpec.specs[\effBus3]=[0,128,\lin].asSpec;
ControlSpec.specs[\effBus4]=[0,128,\lin].asSpec;
ControlSpec.specs[\effAmp1]=[0,1,\lin].asSpec;
ControlSpec.specs[\effAmp2]=[0,1,\lin].asSpec;
ControlSpec.specs[\effAmp3]=[0,1,\lin].asSpec;
ControlSpec.specs[\effAmp4]=[0,1,\lin].asSpec;

Buffer.read(s,"sounds/a11wlk01.wav",bufnum:5);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/RUBBERBABY.wav",bufnum:0);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/A.wav",bufnum:1);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/E.wav",bufnum:2);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/O.wav",bufnum:3);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/LBULPGBU.wav",bufnum:4);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Snr1.wav",bufnum:6);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Snr2.wav",bufnum:7);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Snr3.wav",bufnum:8);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Snr4.wav",bufnum:9);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Snr5.wav",bufnum:10);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Kik1.wav",bufnum:11);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/RingHit2.wav",bufnum:12);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/RingHit1.wav",bufnum:13);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Perc3.wav",bufnum:14);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Perc2.wav",bufnum:15);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Perc1.wav",bufnum:16);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/KickSnr.wav",bufnum:17);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/HH.wav",bufnum:18);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/HH1.wav",bufnum:19);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/HH2.wav",bufnum:20);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/HH3.wav",bufnum:21);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Kik2.wav",bufnum:22);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Kik3.wav",bufnum:23);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Perc4.wav",bufnum:24);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Perc5.wav",bufnum:25);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Perc6.wav",bufnum:26);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Perc7.wav",bufnum:27);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/PETER.wav",bufnum:28);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Snr6.wav",bufnum:29);
Buffer.read(s,"C:/Users/amina/Desktop/SuperCollider/SC Samples/Snr7.wav",bufnum:30);

//Reverb with Compressor and HPF
(
SynthDef(\reverb,{|inBus=4,size=10,damp=0.2,decay=15,thresh=0.4,ratio=10,cutoff=7000,amp=1|
	var input;
	input=RHPF.ar(GVerb.ar(In.ar(inBus,2),size,decay,damping:damp,spread:25),cutoff,1);
	    Out.ar([0,1],Compander.ar(input,input,thresh,1,1/ratio))
}).store
);


//Simple Delay
(
SynthDef(\delay,{|inBus=5,time=0.2,decay=3,amp=1|
	    Out.ar(0,Pan2.ar(CombN.ar(In.ar(inBus,1),10,time,decay,amp),0))
}).store
);


//Pitch Shift Delay
(
SynthDef(\pdelay,{|inBus=6,delaytime=0.2,decay=3,amp=1,grain=3,ratio=2,rand=3,pitchtime=0|
	var pitchdelay;
	pitchdelay=PitchShift.ar(CombN.ar(In.ar(inBus,1),10,delaytime,decay),grain,ratio,rand,pitchtime);
	    Out.ar(0,amp*Pan2.ar(pitchdelay,0));
}).store
);

//Reverb with Sidechain Compression
(
SynthDef(\reverbsc,{|inBus=7,sideChainBus=8,size=10,damp=0.2,decay=15,thresh=0.4,cattack=0.01,crelease=0.1,freq=5000,ratio=10,spread=15,q=1,amp=1|
	var input,sidechain;
	sidechain=In.ar(sideChainBus);
	input=RHPF.ar(GVerb.ar(In.ar(inBus,2),size,decay,damping:damp,spread:spread),freq,q);
	    Out.ar([0,1],Compander.ar(input,sidechain,thresh,1,1/ratio,cattack,crelease))
}).store
);


//Kick
(
SynthDef(\kick,{|freq1=12000,amp=1,freq2=50,vol1=1,vol2=0,pitchdecay=0.001,voldecay=0.8,pan=0,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var env1, env2, input;
	env1=Env.new([0,freq1,freq2],[0,pitchdecay]);
	env2=Env.new([0,vol1,vol2],[0,voldecay]);
	input=Pan2.ar(0.6*SinOsc.ar(EnvGen.kr(env1,gate))*EnvGen.kr(env2,gate,doneAction:2),pan);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(0,amp*input)
}).store;
);


//Pads/Bass
(
SynthDef(\bassline,{|freq1=400,freq2=400,vol1=1,vol2=0,fltr1=100,fltr2=8000,fltrdecay=2,pitchdecay=4,q=3,voldecay=1,trem=0,lfo=0,pan=0,amp=1,lfoamount=10,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var env1,env2,env3,panvar,lfovar,input;
	env1=Env.new([0,freq1,freq2],[0,pitchdecay]);
	env2=Env.new([0,vol1,vol2],[0,voldecay]);
	env3=Env.new([0,fltr1,fltr2],[0,fltrdecay]);
	lfovar=SinOsc.kr(lfo,mul:lfoamount);
	panvar=pan + SinOsc.kr(trem);
	input=BPF.ar(Pan2.ar(SinOsc.ar(EnvGen.kr(env1,gate)+lfovar) + 0.9*Pulse.ar(EnvGen.kr(env1,gate)+lfovar) + 0.9*Saw.ar(EnvGen.kr(env1,gate)+lfovar),panvar),EnvGen.kr(env3,gate),q,EnvGen.ar(env2,gate,doneAction:2));
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(0,amp*input)
}).store;
);


//SimpleSaw
(
SynthDef(\simpleSaw,{|amp=1,freq1=400,freq2=400,vol1=1,vol2=0,fltr1=10,fltr2=1000,fltrdecay=2,pitchdecay=2,q=3,voldecay=1,pan=0,lfo=10,lfoamount=0,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,multi=1,gate=1|
	var env1,env2,env3,input,lfovar;
	env1=Env.new([0,freq1,freq2],[0,pitchdecay]);
	env2=Env.new([0,vol1,vol2],[0,voldecay]);
	env3=Env.new([0,fltr1,fltr2],[0,fltrdecay]);
	lfovar=SinOsc.kr(lfo,mul:lfoamount);
	input=RLPF.ar(Pan2.ar(0.5*Saw.ar(multi*(EnvGen.kr(env1,gate)+lfovar))*EnvGen.kr(env2,gate, doneAction:2),pan),EnvGen.kr(env3,gate),q);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
    	Out.ar(0,amp*input)
}).store;
);


(
SynthDef(\acidSaw,{|amp=1,freq1=400,freq2=400,vol1=1,vol2=0,fltr1=10,fltr2=1000,fltrdecay=2,pitchdecay=2,q=3,voldecay=1,pan=0,lfo=10,lfoamount=0,cutoff=0,fltrenvamt=1,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,multi=1,gate=1|
	var env1,env2,env3,input,lfovar;
	env1=Env.new([0,freq1,freq2],[0,pitchdecay]);
	env2=Env.new([0,vol1,vol2],[0,voldecay]);
	env3=Env.new([0,fltr1,fltr2],[0,fltrdecay]);
	lfovar=SinOsc.kr(lfo,mul:lfoamount);
	input=BPF.ar(Pan2.ar(0.5*Saw.ar(multi*(EnvGen.ar(env1,gate)+lfovar))*EnvGen.ar(env2,gate, doneAction:2),pan),cutoff+EnvGen.ar(env3,gate,fltrenvamt),q);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
    	Out.ar(0,amp*input)
}).store;
);


//SimpleSquare
(
SynthDef(\simpleSquare,{|amp=1,freq1=400,freq2=400,vol1=1,vol2=0,fltr1=10,fltr2=1000,fltrdecay=2,pitchdecay=2,q=3,voldecay=1,pan=0,lfo=10,lfoamount=0,multi=1,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var env1,env2,env3,input,lfovar;
	env1=Env.new([0,freq1,freq2],[0,pitchdecay]);
	env2=Env.new([0,vol1,vol2],[0,voldecay]);
	env3=Env.new([0,fltr1,fltr2],[0,fltrdecay]);
	lfovar=SinOsc.kr(lfo,mul:lfoamount);
	input=RLPF.ar(Pan2.ar(0.5*Pulse.ar(multi*EnvGen.kr(env1,gate)+lfovar,mul:EnvGen.ar(env2,gate,doneAction:2)),pan),EnvGen.ar(env3,gate),q);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
		Out.ar(0,amp*input)
}).store;
);


//SimpleSquareFive
(
SynthDef(\simpleSquareFive,{|amp=1,freq1=660,freq2=660,vol1=1,vol2=0,fltr1=9000,fltr2=1000,fltrdecay=0.5,pitchdecay=2,q=1,voldecay=1,pan=0,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var env1,env2,env3,input;
	env1=Env.new([0,freq1,freq2],[0,pitchdecay]);
	env2=Env.new([0,vol1,vol2],[0,voldecay]);
	env3=Env.new([0,fltr1,fltr2],[0,fltrdecay]);
	input=RLPF.ar(Pan2.ar(0.5*Pulse.ar(EnvGen.kr(env1,gate))*EnvGen.kr(env2,gate, doneAction:2) + 0.5*Saw.ar(1.5*EnvGen.kr(env1,gate))*EnvGen.kr(env2,gate, doneAction:2) + 0.5*Pulse.ar(1.25*EnvGen.kr(env1,gate))*EnvGen.kr(env2,gate, doneAction:2),pan),EnvGen.kr(env3,gate),q);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(0,amp*input)
}).store;
);


//High Hats
(
SynthDef(\hh,{|amp=1,fltr1=1500,fltr2=20,q=1,vol1=1,vol2=0,voldecay=0.09,fltrdecay=0.2,pan=0,trem=100,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var env1, env2, panvar, input;
	env2=Env.new([0,vol1,vol2], [0,voldecay]);
	env1=Env.new([fltr1,fltr2],[fltrdecay]);
	panvar=pan + SinOsc.kr(trem);
	input=
	Pan2.ar(0.9*RHPF.ar(WhiteNoise.ar(EnvGen.kr(env2,gate,doneAction:2)),EnvGen.kr(env1,gate),q),panvar) +
	Pan2.ar(0.9*RHPF.ar(BrownNoise.ar(EnvGen.kr(env2,gate,doneAction:2)),EnvGen.kr(env1,gate),q),panvar) +
	Pan2.ar(0.9*RHPF.ar(ClipNoise.ar(EnvGen.kr(env2,gate,doneAction:2)),EnvGen.kr(env1,gate),q),panvar);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(0,amp*input)
}).store;
);


//Snare/Hat
(
SynthDef(\hh2,{|amp=1,fltr1=1500,fltr2=20,q=1,vol1=1,vol2=0,voldecay=0.09,fltrdecay=0.2,pan=0,trem=100,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var env1, env2, panvar, input;
	env2=Env.new([0,vol1,vol2], [0,voldecay]);
	env1=Env.new([fltr1,fltr2],[fltrdecay]);
	panvar=pan + SinOsc.kr(trem);
	input=
	Pan2.ar(0.9*BPF.ar(WhiteNoise.ar(EnvGen.kr(env2,gate,doneAction:2)),EnvGen.kr(env1,gate),q),panvar);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
		Out.ar(0,amp*input)
}).store;
);


//Ring Synth
(
SynthDef(\ring,{|amp=1,vol1=1,vol2=0,voldecay=3,mfreq1=660,mfreq2=660,mfreqdecay=3,cfreq1=880,cfreq2=440,cfreqdecay=3,trem=0,pan=0,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var ca,mo,env1,mofenv,cafenv,panvar,input;
	mofenv=Env.new([0,mfreq1,mfreq2],[0,mfreqdecay]);
	cafenv=Env.new([0,cfreq1,cfreq2],[0,cfreqdecay]);
	env1=Env.new([0,vol1,vol2], [0,voldecay]);
	mo=SinOsc.ar(EnvGen.kr(mofenv,gate),0,EnvGen.kr(env1,gate,doneAction:2));
	ca=SinOsc.ar(EnvGen.kr(cafenv,gate),0,EnvGen.kr(env1,gate,doneAction:2));
	panvar= pan+SinOsc.kr(trem);
	input=Pan2.ar(ca*mo,panvar);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(0,amp*input);
}).store;
);


//Wobble Bass
(
SynthDef(\wobble,{| amp=1,vol1=1,vol2=0,voldecay=0.7,pfreq1=100,pfreq2=1000,pfreqdecay=1,cfreq1=100,cfreq2=100,cfreqdecay=0.002,tfreq1=0,tfreq2=0,tfreqdecay=0.9,pan=0,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var env1, env2, env3, env4, synth, input, panvar;
	env1=Env.new([0,cfreq1,cfreq2],[0,cfreqdecay]);
	env2=Env.new([0,vol1,vol2],[0,voldecay]);
	env3=Env.new([0,pfreq1,pfreq2],[0,pfreqdecay]);
	env4=Env.new([0,tfreq1,tfreq2],[0,tfreqdecay]);
	synth=SinOsc.ar(EnvGen.ar(env1,gate),SinOsc.ar(EnvGen.kr(env3,gate)),EnvGen.ar(env2,gate,doneAction:2));
	panvar=pan+SinOsc.kr(EnvGen.ar(env4,gate));
	input=Pan2.ar(synth,panvar);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(0,amp*input);
}).store;
);

//Microphone w/Envelope
(
SynthDef(\micsample,{| in=0,pan=0,vol1=1,vol2=0,voldecay=1,trem=0,amp=1,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var env,tremolo,input;
	env=Env.new([0,vol1,vol2],[0,voldecay]);
	tremolo=SinOsc.kr(trem);
	input=Pan2.ar(SoundIn.ar(in,EnvGen.ar(env,gate,doneAction:2)),pan+tremolo);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(0,amp*input);
}).store;
);

//simpleSampler
(
SynthDef(\simpleSampler,{| out=0,amp=1,buf,rate=2,vol1=1,vol2=0,voldecay=0.2,trigger=1,startPos=0,trem=0,loop=1,pan=0,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var input,env,output;
	env=Env.new([0,vol1,vol2],[0,voldecay]);
    input=Pan2.ar(PlayBuf.ar(1,buf,BufRateScale.kr(buf)*rate,trigger,BufFrames.ir(buf)*startPos,loop),pan,EnvGen.kr(env,gate,doneAction:2));
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(out,amp*input)
}).store;
);

//simpleSamplerStereo
(
SynthDef(\simpleSamplerStereo,{|out=0,amp=1,buf,rate=2,vol1=1,vol2=0,voldecay=0.2,trigger=1,startPos=0,trem=0,loop=1,pan=0,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var input,env,output;
	env=Env.new([0,vol1,vol2],[0,voldecay]);
    input=Pan2.ar(PlayBuf.ar(2,buf,BufRateScale.kr(buf)*rate,trigger,BufFrames.ir(buf)*startPos,loop),pan,EnvGen.kr(env,gate,doneAction:2));
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(out,amp*input)
}).store;
);

//ringSampler
(
SynthDef(\ringSampler,{|out=0, amp=1,pan=0,trem=0,vol1=1,vol2=0,voldecay=1,freq1=440,freq2=100,freqdecay=1,buf,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var input,env,env1,tremolo;
	env=Env.new([vol1,vol2],[voldecay]);
	env1=Env.new([0,freq1,freq2],[0,freqdecay],'exp');
	tremolo=SinOsc.kr(trem);
	input=Pan2.ar(BufRd.ar(1,buf,K2A.ar(BufFrames.ir(buf)*EnvGen.ar(env,gate,doneAction:2)).lag(SinOsc.kr(EnvGen.kr(env1,gate)))),pan+tremolo);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(out,amp*input)
}).store;
);

//ringSamplerStereo
(
SynthDef(\ringSamplerStereo,{|out=0, amp=1,pan=0,trem=0,vol1=1,vol2=0,voldecay=1,freq1=440,freq2=100,freqdecay=1,buf,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=1,effAmp2=0,effAmp3=0,effAmp4=0, gate=1|
	var input,env,env1,tremolo;
	env=Env.new([vol1,vol2],[voldecay]);
	env1=Env.new([freq1,freq2],[freqdecay],'exp');
	tremolo=SinOsc.kr(trem);
	input=Pan2.ar(BufRd.ar(2,buf,K2A.ar(BufFrames.ir(buf)*EnvGen.ar(env,gate,doneAction:2))).lag(SinOsc.ar(EnvGen.ar(env1,gate))),pan+tremolo);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(out,amp*input)
}).store;
);

//ringSampler2
(
SynthDef(\ringSampler2,{|out=0, amp=1,pan=0,trem=0,vol1=1,vol2=0,voldecay=1,buf,effBus1=4,effBus2=5,effBus3=6,effBus4=7,effAmp1=0,effAmp2=0,effAmp3=0,effAmp4=0,gate=1|
	var input,env,env1,tremolo;
	env=Env.new([vol1,vol2],[voldecay]);
	tremolo=SinOsc.kr(trem);
	input=Pan2.ar(BufRd.ar(1,buf,K2A.ar(BufFrames.ir(buf)*EnvGen.ar(env,gate,doneAction:2))),pan+tremolo);
		Out.ar(effBus1,[input*effAmp1]);
		Out.ar(effBus2,[input*effAmp2]);
		Out.ar(effBus3,[input*effAmp3]);
		Out.ar(effBus4,[input*effAmp4]);
	    Out.ar(out,amp*input)
}).store;
);
)
