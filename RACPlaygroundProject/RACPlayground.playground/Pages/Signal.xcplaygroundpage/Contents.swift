//: [Previous](@previous)

import Result
import ReactiveCocoa

//: ### Signals
//: It would be great if we could name (or encapsulate) these streams of values. Here is where **Signal** appears: it represents that stream of values. In other words ***Signal is an stream of events***, just like the ones presented before.
//:
//:* signal1: ***Next(5) -> Next(3) -> Next(7) -> Completed*** (Three values and then a Completed).
//:* signal2: ***Next("Hello") -> Next("World") -> Interrupted*** (Two values and then an Interrupted).
//:* signal3: ***Next(true) -> Failed*** (A value and a Failed event).
//:* signal4: ***Completed*** (Just a Completed event).
//:
//: I will write something that may seem obvious, but signals should offer two things:
//:* The capability of observing those events (I'll refer to those events as the events that a signal emits).
//:* Functions to ***compose and transform*** those events.
//:
//: So let's play with some of those functions
//:
//: First of all, I will use a function of signals, pipe, that let us create a signal and send values through that signal. You can read about it in the [Framework Overview](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md).
//:
//: If I could, I would avoid using pipe() here, but we haven't other way to manually create and control a signal. In a real app, one should avoid creating signal with pipe().
//:
    let (signal1, observer1) = Signal<Int, NoError>.pipe()
//: pipe() provides:
//:* A ***signal***: In this case signal1 which is of type ***Signal<Int, NoError>***, this means that it can emit ***Next*** events with type ***Int***, and ***Failed*** events with type ***NoError***.
//:* An ***observer***: In this case observer1 which is of type ***Observer<Int, NoError>***. This observer is where we will send an *Int* value and the signal will emit that value.
//:
//: Let's see how:
//:
    print("---------------(1)---------------")
    signal1.observeNext { value in
        print(value)
    }
    observer1.sendNext(5)
    observer1.sendNext(3)
    observer1.sendNext(7)
//:
//: You should see on the console the values 5,3,7 printed.
//:
//: Now, try something. Move the ***observer1.sendNext(5)*** to between the ***print*** and the ***signal1.observe***.
//:
//: Can you explain what happened?
//:
//: __The signal emitted the value 5, but we weren't observing it. So we miss that value. This happens often: we will receive that stream of values as long as we are observing that signal.__
//:
//: We can observe that signal multiple times. Maybe we want to print the value, maybe we want to so something else.
//:
    print("---------------(2)---------------")
    signal1.observeNext { value in
        print("plus3: \(value + 3)")
    }
    observer1.sendNext(7)
//:
//: Open the console again. Why did we see 7 and 10? Because we are observing the signal twice: in the first *ObserveNext* we printed the value, in the second one we printed the value + 3.
//:
//: Here we grab another concept: __a signal emits a stream of values and it can have multiples observer. They all observe the SAME(!!!) stream of values. That last sentences is very important. The signal emits a single stream that every observer of that signal will observe (the stream is unique and it is the same for every observer). I know I'm being repetitive, but this is very important to prevent confusion with other following concepts. I'll get back into this later.__
//:
//: Now, let's apply some transformations that signals offer us:
//:
//: One of the most important is map: It let us provide a transformation to the Next values emitted by the signal.
//:
//: For example:
//:
    print("---------------(3)---------------")
    let signal2 = signal1.map { number in "\(number)" }
//:
//: Xcode infers the type of signal2, which is ***Signal<String, NoError>***. Now, whenever signal1 emits an int, signal2 will emit a string.
    signal2.observeNext { string in
        print(string)
    }
    observer1.sendNext(22)
//: This is a tricky one: It prints
//:1. 22 for the first observer of ***signal1***.
//:2. 25 for the second observer of ***signal1***.
//:3. 22 for the observer of ***signal2***.
//:
//: We can also filter values
//:
    print("---------------(4)---------------")
    signal1
        .filter { $0 > 22 }
        .map { $0 * 2 }
        .observeNext {
            print("result: \($0)")
    }
    observer1.sendNext(50)
//:
//: It prints
//:1. 50 for the first observer of ***signal1***.
//:2. 53 for the second observer of ***signal1***.
//:3. 50 for the observer of ***signal2***.
//:4. 100 for the last observer added.
//:
//: Now, the signal remains alive, it didn't complete nor fail and wasn't interrupted.
//:
    print("---------------(5)---------------")
    observer1.sendCompleted()
//: Now it completed. You could try sending values again to the observer but they will not go anymore through the `observeNext` blocks because the signal already completed.
    observer1.sendNext(9)
//:
//: These were the main concepts for RAC release 1 and RAC release 2. In RAC3 (RAC release 3), there were ground-breaking changes to the framework and the notion of ***SignalProducer*** was introduced.
//:
//: [Next](@next)
