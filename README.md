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
11. [Memory Management](./RACPlaygroundProject/RACPlayground.playground/Pages/MemoryManagement.xcplaygroundpage) (pending)

### Visualization ###

The tutorial is made with markdown. You should go to `File Inspector` and activate `Render Documentation`.

<img width="974" alt="screen shot 2016-05-25 at 21 46 17" src="https://cloud.githubusercontent.com/assets/12101394/15560486/69855bf2-22c2-11e6-98d5-16377ddbd016.png">


### Boostrap ###

1. Clone the project.
2. Check that you have Carthage installed (check that `carthage version` returns something valid). If you don't have it yet, run `brew install carthage`.
3. Run bootstrap (`./bootstrap`). It will update and build RAC dependencies.
4. Open `RACPlaygroundWorkspace.xcworkspace`.
5. In xcode, build `RACPlaygroundProject`.
<img width="861" alt="screen shot 2016-05-25 at 21 51 06" src="https://cloud.githubusercontent.com/assets/12101394/15560554/08b8072e-22c3-11e6-8107-0bd268db8b5a.png">
6. You should be able to use [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) and [Result](https://github.com/antitypical/Result) in `RACPlayground.playground`.

