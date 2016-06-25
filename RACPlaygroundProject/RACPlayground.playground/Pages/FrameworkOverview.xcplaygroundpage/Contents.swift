//: [Previous](@previous)
//: # Framework Overview
//: > ReactiveCocoa(RAC) is a framework that *provides APIs for composing and transforming streams of values over time.*
//:
//: The first time I read this definition I didn't understand what it meant, so let's break it into smaller pieces:
//:* **Provides APIs**: Provides us an interface
//:* **for composing and transforming**
//:* **streams of values over time**: multiple values that will be received at uncertain moments.
//:
//: >So, in plain english, ReactiveCocoa is a framework that *provides us an interface for composing and transforming multiple values that will be received at uncertain moments*.
//:
//: I also like to see it as a way to discretize events through time.
//: ### Origins
//: ReactiveCocoa comes from the Functional Reactive Programming(FRP) paradigm.
//:
//: As wikipedia states:
//: > Programming paradigm for reactive programming (asynchronous dataflow programming) using the building blocks of functional programming (e.g. map, reduce, filter)
//:
//: In this official [**Framework Overview**](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md) from ReactiveCocoa you can read a high-level description of the components. Please, go ahead and read the items [**Events**](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md#events) and [**Signal**](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md#signals), I'll wait here.
//:
//: ...
//:
//: Right, now you have a notion of what **Events** and **Signals** are, I'll try to explain it in my own words.
//:
//: ### Events
//: Events are the *representation that something has happened*.
//:
//: We have four types of events:
//: * **Next**: Provides a new value.
//: * **Failed**: Indicates that an error occurred before the stream could finish.
//: * **Completed**: Indicates that the stream finished successfully, and that no more values will be sent by the source.
//: * **Interrupted**: Indicates that the stream has terminated due to cancellation.
//:
//: I know you are developers and may be thinking (give me some code!), so here we have the representation of **Event**:
//:
public enum Event<Value, Error: ErrorType> {
    
    case Next(Value)
    
    case Failed(Error)
    
    case Completed
    
    case Interrupted
}
//:
//: Event needs to know which type of *Value* it should emit in case of ***Next*** and also which type of error in case of ***Failed***. That's why it is parametrized with ***Value*** and ***Error: ErrorType***.
//:
//: We can have different streams of events:
//:* stream: ***Next(5) -> Next(3) -> Next(7) -> Completed*** (Three values and then a Completed).
//:* stream: ***Next("Hello") -> Next("World") -> Interrupted*** (Two values and then an Interrupted).
//:* stream: ***Next(true) -> Failed*** (A value and a Failed event).
//:* stream: ***Completed*** (Just a Completed event).
//:
//: [Next](@next)
