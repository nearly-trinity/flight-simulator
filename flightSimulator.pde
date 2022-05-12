import java.util.*;
import toxi.geom.Vec3D;
PImage space, saturn, neptune, mars, cyber;
PShape environment;
Vec3D loc, dir, up;
Set<Character> movements = new HashSet<Character>();
boolean locked = false;
TextureSphere ts, es;
TextureCyl cyl;
//this one

void setup() {
  size(800,800,P3D);
  space = loadImage("space.png");
  saturn = loadImage("saturn.jpg");
  neptune = loadImage("neptune.jpg");
  mars = loadImage("mars.jpg");
  cyber = loadImage("cyber.jpg");
  noStroke();
  environment = createShape(SPHERE,width*3.5);
  environment.setTexture(space);
  stroke(0);
  es = new TextureSphere(width*4, 20, space);
  loc = new Vec3D(width/2,height/2,-400);
  dir = new Vec3D(0,0,1);  
  up  = new Vec3D(0,1,0);
  
  //sound:::
  minim = new Minim(this);
  out = minim.getLineOut();
 
  wave = new Oscil( 260, 0.5f, Waves.SINE );
  wave2= new Oscil( 200, 0.5f, Waves.SINE );
  wave3= new Oscil( 180, 0.5f, Waves.SINE );

  wave.patch( out );
  wave2.patch( out );
  wave3.patch(out);

  wave2.setAmplitude(.2);
}

void draw() {
  strokeWeight(1);
  fill(255);
  
  if(!locked) rollAndYaw();
  doMovement();
  setCamera();
  perspective(PI/3.0, width/height, 0.01, 10000);
  ambientLight(100,100,100);
  pushMatrix();
  
  
    translate(width/2, height/2);
    background(0);
    stroke(0);
    fill(50,50,255);
    //box(100);
    translate(120,-80,-67);
    fill(225,218,111);
    //box(100);
    translate(120,-80,-67);
    fill(225,218,112);
    //setTexture(neptune);
    ts = new TextureSphere(51.0, 20, cyber);
      ts.display();
    //sphere(51);
    //translate(-200, 125, 100);
    //fill(255,75,100);
    //box(40);
    
    fill(225,218,112);
    rotateX(8.0);
    stroke(1);
    //drawCylinder(32,110,29);
    
    translate(-159,716,-251);
    
    Sphere oneSphere = new Sphere(new PVector(0, -80, 32), 70, 12);
    Sphere twoSphere = new Sphere(new PVector(-5, -60, 1), 70, 12);
    Sphere threeSphere = new Sphere(new PVector(-5, -40, 33), 70, 12);
    
    Mesh3D sphereDiff = oneSphere.union(twoSphere);
    Mesh3D sphereDiff2 = sphereDiff.union(threeSphere);
    
    sphereDiff2.display(mars);
    stroke(1);
    //visSphere.display();
    //inviSphere.display();
    
  popMatrix();
  
  pushMatrix();
  translate(100,100,100);
  cyl = new TextureCyl (100,25, cyber);
  //cyl.display();
  popMatrix();
  
  pushMatrix();
  noStroke();
  translate(loc.x, loc.y, loc.z);
  shape(environment);
  //es.display();
  popMatrix();
  
  pushMatrix();
    resetMatrix();
    noFill();
    if(locked) stroke(255,0,0);
    else stroke(255);
    ortho();
    rectMode(CORNERS);
    rect(-300,-300,300,300);
  popMatrix();
}

void drawCylinder(int sides, float r, float h)
{
    
  
    float angle = 360 / sides;
    float halfHeight = h / 2;
    // draw top shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, -halfHeight );    
    }
    endShape(CLOSE);
    // draw bottom shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight );    
    }
    endShape(CLOSE);
    // draw body
    beginShape(TRIANGLE_STRIP);  
      for (int i = 0; i < sides + 1; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      vertex( x, y, halfHeight);
      vertex( x, y, -halfHeight);    
    }
    endShape(CLOSE);
}

void doMovement() {
  for(Character c: movements) {
    switch(c) {
      case 'w':
        move(true);
        break;
      case 's':
        move(false);
        break;
      case 'a':
        turn(false);
        break;
      case 'd':
        turn(true);
        break;
      default: break;
    }
  }
}

void keyPressed() {
  if(key == 'l') {
    locked = !locked; 
  }
  if(key == ' ') {
    loc = new Vec3D(width/2,height/2,-400);
    dir = new Vec3D(0,0,1);  
    up  = new Vec3D(0,1,0);
  } else {
    movements.add(key);
  }
}
void keyReleased() {
  movements.remove(key); 
}

float turnFactor = 800f; // bigger -> slower roll/yaw 
float buffer = 20f;
void rollAndYaw() {
  if(mouseX>400+buffer||mouseX<400-buffer||mouseY>400+buffer||mouseY<400-buffer) {
    Vec3D axis = up.cross(dir);
    float dy = 400 - mouseY;
    float dx = 400 - mouseX;
    float thetaY = radians(dy)/turnFactor;
    float thetaX = radians(dx)/turnFactor;
    dir = dir.rotateAroundAxis(axis,thetaY).normalize();
    up  =  up.rotateAroundAxis(axis,thetaY).normalize()
             .rotateAroundAxis( dir,thetaX).normalize(); 
  }
}

void setCamera() {
  camera(loc.x,loc.y,loc.z, 
         loc.x+dir.x,loc.y+dir.y,loc.z+dir.z, 
         up.x,up.y,up.z); 
}

float turnSpeed = PI/200; // higher denominator slower turn
void turn(boolean clockwise) {
  if(!clockwise) { 
    dir = dir.rotateAroundAxis(up,turnSpeed);
  } else {
    dir = dir.rotateAroundAxis(up,-turnSpeed);
  }
}


float speed = 1f;
void move(boolean forward) {
  if(forward) {
    loc = loc.add(dir.scale(speed));
  } else {
    loc = loc.add(dir.scale(-speed));
  }
}
