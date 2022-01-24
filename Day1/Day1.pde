// Prompt: Draw 10,000 of something

import java.util.*;

int desiredCircles = 10000;
int circlesPerFrame = 1000;
int maxTries = 1000;
int maxDist;
float maxRadius = 100;
PVector center;
float angle = 0;

List<Circle> circles = new ArrayList<Circle>();

void setup() {
  size(displayWidth, displayHeight);
  maxDist = Math.min(displayWidth, displayHeight) / 2;
  center = new PVector(displayWidth/2, displayHeight/2);
  
  for (int i = 0; i < desiredCircles; i++) {
    for (int j = 0; j < maxTries; j++) {
      float dist = random(maxDist);
      float angle = random(360);
      PVector point = new PVector(dist, 0);
      
      double rotatedX = point.x * Math.cos(angle) - point.y * Math.sin(angle);
      double rotatedY = point.x * Math.sin(angle) + point.y * Math.cos(angle);
      
      int centeredX = (int)(rotatedX + center.x);
      int centeredY = (int)(rotatedY + center.y);
      
      float radius = random(8, maxRadius);
      
      boolean validPlacement = true;
      for (Circle cir : circles) {
         if (dist(cir.coord.x, cir.coord.y, centeredX, centeredY) < radius/2 + cir.radius/2) {
           validPlacement = false;
           break;
         }
      }
      if (validPlacement) {
        circles.add(new Circle(centeredX, centeredY, radius));
        break;
      } 
    }
  }
}
 //<>//


void draw() {
  push();
  stroke(0);
  fill(0);
  rect(0,0,displayWidth, displayHeight);
  angle += 0.001;
  translate(displayWidth/2, displayHeight/2);
  rotate(angle);
  for (Circle cir : circles) {
    cir.show();  
  }
  pop();
}

private class Circle {
  PVector coord;
  float radius;
  float angle;
  float rotationRate;
  color col;
  boolean doFill;
  
  public Circle(int x, int y, float radius) {
    this.coord = new PVector(x, y);
    this.radius = radius;
    this.doFill = radius > 40;
    this.angle = random(360);
    this.rotationRate = random(1);
    this.col = color(random(255),random(255),random(255));
  }
  
  public void show() {
    nudgeParameters();
    
    if (this.radius > 40) {
      noFill();  
    } else {
      fill(this.col);
    }
    
    stroke(this.col);
    strokeWeight(2);
    push();
    translate(this.coord.x - displayWidth/2, this.coord.y - displayHeight/2);
    rotate(this.angle);
    rect(-this.radius/2, -this.radius/2, this.radius, this.radius,20,20,20,20);
    pop();
  }
  
  private void nudgeParameters() {
    float adjustment = random(1) - 0.5;
    this.radius += adjustment;
    this.coord.x += adjustment;
    this.coord.y += adjustment;
    this.angle = lerp(this.angle, this.angle + this.rotationRate, 0.03);
    
    //this.col = color(red(this.col) + adjustment + 0.1, green(this.col) + adjustment + 0.1, blue(this.col) + adjustment + 0.1);
  }
}
