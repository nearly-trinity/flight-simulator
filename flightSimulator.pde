import java.util.*;
import toxi.geom.Vec3D;
PImage space;
PShape environment;
Vec3D loc, dir, up;
Set<Character> movements = new HashSet<Character>();
boolean locked = false;

void setup() {
  size(800,800,P3D);
  space = loadImage("stars.jpg");
  environment = createShape(SPHERE,width*4);
  environment.setTexture(space);
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
    box(100);
    translate(100,-75,-200);
    fill(50,255,50);
    sphere(60);
    translate(-200, 125, 100);
    fill(255,75,100);
    box(40);
  popMatrix();
  
  pushMatrix();
  translate(loc.x, loc.y, loc.z);
  shape(environment);
  popMatrix();
  
  pushMatrix();
    resetMatrix();
    noFill();
    if(locked) stroke(255,0,0);
    else stroke(255);
    ortho();
    rectMode(CORNERS);
    rect(-buffer,-buffer,buffer,buffer);
  popMatrix();
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
