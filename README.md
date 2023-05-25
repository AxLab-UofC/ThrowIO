# ThrowIO
We introduce ThrowIO, a novel style of actuated tangible user interface that facilitates throwing and catching spatial interaction powered by mobile wheeled robots on overhanging surfaces. In our approach, users throw and stick objects that are embedded with magnets to an overhanging ferromagnetic surface where wheeled robots can move and drop them at desired locations, allowing users to catch them. The thrown objects are tracked with an RGBD camera system to perform closed-loop robotic manipulations. By computationally facilitating throwing and catching interaction, our approach can be applied in many applications including kinesthetic learning, gaming, immersive haptic experience, ceiling storage, and communication. We demonstrate the applications with a proof-of-concept system enabled by wheeled robots, ceiling hardware design, and software control. Overall, ThrowIO opens up novel spatial, dynamic, and tangible interaction for users via overhanging robots, which has great potential to be integrated into our everyday space.

# Things to Install for ThrowIO
- [Rust](https://www.rust-lang.org/tools/install): We connect to toio robots via Rust OSC bridge.
- [Processing IDE](https://processing.org/download): We use Processing to control toio robots, enable kinect camera tracking, and provide visuals. You might need to install more libraries in Processing depending on your environment.

# Things to Prepare for ThrowIO
- ThrowIO Structures: We share the design instructions for ThrowIO structures below. 
- 3D Printing STL Files: We share the stl files for the thrown object and toio shells in this github.
- [Toio Robots and Toio Mats](https://www.sony.com/en/SonyInfo/design/stories/toio/)
- Kinect Camera

# ThrowIO Structures

## UChicago AxLab Demo Structure (shown in paper)
Main materials and equipment: height-adjustable table, foam mats, ferromagnetic metal plate, magnets holding ferromagnetic metal plate, 4 toio mats. 
![lab-structure](https://github.com/AxLab-UofC/ThrowIO/assets/66953378/98e6a020-ba04-4f10-9eee-f65262657710)


## CHI 2023 Body-Scale Demo Structure

### What does this structure demonstrate?
This setup allows users to experience three applications of ThrowIO: throw-catch practice, immersive haptic experience, and ceiling storage.


### Main materials and equipment: 
1-1/2 PVC pipes, 1-1/2 PVC joints, foam mats, clamp holding kinect camera, ferromagnetic metal plate, wooden board with central part carved out, 4 toio mats.

![body-scale-structure](https://github.com/AxLab-UofC/ThrowIO/assets/66953378/ba2e776d-789e-4993-8df8-4c6fde023476)

## CHI 2023 Desktop Demo Structure

### What does this structure demonstrate?
This setup allows users to closely see how ceiling robots collaborate and faciliate throwing and catching action using a magnetic toio robot as the thrown object. In this demo, a user can place a toio ball in the middle of the two dropping robots, and they will converge and drop the toio ball, allowing users to catch it. Comparing to the other structures, this setup is easy to transport and does not require a kinect camera.

### Main materials and equipment: 

1/2 PVC pipes, 1/2 PVC joints, foam mats, ferromagnetic metal plate, wooden board, 1 toio mat.

![desktop-structure](https://github.com/AxLab-UofC/ThrowIO/assets/66953378/eabd97da-342e-43fb-9cd2-dacf954ad7d8)

# How to Connect to toio Robots via Rust OSC

1. Navigate to rust_osc folder in the terminal by typing `cd ThrowIO/rust_osc`
2. Setup cargo environment by typing `source $HOME/.cargo/env` or `./build.sh`
3. Connect to 2 toio robots by typing the following example commands (you can also connect to 3 toio robots by adjusting the following command)

example: `cargo run -- -a 33,90`
example: `cargo run -- -n f3K,L6T`

# Steps To Run ThrowIO with UChicago AxLab Demo Structure or CHI 2023 Body-Scale Demo Structure

1. Setup demo structure specified above and 3D print the robot shells (regular robot shell with fillet.stl)
2. Connect to 2 toio robots via Rust OSC bridge in the terminal by typing, for example, `cargo run -- -a 27,91`
3. Place the 3D printed shells on the toio robots
4. Navigate to demo_applications folder and double click demo_applications.pde file. Once the Processing file is loaded, press the Play button.
5. Place the two robots to the overhanging surface. If you don't know which robot goes to which corner, you can press `c` key to turn on calibration mode. By doing so, the robots will each automatically travel to their respective starting position. 
6. Now, on the camera window, you can also calibrate the size of the detection toio mat area (calibration mode == position) and the color of the thrown object (calibration mode == color). You can also save and load the calibration results by hitting `s` key for saving and `l` key for loading.
7. On the camera window, you can also switch the detection mode: color detection, IR detection, mouse clicking. You can hit `i` key to switch to IR, `m` key to switch to Mouse, `o` key to switch to Color (default).
8. On the camera window, you can also switch the application mode: practice (throw-catch practice), story (immersive haptic experience), storage (ceiling storage). You can do so by pressing `1` key to practice, `2` key to story, `3` key to storage.
9. Once everything is set up and calibrated, you can ask your users to throw and catch with the ceiling robots.


# Steps To Run ThrowIO with CHI 2023 Desktop Demo Structure

1. Setup desktop demo structure specified above and 3D print the robot shells (desktop-demo-robot-shell.stl and desktop-demo-robot-ball-shell.stl)
2. Connect to 3 toio robots via Rust OSC bridge (first two connected toio robots will be dropping robots and the last one will be the toio ball) by typing, for example, `cargo run -- -a 24,27,87`
3. Place the 3D printed shells on the toio robots
4. Navigate to desktop_demo folder and double click desktop_demo.pde file. Once the Processing file is loaded, press the Play button.
5. Place the two dropping robots to the overhanging surface. If you don't know which robot goes to which corner, you can press `c` key to turn on calibration mode. By doing so, the dropping robots will each automatically travel to their respective starting position. Remember to press `c` key again to turn off the calibration mode.
6. We can now place the toio ball to the middle of the two dropping robots, and they will drop the toio ball, allowing users to catch.

# Application: Orange (Immersive Haptic Experience)

## How to set up

- Prepare one laptop (connected to Kinect Camera)
- Connect a monitor as an extended screen to laptop
- Adjust the height of the overhanging ceiling as needed 
- Inside of toio_processing folder, go to "Constants" script, and change "applicationMode" to "story"
- Connect two toio robots using rust 
- Run the processing script (in toio_processing folder)
- Calibrate the overhanging toio mat (you can skip this step if you previous calibrated before)
- Make sure to use the white ball
- Run the immersive story script (in immersive folder)
- Make sure that the story telling screen is shared by the projector
- Start interact in the story!

Use one laptop and connect it to a project and an external monitor. Go to System Preferences, Displays, and you can make the laptop as the extended screen and the monitor as the main screen (which will mirror the project). Drag the toio camera screen to the laptop and drag the immersive screen to the monitor, so that the projector will only show the storytelling screen. 

You need to first launch the main ThrowIO processing script (in toio_processing folder), then run the immersive processing script (in immersive folder).

# Application: UFO Gaming

## How to set up

- Prepare one laptop (connected to Kinect Camera)
- Connect a monitor that is placed on top of the overhanging ceiling to laptop
- Adjust the height of the overhanging ceiling as needed 
- Inside of toio_processing folder, go to "Constants" script, and change "applicationMode" to "ufo"
- Connect two toio robots using rust 
- Run the processing script (in toio_processing folder)
- Calibrate the overhanging toio mat and the ball color (you can skip this step if you previous calibrated before)
- Make sure that the game screen is shared on the monitor while the camera screen is shared on the laptop
- Start playing the ufo game!

# Application: Ceiling Storage

## How to set up 

- Prepare one laptop (connected to Kinect Camera)
- Adjust the height of the overhanging ceiling as needed 
- Put the overhanging shelf on the overhaning ceiling
- Inside of toio_processing folder, go to "Constants" script, and change "applicationMode" to "storage"
- Connect two toio robots using rust 
- Run the processing script (in toio_processing folder)
- Calibrate the overhanging toio mat and the ball color (you can skip this step if you previous calibrated before)
- Start "store", and then "retrieve" item with the robots

# Application: Pratice Throw and Catch 

## How to set up 

- Prepare one laptop (connected to Kinect Camera)
- Adjust the height of the overhanging ceiling as needed 
- Inside of toio_processing folder, go to "Constants" script, and change "applicationMode" to "practice"
- Connect two toio robots using rust 
- Run the processing script (in toio_processing folder)
- Calibrate the overhanging toio mat and the ball color (you can skip this step if you previous calibrated before)
- Start throw and catch with robots

# Other Notes
## Toio Mat Dimension and Coordinates

![toio-mat-dimension](https://github.com/AxLab-UofC/ThrowIO/assets/66953378/c6988aee-4d0d-4d11-a802-045bcebcda9c)

## Tangent Point Calculation Detail

![tangent-point-calculation](https://github.com/AxLab-UofC/ThrowIO/assets/66953378/41df02d5-e9d1-4eaf-afa6-686b081c7c0e)


