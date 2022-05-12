import java.util.*;
import toxi.geom.Vec3D;
PImage space, saturn, neptune, mars, cyber, earthImage, meteor;
PShape environment;
PShader shade, shade1;
Vec3D loc, dir, up;
Set<Character> movements = new HashSet<Character>();
boolean locked = false;
TextureSphere ts, es, earthModel;
TextureCyl cyl;
Mesh3D sphereUn2;

void setup() {
  size(800, 800, P3D);
  earthImage = loadImage("earth.jpg");
  space = loadImage("space.png");
  saturn = loadImage("saturn.jpg");
  neptune = loadImage("neptune.jpg");
  mars = loadImage("mars.jpg");
  cyber = loadImage("cyber.jpg");
  meteor = loadImage("meteor.jpg");
  noStroke();
  environment = createShape(SPHERE, width*3.5);
  environment.setTexture(space);
  loc = new Vec3D(width/2, height/2, -400);
  dir = new Vec3D(0, 0, 1);
  up  = new Vec3D(0, 1, 0);

  Sphere oneSphere = new Sphere(new PVector(0, -80, 32), 70, 12);
  Sphere twoSphere = new Sphere(new PVector(-5, -60, 1), 70, 12);
  Sphere threeSphere = new Sphere(new PVector(-5, -40, 33), 70, 12);

  Mesh3D sphereUn = oneSphere.union(twoSphere);
  sphereUn2 = sphereUn.union(threeSphere);

  earthModel = new TextureSphere(60, 10, earthImage);
  shade = loadShader("texfrag.glsl", "texvert.glsl");

  cyl = new TextureCyl(80.0, 20, cyber);

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
  shader(shade);

  if (!locked) rollAndYaw();
  doMovement();
  setCamera();
  perspective(PI/3.0, width/height, 0.01, 10000);
  ambientLight(100, 100, 100);



  pushMatrix();
  translate(width/2, height/2);
  background(0);
  noStroke();
  rotateX(-PI/2);
  earthModel.display();
  rotateX(PI/2);
  translate(120, -138, -67);
  fill(225, 218, 161);
  translate(234, -54, -79);
  fill(225, 218, 112);
  cyl.display();
  //fill(225,218,112);
  rotateX(8.0);
  translate(-111, 1501, 430);
  //sphereUn2.display(meteor);

  popMatrix();

  pushMatrix();
  noStroke();
  translate(loc.x, loc.y, loc.z);
  shape(environment);
  popMatrix();

  pushMatrix();
  resetMatrix();
  noFill();
  if (locked) stroke(255, 0, 0);
  else stroke(255);
  ortho();
  rectMode(CORNERS);
  rect(-buffer, -buffer, buffer, buffer);
  popMatrix();
}

void doMovement() {
  for (Character c : movements) {
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
    default:
      break;
    }
  }
}

void keyPressed() {
  if (key == 'l') {
    locked = !locked;
  }
  if (key == ' ') {
    loc = new Vec3D(width/2, height/2, -400);
    dir = new Vec3D(0, 0, 1);
    up  = new Vec3D(0, 1, 0);
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
  if (mouseX>400+buffer||mouseX<400-buffer||mouseY>400+buffer||mouseY<400-buffer) {
    Vec3D axis = up.cross(dir);
    float dy = 400 - mouseY;
    float dx = 400 - mouseX;
    float thetaY = radians(dy)/turnFactor;
    float thetaX = radians(dx)/turnFactor;
    dir = dir.rotateAroundAxis(axis, thetaY).normalize();
    up  =  up.rotateAroundAxis(axis, thetaY).normalize()
      .rotateAroundAxis( dir, thetaX).normalize();
  }
}

void setCamera() {
  camera(loc.x, loc.y, loc.z,
    loc.x+dir.x, loc.y+dir.y, loc.z+dir.z,
    up.x, up.y, up.z);
}

float turnSpeed = PI/200; // higher denominator slower turn
void turn(boolean clockwise) {
  if (!clockwise) {
    dir = dir.rotateAroundAxis(up, turnSpeed);
  } else {
    dir = dir.rotateAroundAxis(up, -turnSpeed);
  }
}


float speed = 1f;
void move(boolean forward) {
  if (forward) {
    loc = loc.add(dir.scale(speed));
  } else {
    loc = loc.add(dir.scale(-speed));
  }
}
