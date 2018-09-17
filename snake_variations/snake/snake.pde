int scale = 20;
int w, h, score, highScore;

Snake s;
PVector food;

void setup() {
  size(600, 600);
  frameRate(12);
  noStroke();

  w = width / scale;
  h = height/ scale;

  s = new Snake(w/2, h/2);
  s.right();

  food = prepare();
}

void draw() {
  background(25);
  s.update(w-1, h-1);
  if (s.eat(food)) {
    food = prepare();
    score++;
    if (score > highScore) {
      highScore = score;
    }
  }
  textSize(200);
  fill(255, 255, 255, 25);
  textAlign(CENTER, CENTER);
  text(highScore, width/2, height/2);
  s.draw();

  fill(244, 217, 66);
  rect(food.x*scale, food.y*scale, scale, scale);
}

void keyPressed() {
  if (key == 'w' || keyCode == UP) {    
    s.up();
    return;
  }
  if (key == 'a' || keyCode == LEFT) {
    s.left();
    return;
  }
  if (key == 's' || keyCode == DOWN) {
    s.down();
    return;
  }
  if (key == 'd' || keyCode == RIGHT) {
    s.right();
    return;
  }
  if (s.dead && keyCode == ENTER || keyCode == RETURN) {
    score = 0;
    s.reset(w/2, h/2);
  }
}

PVector prepare() {
  return new PVector(floor(random(w)), floor(random(h)));
}

class Snake {
  class Part {
    PVector pos;
    Part next;

    Part(PVector pos, Part next) {
      this.pos = pos;
      this.next = next;
    }
  }

  PVector vel;
  boolean dead;
  Part head;

  Snake(int x, int y) {
    reset(x, y);
  }

  void reset(int x, int y) {
    vel  = new PVector(1, 0);
    dead = false;
    head = new Part(new PVector(x, y), new Part(new PVector(x-1, y), null));
  }

  void update(int maxX, int maxY) {
    if (dead) {
      return;
    }

    // out of bounds?
    PVector pos = head.pos.copy().add(vel);
    if (pos.x < 0 || pos.x > maxX || pos.y < 0 || pos.y > maxY) {
      dead = true;
      return;
    }

    // collide with self?
    Part p = head;
    while (p != null) {
      if (p.next != null && p.next.next == null) {
        // remove last segment
        p.next = null;
      }
      if (pos.x == p.pos.x && pos.y == p.pos.y) {
        dead = true;
        return;
      }
      p = p.next;
    }

    // update head
    head = new Part(pos, head);
  }

  void draw() {
    fill(200);
    if (dead) {
      fill(200, 0, 0);
    }
    Part p = head;
    while (p != null) {
      rect(p.pos.x*scale, p.pos.y*scale, scale, scale);
      p = p.next;
    }
  }

  boolean eat(PVector food) {
    if (food.x == head.pos.x && food.y == head.pos.y) {
      Part p = head;
      while (p != null && p.next != null) { 
        p = p.next;
      }
      p.next = new Part(food, null);
      return true;
    }
    return false;
  }

  void right() {
    vel = new PVector(1, 0);
  }

  void left() {
    vel = new PVector(-1, 0);
  }

  void down() {
    vel = new PVector(0, 1);
  }

  void up() {
    vel = new PVector(0, -1);
  }
}
