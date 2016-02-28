import oscP5.*;
import netP5.*;
import java.util.Arrays;

OscP5 oscP5;
NetAddress dest;

/* lightning declarations */
float maxDTheta = PI/10;
float minDTheta = PI/20;
float maxTheta = PI/2;
float childGenOdds = .01;
float minBoltWidth = 3;
float maxBoltWidth = 10;
float minJumpLength = 1;
float maxJumpLength = 10;
boolean stormMode = true;
boolean fadeStrikes = true;
boolean randomColors = false;
float maxTimeBetweenStrikes = 3000;
color boltColor;
int rl, gl, bl;
int rl2, gl2, bl2;
color skyColor;
lightningBolt bolt;
float lastStrike = 0;
float nextStrikeInNms = 0;
float meanDistance = 0;
int counter;
int moduloBolt;

/* Oscillating circle declarations */
int gridLeft;
int gridRight;
int gridTop;
int gridBottom;
int colorIndex;
float noiseX, noiseY;
ArrayList<Oscillator> oscillators;
float r1, r2, g1, g2, b1, b2;
int[] r1s = {0,   106,  0,    20,   255};
int[] r2s = {255, 20,   13,   255,  255};
int[] g1s = {139, 20,   8,    255,  238};
int[] g2s = {20,  255,  255,  239,  0};
int[] b1s = {139, 255,  255,  55,   0};
int[] b2s = {147, 255,  0,    20,   0};
float lineThreshold = 25;
boolean flashBg;
int flash = 1;
int visualiztion = 0; //keeps track of which visualization to display

/* Dot matrix declarations */
int num_points = 20;
Point[] points = new Point[num_points];
Point[][] pointmapping = new Point[num_points][2];
Point[] points2 = new Point[num_points];
Point[][] pointmapping2 = new Point[num_points][2];
int c;
int edgeDistance = 200;
float rotated;
float rotAmount;

/* Initializing variables to capture OSC values */
float f1, f2, f3, f4, f5, t1, t2, t3, t4, accX, accY, accZ;

void setup(){
  oscP5 = new OscP5(this, 7000); 
  dest = new NetAddress("10.201.26.178", 6000);

  size(1900, 1000);
  smooth();
  frameRate(30);

  /* lightning setup */
  meanDistance = 1000*.5;
  counter = 0;
  moduloBolt = 30;
  rl = 0;
  gl = 0;
  bl = 99;
  boltColor = color(rl, gl, bl);
  skyColor = color(0,0,10,20);  

  /*    oscillating circle grid setup    */
  gridLeft = (width / 2) - 225;
  gridRight = gridLeft + 450;
  gridTop = (height / 2) - 225;
  gridBottom = gridTop + 450;
  rotated = 0;
  rotAmount = 0;

  Oscillator circle;
  colorIndex = 0; 
  flashBg = false;
  noiseX = random(100);
  noiseY = random(100);
  oscillators = new ArrayList<Oscillator>();
  for(int x = gridLeft; x <= gridRight; x += 25){
    for(int y = gridTop; y <= gridBottom; y += 25){      
      if (x == gridLeft || x == gridRight){
        circle = new Oscillator(new PVector(x, y), true);
      }
      else if (y == gridTop || y == gridBottom){
        circle = new Oscillator(new PVector(x, y), true);
      }
      else {
        circle = new Oscillator(new PVector(x, y), false);
      }
      oscillators.add(circle);
    }
  }
  /*  ================================  */

  /*  floating dot / line matrix setup */
  num_points = 20;
  float size;
  float x_pos;
  float y_pos;
  int i =  0;
  int j =  0;
  int i2 = 0;
  int j2 = 0;
  Point point;
  while (i < num_points){
    size = random(5,15);
    x_pos = random(edgeDistance/2, gridLeft - edgeDistance);
    y_pos = random(gridTop, gridBottom);   
    point = new Point(x_pos, y_pos, size, 0);
    points[i] = point;
    i++;
  }
  int k;
  for (j=0; j < points.length; j++){
    if (j == 18 || j == 19){
      k = j-19;
    }
    else{
      k = j;
    }
    pointmapping[j][0] = points[k+1];
    pointmapping[j][1] = points[k+2];
  }

  while (i2 < num_points){
    size = random(5,15);
    x_pos = random(gridRight + edgeDistance, width - edgeDistance/2);
    y_pos = random(gridTop, gridBottom);   
    point = new Point(x_pos, y_pos, size, 1);
    points2[i2] = point;
    i2++;
  }
  int k2;
  for (j2=0; j2 < points2.length; j2++){
    if (j2 == 18 || j2 == 19){
      k2 = j2-19;
    }
    else{
      k2 = j2;
    }
    pointmapping2[j2][0] = points2[k2+1];
    pointmapping2[j2][1] = points2[k2+2];
  }  
  /*  ==============================  */

}
 
void draw(){

  if (visualiztion == 0){ // show electronic / pop visualization
    //rotate(-rotated);
    rotate(rotAmount);
    //rotated = rotAmount;

    if (flashBg){
      flash = flash ^ 1;
      if (flash == 1){
        background(54, 54, 54);
      } else{
         background(0);
      }
    } else{
      background(0);
    }
    stroke(-1,150);
    line(-width, height/2, width, height/2);

    float x1, x2, y1, y2;
    for (c = 0; c < points.length; c++){
      Point point = points[c];
      point.move();
      point.traveled++;
      x1 = pointmapping[c][0].x;
      y1 = pointmapping[c][0].y;
      x2 = pointmapping[c][1].x;
      y2 = pointmapping[c][1].y;
      point.connect(x1, y1, x2, y2);
      point.display();
    }
    for (c = 0; c < points2.length; c++){
      Point point = points2[c];
      point.move();
      point.traveled++;
      x1 = pointmapping2[c][0].x;
      y1 = pointmapping2[c][0].y;
      x2 = pointmapping2[c][1].x;
      y2 = pointmapping2[c][1].y;
      point.connect(x1, y1, x2, y2);
      point.display();
    }

    for(Oscillator oscillator: oscillators){
      oscillator.display();
    } 
  } else{ // show heavy metal visualization
      clear();
      background(0);
      counter++;
      if (counter % moduloBolt == 0){
        counter = 0;
        bolt = new lightningBolt(random(0,width),0,random(minBoltWidth,maxBoltWidth),0,minJumpLength,maxJumpLength,boltColor);
        background(skyColor);    
        bolt.draw();
      }
    }
}
 
/*                                        Oscillating circles                                             */
class Oscillator{
  PVector pos;
  boolean onBorder;
  float rad;
   
  Oscillator(PVector pos, boolean onBorder){
    this.pos = pos;
    this.onBorder = onBorder;
    rad = random(TWO_PI);
  }
   
  void display(){
    float diameter = map(sin(rad), -1, 1, 10, 24);
    noStroke();
    if (onBorder == true){
      fill(255, 255, 255, 100);
      if (diameter > lineThreshold){
        drawCircleLine(pos.x, pos.y);
      }
    } else{
      fill(map(sin(rad), -1, 1, r1s[colorIndex], r2s[colorIndex]), map(sin(rad), -1, 1, g1s[colorIndex], g2s[colorIndex]), map(sin(rad), -1, 1, b1s[colorIndex], b2s[colorIndex]));      
    }
    ellipse(pos.x, pos.y, diameter, diameter);
    rad += map(noise(noiseX + pos.x * 0.05, noiseY + pos.y * 0.05), 0, 1, PI / 128, PI / 6);
    if(rad > TWO_PI){
      rad -= TWO_PI;
    }
  }
   
}
/*  =====================================================================================================  */

/*                                        OSC Event Handling                                               */
void oscEvent(OscMessage theOscMessage) {
   if (theOscMessage.checkAddrPattern("/1/fader1")==true) { //controls color
      if(theOscMessage.checkTypetag("f")) { // looking for 1 parameter
          f1 = theOscMessage.get(0).floatValue(); 
      }
   } else if (theOscMessage.checkAddrPattern("/1/fader2")==true) { //controls circle lines
      if(theOscMessage.checkTypetag("f")) { // looking for 1 parameter
          f2 = theOscMessage.get(0).floatValue(); 
      }  
   } else if (theOscMessage.checkAddrPattern("/1/fader3")==true) { //controls gradient
       if(theOscMessage.checkTypetag("f")) { // looking for 1 parameter
          f3 = theOscMessage.get(0).floatValue(); 
      }   
   } else if (theOscMessage.checkAddrPattern("/1/fader4")==true) { //rotates sketch
       if(theOscMessage.checkTypetag("f")) { // looking for 1 parameter
          f4 = theOscMessage.get(0).floatValue(); 
      }   
   } else if (theOscMessage.checkAddrPattern("/1/fader5")==true) {
       if(theOscMessage.checkTypetag("f")) { // looking for 1 parameter
          f5 = theOscMessage.get(0).floatValue(); 
      }   
   } else if (theOscMessage.checkAddrPattern("/1/toggle1")==true) { //controls flashing screen
       if(theOscMessage.checkTypetag("f")) { // looking for 1 parameter
          t1 = theOscMessage.get(0).floatValue(); 
      }   
   } else if (theOscMessage.checkAddrPattern("/1/toggle2")==true) {
       if(theOscMessage.checkTypetag("f")) { // looking for 1 parameter
          t2 = theOscMessage.get(0).floatValue(); 
      }   
   } else if (theOscMessage.checkAddrPattern("/1/toggle3")==true) {
       if(theOscMessage.checkTypetag("f")) { // looking for 1 parameter
          t3 = theOscMessage.get(0).floatValue(); 
      }   
   } else if (theOscMessage.checkAddrPattern("/1/toggle4")==true) {
       if(theOscMessage.checkTypetag("f")) { // looking for 1 parameter
          t4 = theOscMessage.get(0).floatValue(); 
      }
   } else if (theOscMessage.checkAddrPattern("/accxyz")==true) {
          accX = theOscMessage.get(0).floatValue();
          accY = theOscMessage.get(1).floatValue();
          accZ = theOscMessage.get(2).floatValue();
   }

  visualiztion = (int)t2;
  if (visualiztion == 0){
    colorIndex = (int)map(f1, 0, 1, 0, 4);
    lineThreshold = map(f2, 0, 1, 24, 0);
    if (t1 == 1.0){
      flashBg = true;
    } else {
      flashBg = false;
    }
    if (abs(accX) > 0.2){
      rotAmount = map(accX, -1, 1, -0.2, 0.2);    
    } else {
      rotAmount = 0;
    }    
  } else {
      moduloBolt = (int)map(f1, 0, 1, 60, 1);
      counter = moduloBolt;
      rl = (int)map(f2, 0, 1, 0, 255);
      gl = (int)map(f3, 0, 1, 0, 255);
      bl = (int)map(f4, 0, 1, 0, 255);

      boltColor = color(rl, gl, bl);

      rl2 = rl - (int)map(rl, 0, 255, 50, 100);
      gl2 = gl - (int)map(gl, 0, 255, 50, 100);
      bl2 = bl - (int)map(bl, 0, 255, 50, 100);
      if (rl2 < 0){ rl2 = 0;}
      if (bl2 < 0){ bl2 = 0;}
      if (gl2 < 0){ gl2 = 0;}
      skyColor = color(rl2, gl2, bl2, 10);
  }


}
/*  =====================================================================================================  */

void drawCircleLine(float x, float y) {
  int i = 0;
  int x_offset = 0;
  int y_offset = 0;

  if ((x == gridLeft && y == gridTop) || (x == gridLeft && y == gridBottom) || (y == gridTop && x == gridRight) || (y == gridBottom && x == gridRight)){
    i = 10;
  }
  else {
    if (x == gridLeft){
        x_offset = 20;
        y_offset = 0;
    } else if (x == gridRight){
        x_offset = -20;
        y_offset = 0;
    } else if (y == gridTop){
        x_offset = 0;
        y_offset = 20;    
    } else {
        x_offset = 0;
        y_offset = -20;
    }
  } 
  while(i < 10){
    ellipse(x, y, 10, 10);
    x = x - x_offset;
    y = y - y_offset;
    i++;
  }  
}

/*                                            Dot matrix stuff                                             */
class Point{
  
  float x, y, d, angle_x, angle_y;
  float traveled = 0;
  int side = 0;

  Point(float x_pos, float y_pos, float diameter, int side_pos){
    x = x_pos;
    y = y_pos;
    d = diameter;
    side = side_pos;
  }

  void move(){
    if ((traveled % 60 == 0) || traveled == 0){
      traveled = 0;
      angle_x = random(-3, 3);
      angle_y = random(-3, 3);
      d = random(8,15);
    }
    if (side == 0){
      if ((x + angle_x)< edgeDistance){
        angle_x = random(1, 3);
      }
      else if ((x + angle_x) > gridLeft-edgeDistance){
        angle_x = random(-3, -1);
      }      
    } else{
       if ((x + angle_x)< gridRight+edgeDistance){
        angle_x = random(1, 3);
      }
      else if ((x + angle_x) > width-edgeDistance){
        angle_x = random(-3, -1);
      }
    }

    if ((y + angle_y) < gridTop){
      angle_y = random(1, 3);
    }
    else if ((y + angle_y) > gridBottom){
      angle_y = random(-3, -1);
    }
    x = x + angle_x;
    y = y + angle_y;
  }

  void connect(float x1, float y1, float x2, float y2){
    //noStroke();
    //filter(BLUR, 6);
    stroke(255,255,255,100);
    strokeWeight(1);
    line(x, y, x1, y1);   
    line(x, y, x2, y2);   
  }

  void display(){
    //noStroke();
    //filter(BLUR, 2);
    stroke(255,255,255);
    fill(255,255,255, 100);
    ellipse(x, y, d, d);
  }
}
/*  =====================================================================================================  */


/*                                            Lightning stuff                                              */
int randomSign(){
  float num = random(-1,1);
  if(num==0)
    return -1;
  else
    return (int)(num/abs(num));
}
 
color randomColor(){
  return color(random(0,100),99,99);
}
 
color slightlyRandomColor(color inputCol,float length){
  float h = hue(inputCol);
  h = (h+random(-length,length))%100;
  return color(h,99,99);
}


class lightningBolt{
  float lineWidth0,theta,x0,y0,x1,y1,x2,y2,straightJump,straightJumpMax,straightJumpMin,lineWidth;
  color myColor;
  lightningBolt(float x0I, float y0I, float width0, float theta0, float jumpMin, float jumpMax, color inputColor){
 
    lineWidth0 = width0;
    lineWidth = width0;
    theta = theta0;
    x0 = x0I;
    y0 = y0I;
    x1 = x0I;
    y1 = y0I;
    x2 = x0I;
    y2 = y0I;
    straightJumpMin = jumpMin;
    straightJumpMax = jumpMax;
    myColor = inputColor;
    //it's a wandering line that goes straight for a while,
    //then does a jagged jump (large dTheta), repeats.
    //it does not aim higher than thetaMax
    //(where theta= 0 is down)
    straightJump = random(straightJumpMin,straightJumpMax);
  }
  
  void draw(){
    while(y2<height && (x2>0 && x2<width))
    {
      strokeWeight(1);
       
      theta += randomSign()*random(minDTheta, maxDTheta);
      if(theta>maxTheta)
        theta = maxTheta;
      if(theta<-maxTheta)
        theta = -maxTheta;
         
      straightJump = random(straightJumpMin,straightJumpMax);
      x2 = x1-straightJump*cos(theta-HALF_PI);
      y2 = y1-straightJump*sin(theta-HALF_PI);
       
      if(randomColors)
        myColor = slightlyRandomColor(myColor,straightJump);
       
      lineWidth = map(y2, height,y0, 1,lineWidth0);
      if(lineWidth<0)
        lineWidth = 0;
      stroke(215,181,232,255);
      strokeWeight(lineWidth);
      line(x1,y1,x2,y2);
      x1=x2;
      y1=y2;
       
      if(random(0,1)<childGenOdds){//if yes, have a baby!
        float newTheta = theta;
        newTheta += randomSign()*random(minDTheta, maxDTheta);
        if(theta>maxTheta)
          theta = maxTheta;
        if(theta<-maxTheta)
          theta = -maxTheta;
        (new lightningBolt(x2, y2, lineWidth, newTheta, straightJumpMin, straightJumpMax,boltColor)).draw();
        //it draws the whole limb before continuing.
      }
    }
  }
}
/*  =====================================================================================================  */
