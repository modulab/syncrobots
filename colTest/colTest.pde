import org.apache.commons.math3.geometry.euclidean.twod.Vector2D;

import java.util.ArrayList;
import java.util.List;

final Blocks blocks = new Blocks();

void setup() {
      

        // Set up the scenario.
        blocks.setupScenario();
  
}

void draw() {
  
              blocks.updateVisualization();
            blocks.setPreferredVelocities();
            Simulator.instance.doStep();

  
}
