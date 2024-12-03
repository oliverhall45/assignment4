Platform platform;
Ball ball;
Brick[] bricks;
int rows = 3; // Number of brick rows
int cols =2; // Number of brick columns
boolean playing = true; // Game state
boolean win = false;
int score = 0; // Initializing the score

void setup() {
  size(400, 400); 
  
  
  platform = new Platform(); // Initializing the platform
  ball = new Ball(); // Initializing the ball
  bricks = new Brick[rows * cols]; // Initializing bricks array

  // Creating the brick wall with patterned colors
  int brickWidth = width / cols;   //10
  int brickHeight = 20;          // height of each brick
  for (int i = 0; i < rows; i++) {     // loop to assign the color for each row 
    color rowColor;
    if (i == 0) rowColor = color(255, 100, 100); // Red row
    else if (i == 1) rowColor = color(255, 200, 100); // Orange row
    else if (i == 2) rowColor = color(100, 255, 100); // Green row
    else if (i == 3) rowColor = color(100, 150, 255); // Blue row
    else rowColor = color(200, 100, 255); // Purple row

    for (int j = 0; j < cols; j++) {    // creating each brick by sending the parameter values to the constructor of Brick Class.
     bricks[i * cols + j] = new Brick(j * brickWidth, i * brickHeight, brickWidth - 5, brickHeight - 5, rowColor);  //  bricks[0]  brick[1]
    }
  }
}

void draw() {     // Loop Method
  
  background(0); // Black background
  textSize(16);
  text("Score: " + score + "\n Press R to Restart" , 370,375);
  if (playing) {
    // Display the score at the bottom-right corner
    fill(255);
    textSize(16);
    textAlign(RIGHT, BOTTOM);
    

    platform.move(); // Move the platform
    platform.display(); // Display the platform

    ball.move(); // Move the ball
    ball.checkCollision(platform, bricks); // Checking collisions with paddle and bricks
    ball.display(); // Display the ball

    boolean bricksLeft = false;
    for (Brick brick : bricks) {     // for each loop
      if (brick != null) {
        brick.display();
        bricksLeft = true;
      }
    }

    // Win condition: all bricks are destroyed
    if (!bricksLeft) {
      playing = false;
      win = true;
    }

    // Loss condition: ball falls below the platform
    if (ball.position.y > height || ball.position.y > platform.y + platform.height) {
      playing = false;      // stop the game play
      win = false;         //  Loss the Game stage
    }
  } else {
    
    if(win)
    {
      fill(255);
      textSize(70);
      text("You Win!", 320, 200);      
      
    }
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    setup(); // Reset the game
    playing = true;
    score = 0; // Reset the score for the user to restart the game after loss
  }
}

// Platform Class
class Platform {
  float x; // X-coordinate of the platform (top-left)
  float y; // Y-coordinate of the platform (top-left)
  float width; // Width of the platform
  float height; // Height of the platform

  Platform() {
    width = 80;
    height = 10;
    x = (width / 2) - (this.width / 2); // Positioned horizontally centered
    y = 370; // Positioned 30 pixels above the bottom
  }

  void display() {
    fill(255); // White platform
    rect(x, y, width, height);
  }

  void move() {
    x = mouseX - width / 2;
    x = constrain(x, 0, 400 - width); 
  }
}

// Ball Class
class Ball {
  PVector position;
  PVector velocity;
  float radius = 10;

  Ball() {
    position = new PVector(width / 2, height / 2); // Start at the center
    velocity = new PVector(random(-2, 2), 4); // Random horizontal velocity
  }

  void move() {
    position.add(velocity);

    // Bounce off walls
    if (position.x < radius || position.x > width - radius) {
      velocity.x *= -1;
    }
    if (position.y < radius) {
      velocity.y *= -1;
    }
  }

  void checkCollision(Platform platform, Brick[] bricks) {
    // For the Platform
    if (position.y + radius > platform.y &&
        position.y + radius < platform.y + platform.height &&
        position.x > platform.x &&
        position.x < platform.x + platform.width) {
      velocity.y *= -1;
    }

    // Check collision with bricks
    for (int i = 0; i < bricks.length; i++) {            // bricks.length is the count value of the bricks ( 3*4 = 12 bricks )
      Brick brick = bricks[i];   
      if (brick != null &&
          position.x > brick.x &&
          position.x < brick.x + brick.width &&
          position.y > brick.y &&
          position.y < brick.y + brick.height) {
        bricks[i] = null; // Remove the brick
        velocity.y *= -1; // Reverse ball direction
        score++; // Increment score
        break;
      }
    }
  }

  void display() {
    fill(255); // White ball
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
}

// Brick Class
class Brick {
  float x, y;
  float width, height;
  color c;

  Brick(float x, float y, float w, float h, color c) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
    this.c = c; // Use the passed color
  }

  void display() {
    fill(c); // Brick color
    rect(x, y, width, height);
  }
}
