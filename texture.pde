class TextureSphere {
  int nSegs;
  float r;
  PImage img;
  
  TextureSphere(float radius, int numSegments, PImage texture) {
    nSegs = numSegments;
    r = radius;
    img = texture;
  }
  
  void display() {
    float uStep = 2*PI/nSegs;
    float vStep = PI/nSegs;
    
    beginShape(QUADS);
    texture(img);
    for(float u=0; u<2*PI; u+=uStep) {
      for(float v=-PI/2; v<PI/2; v+=vStep) {
        createVertex(u,v);
        createVertex(u+uStep,v);
        createVertex(u+uStep,v+vStep);
        createVertex(u,v+vStep);
        
      }
    }
    endShape();
    
    pushMatrix();
    beginShape(QUADS);
    texture(img);
    translate(-27,-15,0);
    rotateX(0.9);
    rotateY(-2.8);
    for(float u=0; u<1.5*PI; u+=uStep) {
      for(float v=-PI/4; v<PI/4; v+=vStep) {
        createVertex(u,v);
        createVertex(u+uStep,v);
        createVertex(u+uStep,v+vStep);
        createVertex(u,v+vStep);      
      }
    }
    endShape();
    popMatrix();
    
    pushMatrix();
    beginShape(QUADS);
    texture(img);
    translate(25,27,0);
    rotateX(-2.0);
    rotateY(5.6);
    for(float u=0; u<1.5*PI; u+=uStep) {
      for(float v=-PI/4; v<PI/4; v+=vStep) {
        createVertex(u,v);
        createVertex(u+uStep,v);
        createVertex(u+uStep,v+vStep);
        createVertex(u,v+vStep);      
      }
    }
    endShape();
    popMatrix();
  }
  
  void createVertex(float u, float v) {
    float x = xpos(u,v);
    float y = ypos(u,v);
    float z = zpos(u,v);
    PVector norm = new PVector(x,y,z);
    norm.normalize();
    normal(-norm.x,-norm.y,-norm.z);
    strokeWeight(1);
    stroke(map(u,0,2*PI,0,255),map(v,-PI,PI,0,255),0);
    //line(0,0,0, -100*norm.x, -100*norm.y, -100*norm.z);
    noStroke();
    vertex(x,y,z, map(u, 0,2*PI, img.width,0), map(v, -PI/2,PI/2, 0,img.height));
  }
  
  float xpos(float u, float v) {
    return r * sin(u) * cos(v);
  }
  float ypos(float u, float v) {
    return r * cos(u) * cos(v);
  }
  float zpos(float u, float v) {
    return r * sin(v);
  }
  
}
