// Day3 Prompt: Space

import java.util.*;

int planetCount = 6;
List<Planet> planets = new ArrayList<Planet>();
List<Star> stars = new ArrayList<Star>();
Sun sun;
float angle = 0;
int numStars = 1000;

void setup() {
  size(displayWidth, displayHeight);
  sun = new Sun(random(60, 100));
  
  for (int i = 0; i < planetCount; i++) {
      CelestialBody followTarget = i == 0 ? sun : planets.get(i - 1);
      planets.add(new Planet(80 * (i + 1) + (60 * (random(1) - 0.5)), (int) random(5, 25), sun, random(0.05, 0.2), followTarget, random(1)));
  }
  
  for (int i = 0; i < numStars; i++) {
      stars.add(new Star(random(displayWidth), random(displayHeight)));
  }
}

void draw() {
  System.out.println(frameRate);
  fill(0);
  rect(0, 0, displayWidth, displayHeight);
  for (Star star : stars) {
    star.show();
  }
  push();
  angle += 0.001;
  translate(displayWidth/2, displayHeight/2);
  rotate(angle);
  
  sun.show();
  for (Planet planet : planets) {
    planet.show(); 
  }
  pop();
}

public interface CelestialBody {
  public void show();
  public PVector getPos();
}

public class Sun implements CelestialBody {
   PVector pos;
   float radius;
   color col;
   
   public Sun(float radius) {
      this.pos = new PVector(0.0, 0.0);
      this.radius = radius;
      this.col = color(random(255),random(255),random(255));
   }
   
   public PVector getPos() {
     return this.pos;    
   }
   
   public void show() {
     this.pos.x += sin(frameCount/200.0)/3;
     //this.pos.y -= cos(frameCount/300)/3;
     
     
     push();
     translate(this.pos.x, this.pos.y);
     noStroke();
     fill(this.col);
     circle(0, 0, this.radius);
     pop();
   }
}

public class Planet implements CelestialBody {

  float orbitRadius;
  float orbitHeight;
  int planetRadius;
  PVector pos;
  color col;
  color col2;
  Sun sun;
  float angle = 0;
  float orbitSpeed;
  float orbitAngle;
  CelestialBody followTarget;
  PVector orbitalPos;
  float planetAngle = 0;
  float planetRotateSpeed;
  
  public Planet(float orbitRadius, int planetRadius, Sun sun, float orbitSpeed, CelestialBody followTarget, float planetRotateSpeed) {
    this.orbitRadius = orbitRadius; 
    this.orbitHeight = orbitRadius + (orbitRadius / 3 * (random(1) - 0.5));
    this.planetRadius = planetRadius;
    this.pos = new PVector(orbitRadius, 0);
    this.col = color(random(255),random(255),random(255));
    this.col2 = color(random(255),random(255),random(255));
    this.sun = sun;
    this.orbitSpeed = orbitSpeed;
    this.orbitAngle = random(360);
    this.followTarget = followTarget;
    this.orbitalPos = new PVector(followTarget.getPos().x, followTarget.getPos().y);
    this.planetRotateSpeed = planetRotateSpeed;
  }
  
  public PVector getPos() {
    return this.orbitalPos;
  }
  
  public void show() {
     this.orbitalPos.x = lerp(this.orbitalPos.x, this.followTarget.getPos().x, 0.01);
     this.orbitalPos.y = lerp(this.orbitalPos.y, this.followTarget.getPos().y, 0.01);
     
     //Draw Orbital Path
     push();
     noFill();
     stroke(this.col);
     strokeWeight(3);
     translate(this.orbitalPos.x, this.orbitalPos.y);
     rotate(this.orbitAngle);
     ellipse(0, 0, this.orbitRadius*2, this.orbitHeight*2);
     pop();
     
     //Move Planet
     this.angle += this.orbitSpeed * 0.01;
     this.pos.x = this.orbitRadius * cos(this.angle);
     this.pos.y = this.orbitHeight * sin(this.angle);
    
     //Draw Planet
     push();
     translate(this.orbitalPos.x, this.orbitalPos.y);
     rotate(this.orbitAngle);
     translate(this.pos.x, this.pos.y);
     noStroke();
     fill(this.col);
     circle(0, 0, this.planetRadius);
     //drawPlanet();
     pop();
  }
  
  private void drawPlanet() {
    push();
    this.planetAngle += this.planetRotateSpeed * 0.05;
    rotate(this.planetAngle);
    for (int x = -this.planetRadius; x < this.planetRadius; x++) {
      for (int y = -this.planetRadius; y < this.planetRadius; y++) {
        if (dist(x, y, 0, 0) > this.planetRadius) {
          continue;
        }
        float noi = noise((x + this.planetRadius) * 0.5, (y + this.planetRadius) * 0.5);
        stroke(lerpColor(this.col, this.col2, noi));
        point(x,y);
      }
    }
    noFill();
    stroke(this.col);
    circle(0, 0, this.planetRadius * 2);
    pop();
  }
  
}

public class Star {
    PVector pos;
    float startSeed;
    public Star(float x, float y) {
        this.pos = new PVector(x, y);
        this.startSeed = random(1000);
    }
    
    public void show() {
      stroke(200 * (abs(sin((frameCount + this.startSeed)/75.0))));
      strokeWeight(2);
      point(this.pos.x, this.pos.y);  
    }
    
  }
  
public class ShootingStar {
  PVector pos;
  PVector previousPos;
  float angle;
  float speed;
  float radius;
  
  public ShootingStar(float x, float y, float angle, float speed) {
    this.pos = new PVector(x, y);
    this.previousPos = new PVector(x, y);
    this.angle = angle;
    this.speed = speed;
    this.radius = 3;
  }
  
  public boolean outOfBounds() {
    return this.pos.x < displayWidth - 100 || this.pos.x > displayWidth + 100 || this.pos.y < displayHeight - 100 || this.pos.y > displayHeight + 100;
  }
  
  public void show() {
    noStroke();
    fill(255);
    circle(this.pos.x, this.pos.y, 3);
  }
  
}
