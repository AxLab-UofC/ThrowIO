//visual display for ufo application TODO: consider how to intergrate basketball here as well
public class SecondApplet extends PApplet {

  //an ArrayList of particles that will fall on the surface
  ArrayList<Particle> particles;

  //a list we'll use to track fixed objects
  ArrayList<Boundary> boundaries;

  ArrayList<smallParticle> smallParticles;
  ArrayList<smallSelfParticle> smallSelfParticles;

  class Boundary {

    //a boundary is a simple rectangle with x,y,width, and height
    float x;
    float y;
    float w;
    float h;
    //but we also have to make a body for box2d to know about it
    Body b;

    Boundary(float x_, float y_, float w_, float h_, float a) {
      x = x_;
      y = y_;
      w = w_;
      h = h_;

      // Define the polygon
      PolygonShape sd = new PolygonShape();
      // Figure out the box2d coordinates
      float box2dW = box2d.scalarPixelsToWorld(w/2);
      float box2dH = box2d.scalarPixelsToWorld(h/2);
      // We're just a box
      sd.setAsBox(box2dW, box2dH);

      // Create the body
      BodyDef bd = new BodyDef();
      bd.type = BodyType.STATIC;
      bd.angle = a;
      bd.position.set(box2d.coordPixelsToWorld(x, y));
      b = box2d.createBody(bd);

      // Attached the shape to the body using a Fixture
      b.createFixture(sd, 1);
    }

    // Draw the boundary, it doesn't move so we don't have to ask the Body for location
    void display() {
      fill(0);
      stroke(0);
      strokeWeight(1);
      rectMode(CENTER);
      float a = b.getAngle();
      pushMatrix();
      translate(x, y);
      rotate(-a);
      rect(0, 0, w, h);
      popMatrix();
    }
  }

  //particle class is the ball that show up in our monitor
  class Particle {

    // We need to keep track of a Body and a radius
    Body body;
    float r;
    color col;

    Particle(float x, float y, float r_, float l, float v) { //x will be x velocity and y will be z velocity
      r = r_;
      // This function puts the particle in the Box2d world
      makeBody(x, y, r, l, v);
      body.setUserData(this);
      col = color(204, 102, 0);
    }

    // This function removes the particle from the box2d world
    void killBody() {
      box2d.destroyBody(body);
    }

    // Change color when hit
    void change() {
      col = color(255, 0, 0);
    }

    // Is the particle ready for deletion?
    boolean done() {

      // Let's find the screen position of the particle
      Vec2 pos = box2d.getBodyPixelCoord(body);
      // Is it off the bottom of the screen?
      if (pos.y > height+r*2) {
        killBody();
        return true;
      } else if (pos.y < monitorHeight/5) {

        //this is when you did not hit the UFO
        ufo_flag_startSelfCrash = true;
        bulletx = pos.x;
        bullety = pos.y;
        killBody();
        return true;
        
      } else if (abs(pos.x - xcoord) < 80 && abs(pos.y - ycoord) < 80 && !ufo_flag_killUFO) {

        //this is when you hit the UFO
        ufo_instruction = "Good job! Next ball!";
        ufo_flag_bombSound = true;
        ufo_flag_killUFO = true;
        ufo_flag_startCrash = true;
        scoreCount+=1;

        killBody();
        
        return true;
      } else if (ufo_flag_killBall == true){
        
        killBody();
        return true;
        
      }

      return false;
    }

    //check if a ball went into the hoop
    boolean goal() {
      // Let's find the screen position of the particle
      Vec2 pos = box2d.getBodyPixelCoord(body);
      if (pos.y > 350 && pos.y <= 550 && pos.x >= 450 && pos.x <= 750) { //this is the condition for scoring
        return true;
      }
      return false;
    }

    void display() {
      // We look at each body and get its screen position
      Vec2 pos = box2d.getBodyPixelCoord(body);
      // Get its angle of rotation
      float a = body.getAngle();
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(a);
      fill(col);
      stroke(0);
      strokeWeight(1);
      ellipse(0, 0, r*2, r*2);
      // Let's add a line so we can see the rotation
      //line(0, 0, r, 0);
      popMatrix();
    }

    // Here's our function that adds the particle to the Box2D world
    // x is x position, y is y position, r is radius, l is linear velocity, v is vertical velocity
    //x = 400, y = 720, r , l = 15, v = 95
    void makeBody(float x, float y, float r, float l, float v) {
      // Define a body
      BodyDef bd = new BodyDef();
      // Set its position

      bd.position = box2d.coordPixelsToWorld(x, y); //monitor is 720 height and 1280 width
      bd.type = BodyType.DYNAMIC;
      body = box2d.createBody(bd);

      // Make the body's shape a circle
      CircleShape cs = new CircleShape();
      cs.m_radius = box2d.scalarPixelsToWorld(r);

      FixtureDef fd = new FixtureDef();
      fd.shape = cs;
      // Parameters that affect physics
      fd.density = 1;
      fd.friction = 0.01;
      fd.restitution = 0.3;

      // Attach fixture to body
      body.createFixture(fd);

      MassData massData = new MassData();
      massData.mass = 1000;
      //body.setAngularVelocity(random(-10, 10));
      body.setLinearVelocity(new Vec2(l, v));
      body.setMassData(massData);
    }
  }

  class smallParticle {

    // We need to keep track of a Body and a radius
    Body body2;
    float r;
    color col;

    smallParticle(float x, float y, float r_, color col_) {
      r = r_;
      col = col_;
      // This function puts the particle in the Box2d world
      makeBody(x, y, r);
    }

    // This function removes the particle from the box2d world
    void killBody() {
      box2d.destroyBody(body2);
    }

    // Is the particle ready for deletion?
    boolean done() {
      // Let's find the screen position of the particle
      Vec2 pos = box2d.getBodyPixelCoord(body2);
      // Is it off the bottom of the screen?

      if (pos.y > monitorHeight/3) {
        killBody();
        return true;
      }
      return false;
    }

    //
    void display() {
      // We look at each body and get its screen position
      Vec2 pos = box2d.getBodyPixelCoord(body2);
      // Get its angle of rotation
      float a = body2.getAngle();
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(-a);
      fill(col);
      stroke(0);
      strokeWeight(1);
      ellipse(0, 0, r*2, r*2);
      // Let's add a line so we can see the rotation
      //line(0,0,r,0);
      popMatrix();
    }

    // Here's our function that adds the particle to the Box2D world
    void makeBody(float x, float y, float r) {
      // Define a body
      BodyDef bd2 = new BodyDef();
      // Set its position
      bd2.position = box2d.coordPixelsToWorld(x, y);
      bd2.type = BodyType.DYNAMIC;
      body2 = box2d.world.createBody(bd2);

      // Make the body's shape a circle
      CircleShape cs = new CircleShape();
      cs.m_radius = box2d.scalarPixelsToWorld(r);

      FixtureDef fd = new FixtureDef();
      fd.shape = cs;
      // Parameters that affect physics
      fd.density = 1;
      fd.friction = 0.01;
      fd.restitution = 0.3;

      // Attach fixture to body
      body2.createFixture(fd);

      // Give it a random initial velocity (and angular velocity)
      body2.setLinearVelocity(new Vec2(random(-10f, 10f), random(5f, 10f)));
      body2.setAngularVelocity(random(-10, 10));
    }
  }

  class smallSelfParticle {

    // We need to keep track of a Body and a radius
    Body body3;
    float r;
    color col;

    smallSelfParticle(float x, float y, float r_, color col_) {
      r = r_;
      col = col_;
      // This function puts the particle in the Box2d world
      makeBody(x, y, r);
    }

    // This function removes the particle from the box2d world
    void killBody() {
      box2d.destroyBody(body3);
    }

    // Is the particle ready for deletion?
    boolean done() {
      // Let's find the screen position of the particle
      Vec2 pos = box2d.getBodyPixelCoord(body3);
      // Is it off the bottom of the screen?

      if (pos.y > monitorHeight/4) {
        killBody();
        return true;
      }

      return false;
    }

    //
    void display() {
      // We look at each body and get its screen position
      Vec2 pos = box2d.getBodyPixelCoord(body3);
      // Get its angle of rotation
      float a = body3.getAngle();
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(-a);
      fill(col);
      stroke(0);
      strokeWeight(1);
      ellipse(0, 0, r*2, r*2);
      // Let's add a line so we can see the rotation
      //line(0,0,r,0);
      popMatrix();
    }

    // Here's our function that adds the particle to the Box2D world
    void makeBody(float x, float y, float r) {
      // Define a body
      BodyDef bd3 = new BodyDef();
      // Set its position
      bd3.position = box2d.coordPixelsToWorld(x, y);
      bd3.type = BodyType.DYNAMIC;
      body3 = box2d.world.createBody(bd3);

      // Make the body's shape a circle
      CircleShape cs = new CircleShape();
      cs.m_radius = box2d.scalarPixelsToWorld(r);

      FixtureDef fd = new FixtureDef();
      fd.shape = cs;
      // Parameters that affect physics
      fd.density = 1;
      fd.friction = 0.01;
      fd.restitution = 0.3;

      // Attach fixture to body
      body3.createFixture(fd);

      // Give it a random initial velocity (and angular velocity)
      body3.setLinearVelocity(new Vec2(random(-10f, 10f), random(5f, 10f)));
      body3.setAngularVelocity(random(-10, 10));
    }
  }

  public void settings() {

    fullScreen(2);
    //size(1000,800);
    monitorWidth = displayWidth;
    monitorHeight = displayHeight;

    particles = new ArrayList<Particle>();
    boundaries = new ArrayList<Boundary>();
    smallParticles = new ArrayList<smallParticle>();
    smallSelfParticles = new ArrayList<smallSelfParticle>();

    //this is the boundaries I made in the box2D world
    boundaries.add(new Boundary(monitorWidth-20, monitorHeight-100, 20, 200, 9.8));
    boundaries.add(new Boundary(monitorWidth-140, monitorHeight-50, 20, 200, 9.8));
  }

  public void draw() {
    box2d.step(); //step through time in box2d
    background(203, 235, 255);

    noStroke();
    fill(255);

    //cloud one
    ellipse (1530-600, 395, 50, 40);
    ellipse (1510-600, 405, 50, 40);
    ellipse (1460-600, 395, 50, 40);
    ellipse (1480-600, 405, 50, 40);
    ellipse (1470-600, 385, 50, 40);
    ellipse (1510-600, 385, 50, 40);
    ellipse (1490-600, 380, 50, 40);

    //cloud two
    ellipse (1530-1000, 395-220, 50, 40);
    ellipse (1510-1000, 405-220, 50, 40);
    ellipse (1460-1000, 395-220, 50, 40);
    ellipse (1480-1000, 405-220, 50, 40);
    ellipse (1470-1000, 385-220, 50, 40);
    ellipse (1510-1000, 385-220, 50, 40);
    ellipse (1490-1000, 380-220, 50, 40);

    //cloud three
    ellipse (1530-1400, 395+100, 50, 40);
    ellipse (1510-1400, 405+100, 50, 40);
    ellipse (1460-1400, 395+100, 50, 40);
    ellipse (1480-1400, 405+100, 50, 40);
    ellipse (1470-1400, 385+100, 50, 40);
    ellipse (1510-1400, 385+100, 50, 40);
    ellipse (1490-1400, 380+100, 50, 40);


    textSize(75);
    fill(0);
    text(ufo_instruction, 40, 150);

    xcoord += xSpeed;

    if ((xcoord > 1000) || (xcoord < 500)) {
      xSpeed *=-1;
    }

    //UFO
    if (ufo_flag_killUFO == false) {

      stroke(0);
      strokeWeight(1);
      fill(255);
      ellipse(xcoord, ycoord-25, 80, 100);

      noStroke();
      fill(0);
      ellipse(xcoord, ycoord, 150, 60);

      noStroke();
      fill(255);
      ellipse(xcoord, ycoord-23, 80, 15);
    }

    if (ufo_flag_bombSound == true) {

      ufo_file.play();
      ufo_flag_bombSound = false;
    }


    //the text for score
    textSize(75);
    fill(0);
    text("Score: "+str(scoreCount), 40, 60);



    if (ufo_flag_startSprinkle == false) {

      //this is the list of particles add into the world
      //particles.add(new Particle(570, 200, 40, 0, 0));
      //particles.add(new Particle(500, 250, 40, 0, 0));
      //particles.add(new Particle(600, 100, 40, 0, 0));
      //particles.add(new Particle(700, 300, 40, 0, 0));
      //particles.add(new Particle(600, 350, 40, 0, 0));

      ufo_flag_startSprinkle = true;
    }

    if (ufo_flag_startCrash == true) {
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));

      ufo_flag_startCrash = false;
    }

    if (ufo_flag_startSelfCrash == true) {

      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));

      ufo_flag_startSelfCrash = false;
    }

    // Display all the boundaries
    for (Boundary wall : boundaries) {
      wall.display();
    }

    //we add a new ball when ufo_flag_nextBall flag is true
    if (ufo_flag_nextBall == true) {
      particles.add(new Particle(monitorWidth-50, monitorHeight, 40, -25, 65)); //this is the ball that drops from the tube
      ufo_flag_nextBall = false;
    }


    //display ball
    if (ufo_flag_hitTarget == true) {

      if (ufo_flag_addParticle == false) {

        //particles.add(new Particle(random(330, 360), 720, 40, random(10, 11), random(120, 140))); //this is where we currently define the ball speed and velocity

        //if (avgXVelocity > 0) {
        //  particles.add(new Particle(hitX, monitorHeight, 40, random(10, 11), random(65, 70))); //this is where we currently define the ball speed and velocity //random(120, 140)
        //} else {
        //  particles.add(new Particle(hitX, monitorHeight, 40, -random(10, 11), random(65, 70))); //this is where we currently define the ball speed and velocity //random(120, 140)
        //}

        particles.add(new Particle(hitX, monitorHeight, 40, -random(10, 11), 95));
        
        ufo_flag_addParticle = true;
      }
    }

    //scoreCount = 0;

    //display debris
    for (int i = smallParticles.size()-1; i >= 0; i--) {
      smallParticle p = smallParticles.get(i);
      p.display();
      if (p.done()) {
        smallParticles.remove(i);
      }
    }

    //display bullet debirs
    for (int i = smallSelfParticles.size()-1; i >= 0; i--) {
      smallSelfParticle p = smallSelfParticles.get(i);
      p.display();
      if (p.done()) {
        smallSelfParticles.remove(i);
      }
    }

    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.display();
      // Particles that leave the screen, we delete them
      // (note they have to be deleted from both the box2d world and our list
      if (p.done()) {
        particles.remove(i);
        ufo_flag_hitTarget = false;
        ufo_flag_addParticle = false;
        
        if(ufo_flag_killBall == true){
            ufo_flag_killBall = false;
        }
      }
      //if (p.goal()) {
      //  scoreCount += 1;
      //}
    }
  };
}
