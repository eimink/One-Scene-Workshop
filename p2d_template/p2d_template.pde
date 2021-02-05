// Minim is needed for the music playback.
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

final int CANVAS_WIDTH = 1920; // We want  1920 pixels wide...
final int CANVAS_HEIGHT = 1080; // and 1080 pixels tall canvas.
final int FPS = 60; // We want  to run in 60 FPS

float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;

// Needed for audio
Minim minim;
AudioPlayer song;

// Now lets setup audio playing
void setupAudio() {
  minim = new Minim(this);

  // This is where we load the song and play it.
  // song = minim.loadFile("beat.mp3");
  // song.play();
}


void settings() {
  // Set up the drawing area size and renderer (usually P2D or P3D,
  // respectively for accelerated 2D/3D graphics).
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P2D);
}

void setup() {
  frameRate(FPS); 
  noStroke();
  fill(255);
  smooth();
  
  /* Lastly, let's call audio setup function we defined earlier. 
   * This should be last call in setup so that the song doesn't
   * start playing too early.
   */
  setupAudio();
}


/*
 * Processing's drawing method – all
 * rendering should be done here!
 */
void draw() {
  // Reset all transformations.
  resetMatrix();
  translate(CANVAS_WIDTH/2.0, CANVAS_HEIGHT/2.0);
  scale(CANVAS_WIDTH/2.0/ASPECT_RATIO, -CANVAS_HEIGHT/2.0);
  ellipse(0., 0., 1.0, 1.0);
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
