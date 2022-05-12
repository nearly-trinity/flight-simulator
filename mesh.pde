class Mesh3D {
  ArrayList<PVector> verts;
  ArrayList<PVector> uvs;
  ArrayList<PVector> norms;
  ArrayList<int[]> tris;
  PImage img2;

  Mesh3D() {
    verts = new ArrayList<PVector> ();
    uvs = new ArrayList<PVector> ();
    norms = new ArrayList<PVector> ();
    tris = new ArrayList<int[]> ();
  }

  BSPTree toBSPTree() {
    BSPTree tree = new BSPTree();
    //java.util.Collections.shuffle(tris);
    for (int[] tri : tris) {
      tree.add(new MyTri(verts.get(tri[0]), verts.get(tri[1]), verts.get(tri[2])));
    }
    return tree;
  }

  void display() {
    beginShape(TRIANGLES);
    for (int[] tri : tris) {
      triangleHelper(tri);
    }
    endShape();
  }

  void display(PImage img) {
    img2 = img;
    beginShape(TRIANGLES);
    textureMode(IMAGE);
    texture(img);
    for (int[] tri : tris) {
      //triangleHelper(tri);
      normTriangleHelper(tri);
    }
    endShape();
  }
  private void normTriangleHelper(int[] tri) {
    normalHelper(tri[0]);
    vertexHelper(tri[0]);
    normalHelper(tri[1]);
    vertexHelper(tri[1]);
    normalHelper(tri[2]);
    vertexHelper(tri[2]);
  }
  
  private void normalHelper(int i) {
    PVector n = norms.get(i);
    normal(n.x,n.y,n.z);
  }
  private void triangleHelper(int[] tri) {
    vertexHelper(tri[0]);
    vertexHelper(tri[1]);
    vertexHelper(tri[2]);
  }

  private void vertexHelper(int i) {
    PVector v = verts.get(i);
    vertex(v.x, v.y, v.z);
  }

  private void triangleHelperTexture(int[] tri) {
    vertexHelperTexture(tri[0]);
    vertexHelperTexture(tri[1]);
    vertexHelperTexture(tri[2]);
  }

  private void vertexHelperTexture(int i) {
    PVector v = verts.get(i);
    vertex(v.x, v.y, v.z, 1, 1);
  }

  Mesh3D intersect(Mesh3D other) {
    BSPTree atree = this.toBSPTree();
    BSPTree btree = other.toBSPTree();
    return (atree.intersection(btree));
  }
  Mesh3D difference(Mesh3D other) {
    BSPTree atree = this.toBSPTree();
    BSPTree btree = other.toBSPTree();
    return (atree.difference(btree));
  }
  Mesh3D union(Mesh3D other) {
    BSPTree atree = this.toBSPTree();
    BSPTree btree = other.toBSPTree();
    return (atree.union(btree));
  }
}
