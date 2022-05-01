// Day 5 Prompt: Destroy a Square

import java.util.*;

List<Polygon> polygons = new ArrayList<Polygon>();
float scalar = 6.0;
int sliceCounter = 0;
int sliceThreshold = 200;
int shiftCounter = 0;
int shiftThreshold = 100;
String mode = "slice";
float squareHeight;
void setup() {
  size(displayWidth, displayHeight);
  squareHeight = displayHeight/scalar;
  List<PVector> points = new ArrayList<PVector>();
  points.add(new PVector(-displayHeight / scalar, displayHeight / scalar));
  points.add(new PVector(displayHeight / scalar, displayHeight / scalar));
  points.add(new PVector(displayHeight / scalar, -displayHeight / scalar));
  points.add(new PVector(-displayHeight / scalar, -displayHeight / scalar));
  polygons.add(new Polygon(points));
}

void draw() {
  if (sliceCounter >= sliceThreshold) {
    slice();  
    for (Polygon polygon : polygons) {
     polygon.fracture(); 
    }
  }
  push();
  translate(displayWidth/2, displayHeight/2);
  for (Polygon polygon : polygons) {
     polygon.draw(); 
  }
  pop();
  if (mode == "slice") {
    sliceCounter++;  
  } else if (mode == "shift") {
    shiftCounter++;
  }
}

void slice() {
  float angle = random(0, 360);
  float shiftX = random(-squareHeight, squareHeight);
  float shiftY = random(-squareHeight, squareHeight);
  PVector point1 = new PVector(displayWidth/2, displayHeight)
  PVector point2 = new PVector(displayWidth/2, -displayHeight)
  for (Polygon polygon : polygons) {
    List<List<PVector>> lines = polygon.getLines();
    for (List<PVector> line : lines) {
      PVector intersectionPoint = getIntersectionPoint(point1, point2, line.get(0), line.get(1));
      if (intersectionPoint != null) {
        
      }
    }
  }
}

PVector getIntersectionPoint(PVector p1, PVector p2, PVector p3, PVector p4) {
  float slope1 = (p1.y - p2.y) / (p1.x - p2.x);
  float slope2 = (p3.y - p4.y) / (p3.x - p4.x);
  float yIntersect1 = p1.y - slope1 * p1.x;
  float yIntersect2 = p3.y - slope2 * p3.x;
  
  float x = (yIntersect2 - yIntersect1) / (slope1 - slope2);
  float y = slope1 * x + yIntersect1;
  
  float xMax = Math.max(p3.x, p4.x);
  float xMin = Math.min(p3.x, p4.x);
  float yMax = Math.max(p3.y, p4.y);
  float yMin = Math.min(p3.y, p4.y);
  
  if (x > xMin && x < xMax && y > yMin && y < yMax) {
    return new PVector(x, y);  
  }
  return null;
}

class Polygon {
  
  List<PVector> points;
  
  public Polygon(List<PVector> points) {
    this.points = points;
  }
  
  public List<List<PVector>> getLines() {
    List<List<PVector>> lines = new ArrayList<>();
    for (int i = 0; i < points.size(); i++) {
      PVector point = points.get(i);
      PVector other;
      if (i == points.size() - 1) {
        other = points.get(0);
      } else {
        other = points.get(i + 1);  
      }
      List<PVector> line = new ArrayList<>();
      line.add(point);
      line.add(other);
      lines.add(line);
    }
    return lines;
  }
  
  public void draw() {
    push();
    noFill();
    stroke(0);
    strokeWeight(3);
    for (int i = 0; i < points.size(); i++) {
      PVector point = points.get(i);
      PVector other;
      if (i == points.size() - 1) {
        other = points.get(0);
      } else {
        other = points.get(i + 1);  
      }
      line(point.x, point.y, other.x, other.y);
    }
    pop();
  }
  
  public void fracture() {
    
  }
}
