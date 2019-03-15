import org.apache.commons.math3.geometry.euclidean.twod.Vector2D;

import java.util.ArrayList;
import java.util.List;

final Blocks blocks = new Blocks();

 RVOMath RVOMath = new RVOMath();


 final Simulator instance = new Simulator();
void setup() {
      
size(800,800);
        // Set up the scenario.
        blocks.setupScenario();
  //blocks.setPreferredVelocities();
}

void draw() {
  background(255);
  if (!blocks.reachedGoal()) {
              blocks.updateVisualization();
            blocks.setPreferredVelocities();
            instance.doStep();

  }  
}


void keyPressed() {
instance.setAgentPosition(1,new Vector2D(-10.0, -40.0));
}
