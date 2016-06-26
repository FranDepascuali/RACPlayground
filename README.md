## RACPlayground ##

![Swift 2.2.x](https://img.shields.io/badge/Swift-2.2.x-orange.svg)

This is a small project to have a playground with [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) and [Result](https://github.com/antitypical/Result) working.

It also contains a tutorial for learning ReactiveCocoa (version 4.x).

### Tutorial ###

The tutorial is divided into the following pages:

1. [Introduction](./RACPlaygroundProject/RACPlayground.playground/Pages/Introduction.xcplaygroundpage)
2. [Framework Overview](./RACPlaygroundProject/RACPlayground.playground/Pages/FrameworkOverview.xcplaygroundpage)
3. [Signal](./RACPlaygroundProject/RACPlayground.playground/Pages/Signal.xcplaygroundpage)
4. [SignalProducer](./RACPlaygroundProject/RACPlayground.playground/Pages/SignalProducer.xcplaygroundpage)
5. [Use Case: Sign up](./RACPlaygroundProject/RACPlayground.playground/Pages/UseCaseSignUp.xcplaygroundpage)
6. [Properties](./RACPlaygroundProject/RACPlayground.playground/Pages/Properties.xcplaygroundpage)
7. [Actions](./RACPlaygroundProject/RACPlayground.playground/Pages/Actions.xcplaygroundpage)
8. [Use Case: Sign up UI](./RACPlaygroundProject/RACPlayground.playground/Pages/UseCaseButtons.xcplaygroundpage)
9. [Play!](./RACPlaygroundProject/RACPlayground.playground/Pages/Play!.xcplaygroundpage)
10. [Chaining Operations](./RACPlaygroundProject/RACPlayground.playground/Pages/ChainingOperations.xcplaygroundpage)
11. [Memory Management](./RACPlaygroundProject/RACPlayground.playground/Pages/MemoryManagement.xcplaygroundpage)

### Visualization ###

The tutorial is made with markdown. You should go to `File Inspector` and activate `Render Documentation`.

### Screenshots ###
#### Index ####
<img width="1018" alt="screen shot 2016-06-25 at 19 48 57" src="https://cloud.githubusercontent.com/assets/12101394/16359517/f92cd560-3b0d-11e6-9bd3-7d26bb692ed0.png">

#### Framework Overview ####
<img width="1015" alt="screen shot 2016-06-25 at 19 50 18" src="https://cloud.githubusercontent.com/assets/12101394/16359525/38939de2-3b0e-11e6-8fa6-65955a28eeef.png">

#### Properties ####
<img width="1005" alt="screen shot 2016-06-25 at 19 50 41" src="https://cloud.githubusercontent.com/assets/12101394/16359526/3afae6a8-3b0e-11e6-9e8f-a87ba1627a74.png">

### Boostrap ###

1. Clone the project.
2. Check that you have Carthage installed (check that `carthage version` returns something valid). 
   If you don't have it yet, run `brew install carthage`.
  <img width="350" alt="screen shot 2016-06-26 at 16 40 00" src="https://cloud.githubusercontent.com/assets/12101394/16364457/9950b0f2-3bbd-11e6-8f75-97e852cfdff4.png">
3. Run bootstrap (`./bootstrap`). It will update and build RAC dependencies.
  <img width="948" alt="screen shot 2016-06-26 at 16 45 33" src="https://cloud.githubusercontent.com/assets/12101394/16364466/cd5471ea-3bbd-11e6-9a82-f3e1a84d7596.png">
4. Open `RACPlaygroundWorkspace.xcworkspace`.
  <img width="590" alt="screen shot 2016-06-26 at 16 46 01" src="https://cloud.githubusercontent.com/assets/12101394/16364469/ebf351a2-3bbd-11e6-9147-97590fdd593d.png">
5. In xcode, build `RACPlaygroundProject`.
  <img width="861" alt="screen shot 2016-05-25 at 21 51 06" src="https://cloud.githubusercontent.com/assets/12101394/15560554/08b8072e-22c3-11e6-8107-0bd268db8b5a.png">
6. You should be able to use [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) and [Result](https://github.com/antitypical/Result) in `RACPlayground.playground`.

* Please, make sure that you open the `RACPlaygroundWorkspace` and then open the playground (inside the workspace). It will not work if you close the workspace!
