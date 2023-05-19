# ThrowIO

# Connect to toio robots via Rust OSC

cd ThrowIO/rust_osc
`source $HOME/.cargo/env` or `./build.sh`

connect to 2 toio robots

example: `cargo run -- -a 33,90`
example: `cargo run -- -n f3K,L6T`
example: `cargon run -- -a 33,90 -n D2F`

# CHI 2023 Body-Scale Demo Structure

![body-scale-structure](https://github.com/AxLab-UofC/ThrowIO/assets/66953378/c8c5fbdc-6654-49aa-a13b-3f1403e9ae7a)

# CHI 2023 Desktop Demo Structure

![desktop structure](https://github.com/AxLab-UofC/ThrowIO/assets/66953378/f19fca14-46b2-4be5-b963-75888c0faabd)

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

# Details
