float keyx=261.626*(pow(2, 1f/12));
PImage img;
PImage bimg;
color c, cc;
float r, g, b;
float cr, cg, cb;
String hexc, chexc;
int time;
int x=0, y=0;
String k;
int note, oct;
float addx;
float pfreq, freq;
String ck;
int cnote;
boolean starts;
MyNote newNote;
MyNote1 newNote1;
import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.ugens.*;
Minim minim;
AudioOutput out;

void setup() {
  img = loadImage("sunrise.jpg");
  bimg = img.get();
  size(int(img.width/2.5), int(img.height/2.5));
  println(int(img.width/2.5), int(img.height/2.5));
  minim = new Minim(this);
  out = minim.getLineOut();
  frameRate(4);
  opening();
}
void opening(){
  cursor(ARROW);
  x=0;
  y=0;
  starts=false;
  tint(0, 153, 204);
  image(img, 0, 0,width,height);
  fill(#F7F0B9);
  textAlign(CENTER);
  textSize(60);
  text("Generative Music",0,100,width,height);
  textSize(40);
  text("Brian Mak",0,200,width,height);
  textSize(20);
  text("- Click anywhere to start -",0,400,width,height);
}

void mouseClicked(){
  if (starts){
    starts=false;
  }else{
    starts=true;
  }
  frameCount=0;
}

void draw(){
  if (starts){
    xx();
  }else{
    opening();
  }
}

void xx() {
  println("");
  noCursor();
  tint(255);
  image(img, 0, 0,width,height);
  c=get(x, y);
  hexc=hex(int(c));
  r=unhex(hexc.substring(2, 4));
  g=unhex(hexc.substring(4, 6));
  b=unhex(hexc.substring(6, 8));
  println(r, g, b);
  if (frameCount%16==1) {
    image(bimg, 0, 0,width,height);
    cc=get(x, y);
    chexc=hex(int(cc));
    cr=unhex(chexc.substring(2, 4));
    cg=unhex(chexc.substring(4, 6));
    cb=unhex(chexc.substring(6, 8));
    xhue(cr/255, cg/255, cb/255);
    image(img, 0, 0,width,height);
  }
  fill(c);
  stroke(cc);
  strokeWeight(4);
  ellipse(x, y, 50, 50);
  play();
      x=int((width-1)/64f*(frameCount%64));
      if (frameCount%64 == 0){
      y=int((height-1)/32*(frameCount/64));
      }
  if (frameCount == 64 * 32){
    opening();
  }
}

void fastSmallShittyBlur(PImage a, PImage b) { //a=src, b=dest img
  int pa[]=a.pixels;
  int pb[]=b.pixels;
  int h=a.height;
  int w=a.width;
  final int mask=(0xFF&(0xFF<<2))*0x01010101;
  for (int y=1; y<h-1; y++) { //edge pixels ignored
    int rowStart=y*w  +1;
    int rowEnd  =y*w+w-1;
    for (int i=rowStart; i<rowEnd; i++) {
      pb[i]=(
      ( (pa[i-w]&mask) // sum of neighbours only, center pixel ignored
      +(pa[i+w]&mask)
        +(pa[i-1]&mask)
        +(pa[i+1]&mask)
        )>>2)
        |0xFF000000 //alpha -> opaque
        ;
    }
  }
}

void xhue(float hr, float hg, float hb) {
  float min=min(hr, hg, hb);
  float max=max(hr, hg, hb);

  float hue = 0f;
  if (max-min!=0) {
    if (max == hr) {
      hue = (hg - hb) / (max - min);
    } else if (max == hg) {
      hue = 2f + (hb - hr) / (max - min);
    } else {
      hue = 4f + (hr - hg) / (max - min);
    }
    hue = hue * 60;
    if (hue < 0) { 
      hue = hue + 360;
    }
  } else {
    hue=0;
  }
  //  println(hue);
  if (hue>90 && hue<=270) {
    k="min";
  } else {
    k="maj";
  };
}

void play() {
    println (x + " " + y);
  println(frameCount%16, oct, k, note);

  if (k=="maj") {
    oct=int(((r+g+b)/382.5));
    pfreq=freq;

    note=int((r+g+b-(oct*382.5))/76.5);
    if (note<0) {
      note=note+(note/5)*5;
    }
    if (note==0) {
      addx=0;
    }
    if (note==1) {
      addx=2f/12;
    }
    if (note==2) {
      addx=4f/12;
    }
    if (note==3) {
      addx=7f/12;
    }
    if (note==4) {
      addx=9f/12;
    }
  } else

  {
    oct=int(((r+g+b)/382.5));
    pfreq=freq;

    note=int((r+g+b-(oct*382.5))/76.5);
    if (note<0) {
      note=note+(note/5)*5;
    }
    if (note==0) {
      addx=0;
    }
    if (note==1) {
      addx=4f/12;
    }
    if (note==2) {
      addx=5f/12;
    }
    if (note==3) {
      addx=9f/12;
    }
    if (note==4) {
      addx=11f/12;
    }
  }
  freq=keyx*(pow(2, oct+addx));

  if (frameCount%16==1) {
    ck=k; 
    cnote=note;
  }

  if (ck=="maj") {
    if (cnote==0 || cnote==2) {
      if (frameCount%8==1) {
        newNote1 = new MyNote1(keyx, 0.2);
      }
      if (frameCount%8==3) {
        newNote1 = new MyNote1(keyx*(pow(2, 7f/12)), 0.2);
      }
      if (frameCount%8==5) {
        newNote1 = new MyNote1(keyx*2, 0.2);
      }
      if (frameCount%8==7) {
        newNote1 = new MyNote1(keyx*(pow(2, 4f/12))*2, 0.2);
      }
    }
    if (cnote==1 || cnote==3) {
      if (frameCount%8==1) {
        newNote1 = new MyNote1(keyx*(pow(2, 7f/12))/2, 0.2);
      }
      if (frameCount%8==3) {
        newNote1 = new MyNote1(keyx*(pow(2, 2f/12)), 0.2);
      }
      if (frameCount%8==5) {

        newNote1 = new MyNote1(keyx*(pow(2, 7f/12)), 0.2);
      }
      if (frameCount%8==7) {

        newNote1 = new MyNote1(keyx*(pow(2, 11f/12)), 0.2);
      }
    }
    if (cnote==4) {

      if (frameCount%8==1) {
        newNote1 = new MyNote1(keyx*(pow(2, 5f/12))/2, 0.2);
      }
      if (frameCount%8==3) {
        newNote1 = new MyNote1(keyx, 0.2);
      }
      if (frameCount%8==5) {
        newNote1 = new MyNote1(keyx*(pow(2, 5f/12)), 0.2);
      }
      if (frameCount%8==7) {

        newNote1 = new MyNote1(keyx*(pow(2, 9f/12)), 0.2);
      }
    }
  } else {
    if (cnote==0 || cnote==3) {

      if (frameCount%8==1) {
        newNote1 = new MyNote1(keyx*(pow(2, 9f/12))/2, 0.2);
      }
      if (frameCount%8==3) {

        newNote1 = new MyNote1(keyx*(pow(2, 4f/12)), 0.2);
      }
      if (frameCount%8==5) {
        newNote1 = new MyNote1(keyx*(pow(2, 9f/12)), 0.2);
      }
      if (frameCount%8==7) {
        newNote1 = new MyNote1(keyx*2, 0.2);
      }
    }
    if (cnote==1 || cnote==4) {

      if (frameCount%8==1) {
        newNote1 = new MyNote1(keyx*(pow(2, 4f/12))/2, 0.2);
      }
      if (frameCount%8==3) {

        newNote1 = new MyNote1(keyx*(pow(2, 11f/12))/2, 0.2);
      }
      if (frameCount%8==5) {
        newNote1 = new MyNote1(keyx*(pow(2, 4f/12)), 0.2);
      }
      if (frameCount%8==7) {

        newNote1 = new MyNote1(keyx*(pow(2, 7f/12)), 0.2);
      }
    }
    if (cnote==2) {

      if (frameCount%8==1) {
        newNote1 = new MyNote1(keyx*(pow(2, 2f/12)), 0.2);
      }
      if (frameCount%8==3) {

        newNote1 = new MyNote1(keyx*(pow(2, 9f/12)), 0.2);
      }
      if (frameCount%8==5) {
        newNote1 = new MyNote1(keyx*(pow(2, 2f/12))*2, 0.2);
      }
      if (frameCount%8==7) {
        newNote1 = new MyNote1(keyx*(pow(2, 5f/12))*2, 0.2);
      }
    }
  }


  if (freq!=pfreq || frameCount%16==1) {
    if (frameCount%2!=0 && r+g+b>255) {
      newNote = new MyNote(freq, 0.3);
      newNote1 = new MyNote1(freq*2, 0.3/10);
    } else if (frameCount%8==1) {
      newNote = new MyNote(freq, 1);
      newNote1 = new MyNote1(freq*2, 1/10);
    } else if (frameCount%2!=1 && r+g+b>255) {
      newNote = new MyNote(freq, 0.6);
      newNote1 = new MyNote1(freq*2, 0.6/10);
    }
  }
}

class MyNote implements AudioSignal
{

  private float level;
  private float alph;
  private SineWave sine;
  private float lvel;
  MyNote(float freq, float vel)
  {  
    //    if ( millis() > timer2 ) {

    level = vel*0.1+(r+g+b+cr+cg+cb)/4000;
    if (level>0.3) {
      level=0.3;
    }
    sine = new SineWave(freq, level, out.sampleRate());
    alph = map(freq, keyx, keyx*4, 0.95, 0.92);  // Decay constant for the envelope
    out.addSignal(this);
    //      timer2+=delay2;
    //    }
  }

  void updateLevel()
  {     
    // Called once per buffer to decay the amplitude away

    level = level * alph;
    sine.setAmp(level);

    // This also handles stopping this oscillator when its level is very low.


    if (level < 0.005) {
      out.removeSignal(this);
    }
  }

  // this will lead to destruction of the object, since the only active 
  // reference to it is from the LineOut





  void generate(float [] samp)
  {
    // generate the next buffer's worth of sinusoid
    sine.generate(samp);
    // decay the amplitude a little bit more
    updateLevel();
  }

  // AudioSignal requires both mono and stereo generate functions
  void generate(float [] sampL, float [] sampR)
  {
    sine.generate(sampL, sampR);
    updateLevel();
  }
}


class MyNote1 implements AudioSignal
{

  private float level;
  private float alph;
  private SineWave sine;
  private float lvel;
  MyNote1(float freq, float vel)
  {  
    //    if ( millis() > timer2 ) {

    level = 0.05;
    lvel=vel;
    sine = new SineWave(freq/2, level, out.sampleRate());
    alph = .97;  // Decay constant for the envelope
    out.addSignal(this);
    //      timer2+=delay2;
    //    }
  }
  int h=0;
  void updateLevel()
  {     

    // Called once per buffer to decay the amplitude away
    if (level<lvel*(0.8+(cr+cg+cb)/500) && h==0) {
      level=lvel*(0.8+(cr+cg+cb)/500);
      h=1;
    } else {
      level = level * alph;
    }
    sine.setAmp(level);

    // This also handles stopping this oscillator when its level is very low.


    if (level < 0.01) {
      out.removeSignal(this);
    }
  }

  // this will lead to destruction of the object, since the only active 
  // reference to it is from the LineOut





  void generate(float [] samp)
  {
    // generate the next buffer's worth of sinusoid
    sine.generate(samp);
    // decay the amplitude a little bit more
    updateLevel();
  }

  // AudioSignal requires both mono and stereo generate functions
  void generate(float [] sampL, float [] sampR)
  {
    sine.generate(sampL, sampR);
    updateLevel();
  }
}

