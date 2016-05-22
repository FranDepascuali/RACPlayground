//: [Previous](@previous)
import Result
import ReactiveCocoa
//: ### SignalProducers
//:
//: Go again to the [Framework Overview](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md) and read the ***Signal Producer*** section.
//:
//: You are done. Good bye!
//:
//: I was joking. Here I am. SignalProducer is a difficult concept to grab first, but I promise it will make sense.
//:
//: The problem that we encounter with *signals* is that there some occasions in which we don't want to observe the signal when we call ***observeNext***. We want to start observing that signal in another moment. This is why `SignalProducer` was created:
//:
//:__A signal producer, represented by the SignalProducer type, creates signals and performs side effects.__
//:
//: Just avoid the side effects part. A ***SignalProducer*** internally creates a signal when it is started. Just that.
//:
//: As with pipe() function of signals before, I now have to use the function buffer() from ***SignalProducers***. It is the same concept, it let us create a ***SignalProducer*** and an observer for sending values through it.
//:
    print("---------------(6)---------------")
// buffer() is analogue to pipe().
    let (producer, producerObserver) = SignalProducer<Int, NoError>.buffer(0)

// Note that for producers, it is called startWithNext()
    producer.startWithNext { value in
        print(value)
    }
    producerObserver.sendNext(7)
    producerObserver.sendNext(11)
//:
//: You will see that the producer emitted the values 7 and 11, just like the signal did before.
//:
    print("---------------(7)---------------")
    producer.startWithNext { _ in
        print("hello!")
    }
    producerObserver.sendNext(0)
//:
//: Now it printed the 0 value and the hello!, because we started the producer twice.
//:
//: Ahm, so it is the same as ***Signal***, right?
//:
//: __ABSOLUTELY NOT! Though it seems to be the same, different things are going on here: Do you remember how a Signal emitted a UNIQUE stream of values and every observer saw the SAME stream? SignalProducers emit different streams of values each time we start them. In this case, TWO streams of values are created.__
//:
//: __Why do SignalProducer emit DIFFERENT streams of values? Because a SignalProducer is a recipee to create new signals. So each SignalProducer creates a new signal every time they are started.__
//:
//: In this case, we are creating two ***DIFFERENT*** streams of values, one for each producer:
//:1. Next(7) - Next(11) - Next(0)
//:2. Next(0)
//:
//: If we had a signal instead of a producer, it would emit a single stream of values:
//:
//: Next(7) - Next(11) - Next(0)
//:
//: Just some more clarifications that may be handy:
//:
//: 1. ***Signals*** are called ***hot***: They start emiting values as soon as they are created. On the other hand, ***SignalProducers*** are called ***cold***: They start emiting values ***ONLY*** when they are started.
//:
//: 2. ***SignalProducers*** is a design decision from the creators of RAC. There are other reactive frameworks like RXSwift that don't separate ***Signal*** from ***SignalProducer***.
//:
//: We've covered the basics of ***Event***, ***Signal*** and ***SignalProducer***.
//:
//: In the next page, we'll see a use case for ***SignalProducer***.
//:
//: [Next](@next)
