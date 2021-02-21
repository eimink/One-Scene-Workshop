// Import external functions here:

// Moonlander is a library for integrating Processing with Rocket
// Rocket is a tool for synchronizing music and visuals in demoscene projects.
import moonlander.library.*;
// Minim is needed for the music playback.
import ddf.minim.*;

// Global variables

// These control how big the opened window is.
final int CANVAS_WIDTH = 1920; // We want 1920 pixels wide...
final int CANVAS_HEIGHT = 1080; // and 1080 pixels tall canvas to get FullHD aka 1080p.

final int FPS = 60; // We want  to run in 60 FPS for broadcast reasons

float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;  // Aspect ratio of the canvas

float time = 0.0; // Time in seconds from Moonlander / GNURocket

Moonlander moonlander; // Moonlander instance

// Needed for audio
Minim minim;
AudioPlayer song;

PShape shape1;

PFont font;

PImage overlay;
String[] overlayFileNames = {
  "overlay1.png"
};

// Array for storing overlay images.
PImage[] overlayImages = new PImage[overlayFileNames.length];

// Array for storing texts we want to display
String[] texts = {
  "Hello Assembly",
  "This is ONE SCENE WORKSHOP",
  "Consider yourself invited to",
  "participate in ONE SCENE COMPO!",
  "60 seconds, one constant scene"
};

// Now lets setup audio playing
void setupAudio() {
  minim = new Minim(this);

  // This is where we load the song and play it.
  // song = minim.loadFile("beat.mp3");
  // song.play();
}


void settings() {
  boolean fullscreen = false;
  String renderer = P3D; // Renderer to use either P2D,P3D or JAVA2D.
  if (fullscreen) {
    // Set the window fullscreen in desktop's native resolution
    fullScreen(renderer);
  }
  else {
    // Open as window
    size(CANVAS_WIDTH, CANVAS_HEIGHT, renderer);
  }
  
}

void setup() {
  // Load shapes
  shape1 = loadShape("Love.obj");
  
  // Load the font
  // NOTE: You can use system available fonts like "MS Comic Sans" but that usually makes your production less cross-platform
  //       hence we'd recommend to save the font as an asset to the production.
  //       Just remember that font creators have copyrights, so the license needs to be appropriate to use in a demo.
  
  font = createFont("VictorMono-Regular.ttf", 200);

  // Load all images
  overlay = loadImage("overlay1.png");

  for (int i=0; i < overlayImages.length; i++){
    overlayImages[i] = loadImage(overlayFileNames[i]);
  }
  
  //hide mouse cursor
  noCursor();

  // Init & start moonlander
  int bpm = 120; // Tune's beats per minute
  int rowsPerBeat = 4; // How many rows one beat consists of in the sync editor (Rocket or so)
  moonlander = Moonlander.initWithSoundtrack(this, "beat1.mp3", bpm, rowsPerBeat);
  moonlander.start();

  frameRate(FPS); // Set the frame rate

  
  // Load assets used in demo
  
}
/*
 * The classic rotating cube from the begin
 */
void drawCube() {
  if (moonlander.getValue("cube:fill_alpha") <= 0.0 && moonlander.getValue("cube:line_alpha") <= 0.0) {
    //cube's line and fill alphas are zero or less, so let's skip trying to draw the cube at all
    return;
  }
  
  //pushMatrix / popMatrix functions ensure that matrix operations like rotation/translation/scaling will only happen inside the push/pop
  //so matrix operations called in between won't affect other 3D or 2D stuff drawn in the screen

  pushMatrix();

  // Matrices are calculated in an inverse order.
  // So matrix is calculated as rotate Z -> rotate Y -> rotate X -> translate -> (scale -> translate)
  // Note: last two steps, scale and translate, are called in draw() function

  // Move cube
  translate((float)moonlander.getValue("cube:x"), (float)moonlander.getValue("cube:y"), (float)moonlander.getValue("cube:z"));

  // Cube rotation is in degrees.
  // Note that usually rotation is done using radians but you can convert degrees to radians with the function radians()
  rotateX(radians((float)moonlander.getValue("cube:rotateX")));
  rotateY(radians((float)moonlander.getValue("cube:rotateY")));
  rotateZ(radians((float)moonlander.getValue("cube:rotateZ")));
  
  // black cube
  fill(0,0,0,(int)(moonlander.getValue("cube:fill_alpha") * 255));
  box((float)moonlander.getValue("cube:width"), (float)moonlander.getValue("cube:height"), (float)moonlander.getValue("cube:depth"));
  
  // white cube
  fill(255,255,255,(int)(moonlander.getValue("cube:line_alpha") * 255));
  box((float)moonlander.getValue("cube:width"), (float)moonlander.getValue("cube:height"), (float)moonlander.getValue("cube:depth"));

  popMatrix();
}

/*
 * Draw shape 1
 */
void drawShape1() {
  pushMatrix();

  // global positioning of all the shapes
  translate((float)moonlander.getValue("shape1:x"), (float)moonlander.getValue("shape1:y"), (float)moonlander.getValue("shape1:z"));
  
  shape1.setFill(color(255, 255, 255, (int)(moonlander.getValue("shape1:fill_alpha") * 255)));

  for(int i = 0; i < 5; i++) {
    pushMatrix();

    // odd/even shapes should be placed apart in Y axis and rotate to different directions
    float direction = 1.0;
    float y = (float)moonlander.getValue("shape1:spacing_y1");
    if (i%2 == 0) {
      direction = -1.0;
      y = (float)moonlander.getValue("shape1:spacing_y2");
    }
    
    // Note that matrix operations are in "reverse order" of the functions.
    // => So first scale, then rotateY and then translate
    // => Things will look different if you change the function calling order, go ahead and try!

    //position shape in a "row"
    translate(i*(float)moonlander.getValue("shape1:spacing"), y, 0);
    //rotate the shape, positive number is clock-wise and negative is counter clock-wise
    rotateX(radians(180));
    rotateY(time * direction);
    
    //scale the shape
    scale((float)moonlander.getValue("shape1:scale"));
    //draw the shape
    shape(shape1);

    popMatrix();
  }
  popMatrix();
}

/*
 * Draw window size 2D overlays throughout the demo
 */
void drawOverlays() {
  pushMatrix();

  // draw the stable overlay that is shown throughout the demo. image's color alpha is varying according to the beat
  tint(255,255,255,(int)(moonlander.getValue("overlay:alpha1") * 255));
  image(overlay, -CANVAS_WIDTH/2, -CANVAS_HEIGHT/2);

  // draw the overlays that are shown only shortly. image to be displayed and its alpha is defined in Rocket
  int overLayImageNumber = (int)moonlander.getValue("overlay:image") % overlayImages.length;
  if (overLayImageNumber >= 0) {
    tint(255,255,255,(int)(moonlander.getValue("overlay:alpha2") * 255));
    image(overlayImages[overLayImageNumber], -CANVAS_WIDTH/2 + (int)moonlander.getValue("overlay:x"), -CANVAS_HEIGHT/2 + (int)moonlander.getValue("overlay:y"));
  }

  popMatrix();
}

/*
 * Draw compo information and greetings texts
 */
void drawText() {
  if (moonlander.getValue("font:text") >= 0) {
    pushMatrix();
    scale((float)moonlander.getValue("font:scale"));
    textAlign(CENTER, CENTER);
    textFont(font);
    fill((int)(moonlander.getValue("font:r") * 255),(int)(moonlander.getValue("font:g") * 255),(int)(moonlander.getValue("font:b") * 255),(int)(moonlander.getValue("font:a") * 255));
    text(texts[(int)moonlander.getValue("font:text")%texts.length], (int)moonlander.getValue("font:x"), (int)moonlander.getValue("font:y"));
    popMatrix();
  }
}

/*
 * This function is called every time a screen is drawn, ideally that would be 60 times per second
 */
void draw() {
  // update Rocket sync data  
  moonlander.update();

  time = (float)moonlander.getCurrentTime();
  float end = 60.0; //end production after 60 secs which is the maximum time allowed by the One Scene Compo
  if (time > end) {
    exit();
  }
  
  // Set the background color
  background((int)(moonlander.getValue("bg:r") * 255),(int)(moonlander.getValue("bg:g") * 255),(int)(moonlander.getValue("bg:b") * 255),(int)(moonlander.getValue("bg:a") * 255));
  
  /*
   * Center coordinates to screen and make the window and canvas resolution independent
   * This is because actual window in full screen on a 4K monitor has more pixels than FullHD resolution
   * so scaling is needed to ensure that all objects (3D and 2D) are in correct places regardless of the desktop resolution
   */
  translate(width/2, height/2, 0);
  scale(width/CANVAS_WIDTH,height/CANVAS_HEIGHT,width/CANVAS_WIDTH);

  // Enable lights and depth testing to ensure that 3D meshes are drawn in correct order
  lights();
  hint(ENABLE_DEPTH_TEST);

  drawShape1();

  drawCube();

  // disable lights and depth testing so that 2D overlays and text can be draw on top of 3D
  noLights();
  hint(DISABLE_DEPTH_TEST);

  drawText();

  drawOverlays();
}

// Handle keypresses
void keyPressed() {
  if (key == CODED) {
    // if ESC was pressed we exit from demo. 
    // This is a requirement in Assembly compo rules for desktop platforms.
    if (keyCode == ESC) {
      exit();
    }
  }
}
