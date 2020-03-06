//flag to save iMAGE
Boolean save = false; 
//libs
import gifAnimation.*;
import processing.sound.*;

SoundFile[] ting = new SoundFile[27];

PGraphics stage;
PGraphics menorah;

//m vars
float mBeginX = 0; 
float mBeginY = 0;
float mEndX = 0; 
float mEndY = 0;
float mDistX = 0; 
float mDistY = 0;
float mX = 0; 
float mY = 0;
float mSizeX = 0; 
float mSizeY = 0;
float mRad = 0;
float mStartsizeX = 0;  
float mStartsizeY = 0; 
color mColor = color(255, 180, 3);
float step = 0.0;
float increment = 0.001; //slow 0.001, fast 0.01 
int state = 0;
int mode = 0; 
int statelimit = 26; 
float mHeight = 1029; 
float mWidth = 1372; 


int d = day();    // Values from 1 - 31
int m = month();  // Values from 1 - 12
int p = (d*m%200)+55;
color main = color(random(50, 200), p, 255-p, 10);
color bgcol = color(128, 128, 128, 1);

PImage expImg1[]; 
PImage expImg2[];
PImage expImg0[]; 
PImage myIcon;
int framecounter = 0; 
int count = 22; //22
int xgrid = 14; //14//7; 
int ygrid = 8; //4;
float xstep = 0.0; 
float ystep = 0.0; 
int gifcounter = 0;
int giflimit = 411; 
int offset = 100;
float minspeed = 0.5; 
float maxspeed = 5.0; 
String theme = "zach"; 
String folder = "gif_"+theme+"/"+theme; 
int framelimit = 7000; 
float crashlimit = 30.0; 

int globalcount = 0; 
int expEnd = 0; 
int lead = 45; 
Boolean exp  = true; 
float explosionX = 0; 
float explosionY = 0; 
int exptype = 0; 

//vars
Trace[] coll;  
Boolean dir = false; 

Boolean test = false; 
void setup() { 
  myIcon = loadImage("icon.png"); 
  //noCursor();
  fullScreen();
  //size(1280, 1024); 
  //size(8192, 928); //ZKM
  frameRate(30); 
  //stage = createGraphics(8192, 928); 
  stage = createGraphics(1920, 1080);
  menorah = createGraphics(1372, 1029);
  menorah.noStroke(); 
  mFactor(state);

  for (int i = 0; i < 27; i++) {
    ting[i] = new SoundFile(this, "tink"+i+".wav");
  }

  //add exp graphics
  expImg0 = Gif.getPImages(this, "exp4.gif");
  expImg1 = Gif.getPImages(this, "exp5.gif");
  expImg2 = Gif.getPImages(this, "exp3.gif");
  coll = new Trace[count];
  xstep = (width-offset)/xgrid;
  ystep = (height-offset)/ygrid; 
  for (int i = 0; i < count; i++) {
    int colltype = 0; 
    gifcounter ++; 
    String collname = folder+gifcounter+".gif";
    float xstart = 0.0; 
    float ystart = 0.0;     
    dir = !dir; 

    // directional constructor
    float typeXspeed = 0.0; 
    float typeYspeed = 0.0; 
    if (dir == true && i < xgrid) {
      typeYspeed = 1.0;
      xstart = offset/2+(xstep*i); 
      ystart = 0.0 - random(offset); 
      ; 
      colltype = 0;
    }
    if (dir == false && i < xgrid) {
      typeYspeed = -1.0;
      xstart = offset/2+(xstep*i); 
      ystart = height + random(offset); 
      ; 
      colltype = 1;
    }
    if (dir == true && i >= xgrid) {
      typeXspeed = 1.0;
      xstart = 0 - random(offset); 
      ystart = offset/2+(ystep*(i-xgrid)); 
      colltype = 2;
    }
    if (dir == false && i >= xgrid) {
      typeXspeed = -1.0;
      xstart = width+random(offset); 
      ystart = offset/2+ystep*(i-xgrid); 
      colltype = 3;
    }     

    coll[i] = new Trace(this, xstart, ystart, 0.0, 0.0, 1.0, 1.0, colltype, i, collname);
    float speedfactor = minspeed+random(maxspeed);
    coll[i].xspeed = typeXspeed*speedfactor; 
    coll[i].yspeed = typeYspeed*speedfactor;
  }
}

void draw() { 
  globalcount++; 
  stage.beginDraw(); 
  stage.background(bgcol);
  //update all coll
  for (int a = 0; a < count; a++) {
    coll[a].updateFunction();
    coll[a].animaFunction();  
    stage.image(coll[a].gif[coll[a].frame], coll[a].xpos, coll[a].ypos);
  }
  stage.endDraw();
  //update menorah
  menorah.beginDraw();
  mPath();
  menorah.endDraw();
  image(stage, 0, 0);
  //update gif
  //tint(204, 153, 0, 5);
  tint(main);
  image (menorah, 274, 25); 
  blend(menorah, 0, 0, 274, 25, 0, 0, width, height, BLEND);
  crashTest(); 
  sndExp(); 
  framecounter ++; 
  if (framecounter < framelimit && save == true) {
    saveFrame("gif_"+theme+"_######.jpg");
    println ("c = "+framecounter);
  }
}

//menorah
void mPath() { 
  menorah.noStroke();
  step += increment; 
  if (step < 1.0 ) {
    if (mode == 0) { // line
      mX = mBeginX+(mDistX*step); 
      mY = mBeginY+(mDistY*step); 
      mSizeX= mStartsizeX-(step*mStartsizeX/3.5); 
      mSizeY= mStartsizeY-(step*mStartsizeX/3.5);
    }

    if (mode == 1) { // curve
      mX = mBeginX+(cos((step*PI))*mRad); 
      mY = mBeginY+(sin((step*PI))*mRad);
    }
    if (mode == 2) { // curve
      mX = mBeginX+(cos(TWO_PI-(step*PI))*mRad); 
      mY = mBeginY+(sin(TWO_PI-(step*PI))*mRad);
    }

    if (mode == 3) { // curve reverse
      mX = mBeginX+(cos(PI+(step*PI))*mRad); 
      mY = mBeginY+(sin(PI+(step*PI))*mRad);
    }
    if (mode == 4) { // curve reverse
      mX = mBeginX+(mDistX*step)+sin(step*mStartsizeX/5)*mWidth/224; 
      mY = mBeginY+(mDistY*step); 
      mSizeX= mStartsizeX-(step*mStartsizeX); 
      mSizeY= mStartsizeY-(step*mStartsizeX);
    }
  } else {
    step = 0.0; 
    ting[state].stop(); 
    if (state < statelimit) {
      state += 1;
    } 
    if (state == statelimit) {
      state = 0 ; 
      menorah.background(bgcol);
    }
    println("state = "+state);
    mFactor(state);
    ting[state].play();
  }
  menorah.noStroke(); 
  menorah.ellipse (mX, mY, mSizeX, mSizeY);
  menorah.fill(mColor);
}


//collisions?
void crashTest() {
  for (int c = 0; c < count; c++) {
    if (coll[c].type <=1) {

      for (int d = 0; d < ygrid; d++) {
        int vertCounter = d+14; 
        float distance = dist(coll[c].xpos, coll[c].ypos, coll[vertCounter].xpos, coll[vertCounter].ypos); 
        if (distance < crashlimit)
        {
          if (coll[c].crash == false && coll[vertCounter].crash == false) {
            //println("coll."+ c+ "'s distance to coll."+vertCounter+" is "+  distance);
            explosionX = (coll[c].xpos+(coll[c].xsize/2)+coll[vertCounter].xpos+(coll[vertCounter].xsize/2))/2.0; 
            explosionY = (coll[c].ypos+(coll[c].ysize/2)+coll[vertCounter].ypos+(coll[vertCounter].ysize/2))/2.0; 
            explode(c, vertCounter); 
            coll[c].crash = true; 
            coll[vertCounter].crash = true;
          }
        }
      }
    }
  }
}
void explode(int a, int b) {
  coll[a].updateFunction(); 
  coll[b].updateFunction();
  //change bg color
  int red = int(random(255)); 
  int green = int(random(255)); 
  int blue = int(random(255)); 
  bgcol = color(red, green, blue, 1); 
  expEnd = globalcount+lead; 
  exp = true; 
  exptype = int(random(3.0));
} 

void sndExp() {
  if (exp == true) {
    ting[globalcount%26].play(); 
    exp=false;
  }
}



//controls: r to record
void keyPressed() {
  if (key == 'r') {
    println("pressed r and saving");
    gifcounter = 0;
    if (save == true) {
      save = false;
    } else {
      save = true;
    }
  }

  if (key == 't') {
    println ("pressed t and testing");
    if (test == true) {
      test = false;
    } else {
      test = true;
    }
  }
}
//class
class Trace {
  float xpos, ypos;   // x,y location
  float xsize, ysize;   // width and height
  float xspeed, yspeed; // speeds of animation
  int frame; // current gif frame
  float step; 
  float counter; 
  int type, id; 
  String name;
  PImage gif[]; 
  PApplet applet;
  Boolean crash; 

  Trace(PApplet p, float x, float y, float sx, float sy, float dx, float dy, int t, int i, String n) {
    xpos = x;
    ypos = y;
    xsize = sx;
    ysize = sy;
    xspeed = dx; 
    yspeed = dy; 
    type = t; 
    id = i; 
    name = n; 
    gif = Gif.getPImages(p, name);
    xsize = gif[0].width;
    ysize = gif[0].height;
    applet = p; 
    step = (random(2.0)+0.1)/3.0; 
    counter = 0; 
    crash = false;
  }



  void reloadFunction() {
    if (gifcounter < giflimit) {
      gifcounter++; 
      //println ("g = "+gifcounter); 
      String collname = folder+gifcounter+".gif";
      gif = Gif.getPImages(applet, collname);
      xsize = gif[0].width;
      ysize = gif[0].height;
      step = (random(2.0)+0.1)/3.0; 
      crash = false; 
      counter = 0.0; 
      float speedfactor = minspeed+random(maxspeed);  //max(0.25,(10.0-(sqrt(ysize*xsize)/10.00))); 
      //println (speedfactor +" is speedfactor");
      if (type == 0) { //vertical down
        xspeed = 0.0; 
        yspeed = speedfactor;
      }
      if (type == 1) { //vertical up
        xspeed = 0.0; 
        yspeed = -1.0*speedfactor;
      }
      if (type == 2) { //horizontal to left
        xspeed = speedfactor; 
        yspeed = 0.0;
      }
      if (type == 3) { //horizontal to right
        xspeed = -1.0*speedfactor; 
        yspeed = 0.0;
      }
    } else {
      gifcounter = 0;  
      //xspeed = 0.0; 
      //yspeed = 0.0;
    }
  }

  void animaFunction() {
    xpos = xpos+xspeed; 
    ypos = ypos+yspeed;
    counter = counter + step;
    frame = int(counter)%gif.length;
  }

  void updateFunction() {
    if (type == 0) {
      if (ypos > height || crash) {
        ypos = 0-ysize;
        xpos = offset/2 + (xstep*id) - (xsize/2.0); 
        reloadFunction();
      }
    }
    if (type == 1) {
      if (ypos < 0-ysize || crash) {
        ypos = height;
        xpos = offset/2 + (xstep*id) - (xsize/2.0); 
        reloadFunction();
      }
    }
    if (type == 2) {
      if (xpos > width || crash) {
        xpos = 0-xsize; 
        ypos = offset/2 + (ystep*(id-xgrid)) - (ysize/2.0); 
        reloadFunction();
      }
    }
    if (type == 3) {
      if (xpos < 0-xsize || crash) {
        xpos = width;
        ypos = offset/2 + (ystep*(id-xgrid)) - (ysize/2.0) ; 
        reloadFunction();
      }
    }
  }
}

void mFactor(int s) {
  increment = (random(5.0)/1000.0)+0.002;
  mColor = color (random(255), random(255), random(255)); 
  switch(s) {
  case 0: 
    //println("case 0");
    //update color every day
    update(); 
    //base 
    mode = 0; //line
    mBeginX = 2*mWidth/28; //width/2; 
    mBeginY = 18*mHeight/21;
    mEndX = 14*mWidth/28;//8*width/9; 
    mEndY = 18*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 98; 
    break;
  case 1: 
    //println("case = " + state);
    //base 
    mode = 0; //line
    mBeginX = 26*mWidth/28;
    mBeginY = 18*mHeight/21;
    mEndX = 14*mWidth/28;
    mEndY = 18*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 98; 
    break;

  case 2: 
    //println("case = " + state);
    //base to first arm
    mode = 0; //line
    mBeginX = 14*mWidth/28; 
    mBeginY = 18*mHeight/21;
    mEndX = 14*mWidth/28; 
    mEndY = 13*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = mSizeX; 
    break;
  case 3: 
    //println("case = " + state);
    //first arm
    mode = 1; //curve
    mRad  = 6*mHeight/21;
    mBeginX = 14*mWidth/28; 
    mBeginY = 7*mHeight/21; 
    break;
  case 4: 
    //println("case = " + state);
    //first arm to second arm
    mode = 0; //line
    mBeginX = 14*mWidth/28; 
    mBeginY = 13*mHeight/21;
    mEndX = 14*mWidth/28;
    mEndY = 11*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = mSizeX; 
    break;
  case 5: 
    //println("case = " + state);
    //second arm
    mode = 1; //curve
    mRad  = 4*mHeight/21;
    mBeginX = 14*mWidth/28; 
    mBeginY = 7*mHeight/21;
    break;
  case 6: 
    //println("case = " + state);
    //second arm to third arm
    mode = 0; //line
    mBeginX = 14*mWidth/28; 
    mBeginY = 11*mHeight/21;
    mEndX = 14*mWidth/28;
    mEndY = 9*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = mSizeX; 
    break;
  case 7: 
    //println("case = " + state);
    //third arm
    mode = 1; //curve
    mRad  = 2*mHeight/21;
    mBeginX = 14*mWidth/28; 
    mBeginY = 7*mHeight/21;
    break;
  case 8: 
    //println("case = " + state);
    mode = 0; //line to top of menorah
    mBeginX = 14*mWidth/28;
    mBeginY = 9*mHeight/21;
    mEndX = 14*mWidth/28;
    mEndY = 7*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = mSizeX; 
    break;
  case 9: 
    //println("case = " + state);
    mode = 0; //line for first tree
    mBeginX = 24*mWidth/28; 
    mBeginY = 18*mHeight/21;
    mEndX = 24*mWidth/28; 
    mEndY = 7*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 28; //keep same on both sides
    break;
  case 10: 
    //println("case = " + state);
    mode = 2; //curve rainbow 
    mRad  = 5*mHeight/21;
    mBeginX = 19*mWidth/28; 
    mBeginY = 7*mHeight/21;
    break;
  case 11: 
    //println("case = " + state);
    mode = 0; //line
    mBeginX = 4*mWidth/28; 
    mBeginY = 18*mHeight/21;
    mEndX = 4*mWidth/28;
    mEndY = 7*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 28; //keep same on both sides
    break;
  case 12: 
    //println("case = " + state);
    mode = 3; //curve rainbow reverse
    mRad  = 5*mHeight/21;
    mBeginX = 9*mWidth/28; 
    mBeginY = 7*mHeight/21;
    break;
  case 13: 
    //println("case = " + state);
    mode = 2; //curve rainbow 
    mRad  = 4*mHeight/21;
    mBeginX = 20*mWidth/28; 
    mBeginY = 7*mHeight/21;
    break;
  case 14: 
    //println("case = " + state);
    mode = 3; //curve rainbow reverse
    mRad  = 4*mHeight/21;
    mBeginX = 8*mWidth/28; 
    mBeginY = 7*mHeight/21; 
    break;
  case 15: 
    //println("case = " + state);
    mode = 2; //curve rainbow 
    mRad  = 3*mHeight/21;
    mBeginX = 21*mWidth/28; 
    mBeginY = 7*mHeight/21;
    break;
  case 16: 
    //println("case = " + state);
    mode = 3; //curve rainbow reverse
    mRad  = 3*mHeight/21;
    mBeginX = 7*mWidth/28; 
    mBeginY = 7*mHeight/21; 
    break;
  case 17: 
    //println("case = " + state);
    mode = 2; //curve rainbow 
    mRad  = 2*mHeight/21;
    mBeginX = 22*mWidth/28; 
    mBeginY = 7*mHeight/21; 
    break;
  case 18: 
    //println("case = " + state);
    mode = 3; //curve rainbow reverse
    mRad  = 2*mHeight/21;
    mBeginX = 6*mWidth/28; 
    mBeginY = 7*mHeight/21; 
    break;
  case 19: 
    //println("case = " + state);
    mode = 4; //flame
    mBeginX = 8*mWidth/28; 
    mBeginY = 7*mHeight/21;
    mEndX = 8*mWidth/28;
    mEndY = 5*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 28+random(28); //keep same on both sides
    break;
  case 20: 
    //println("case = " + state);
    mode = 4; //flame
    mBeginX = 10*mWidth/28; 
    mBeginY = 7*mHeight/21;
    mEndX = 10*mWidth/28;
    mEndY = 5*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 28+random(28); //keep same on both sides
    break;
  case 21: 
    //println("case = " + state);
    mode = 4; //flame
    mBeginX = 12*mWidth/28; 
    mBeginY = 7*mHeight/21;
    mEndX = 12*mWidth/28;
    mEndY = 5*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 28+random(28); //keep same on both sides
    break; 
  case 22: 
    //println("case = " + state);
    mode = 4; //flame
    mBeginX = 14*mWidth/28; 
    mBeginY = 7*mHeight/21;
    mEndX = 14*mWidth/28;
    mEndY = 5*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 28+random(28); //keep same on both sides
    break;
  case 23: 
    //println("case = " + state);
    mode = 4; //flame
    mBeginX = 16*mWidth/28; 
    mBeginY = 7*mHeight/21;
    mEndX = 16*mWidth/28;
    mEndY = 5*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 28+random(28); //keep same on both sides
    break;
  case 24: 
    //println("case = " + state);
    mode = 4; //flame
    mBeginX = 18*mWidth/28; 
    mBeginY = 7*mHeight/21;
    mEndX = 18*mWidth/28;
    mEndY = 5*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 28+random(28); //keep same on both sides
    break;
  case 25: 
    //println("case = " + state);
    mode = 4; //flame
    mBeginX = 20*mWidth/28; 
    mBeginY = 7*mHeight/21;
    mEndX = 20*mWidth/28;
    mEndY = 5*mHeight/21;
    mDistX = mEndX - mBeginX; 
    mDistY = mEndY - mBeginY; 
    mStartsizeX = mStartsizeY = 28+random(28); //keep same on both sides 
    break;
  default:             
    println("No match");  
    break;
  }
}
void update() {
  d = day();    // Values from 1 - 31
  m = month();  // Values from 1 - 12
  p = (d*m%200)+55;
  main = color(random(50, 200), p, 255-p, 10);
}

void mousePressed() {
  float d = 1000; 
  int one = 0; //int(random(count)); 
  int two = 1; //int(random(count)); 
  for (int i= 0; i <count; i++) {
    float newD = dist(mouseX, mouseY, coll[i].xpos, coll[i].ypos);
    if (newD < d) {
      d=newD;
      two = one; 
      one = i; 
    }
  }

  if (coll[one].crash == false && coll[two].crash == false) {
    explode(one, two);
    coll[one].crash = true; 
    coll[two].crash = true;
    println("bam for"+one+","+two);
  }
  cursor(myIcon); 
}
