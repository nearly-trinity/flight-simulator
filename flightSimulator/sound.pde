import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;
Oscil wave;
Oscil wave2;
Oscil wave3;

float freq = 260;
float amp = .5;

void mouseMoved()
{
  int offCenter = (abs(mouseX-400)+2*abs(mouseY-400))/3/20;
  float offAmp = float((2*abs(mouseX-400))+abs(mouseY-400))/3/900;
 
  wave2.setAmplitude( amp + offAmp);
  wave.setFrequency( freq  + offCenter);
}
