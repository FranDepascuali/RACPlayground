//: [Previous](@previous)
//:
import UIKit
import Result
import ReactiveCocoa
import Rex
//:
//: ## Action
//:
//: There are some cases in which we want to know if wether a SignalProducer is executing, well rather than executing, we need to have a life cycle. Here is where Action type comes into play. An action is parametrized with 3 types:
    let _: Action<Int, (), NSError>
//:* The first type(Int here) is the input of the action
//:* The second type(Void here) is the output of the action
//:* The third type(NSError here) is the possible errors for the action
//: To initialize an action, we need to provide a SignalProducer as follows.
let a = Action<Int, (), NSError> { number in
    return SignalProducer { observer, _ in
        print(number)
    }
}
//: Action receives a InputType -> SignalProducer<OutputType, ErrorType> in its initialization.
//:
//: The best use case for Action is to bind it to a button.
//: (I am using Rex here, which has some extensions to let us bind UI properties to RAC components.)
//:
let action = Action<AnyObject, Int, NSError> { _ in
    return SignalProducer(value: 7)
}
let button = UIButton()

button.rex_pressed.value = action.unsafeCocoaAction
//: 
//: Now, whenever we press the button, it fires the action.
print("---------------(1)---------------")
action.values.observeNext { number in
    print("number = \(number)")
}
button.sendActionsForControlEvents(.TouchUpInside)
//: Right, but we could have a SignalProducer and start it, and it would be the same than an Action?
//: Action has some other useful properties.
print("---------------(1)---------------")
action.executing.producer.startWithNext {
    print("Executing: \($0)")
}
button.sendActionsForControlEvents(.TouchUpInside)
//: We can observe if the Action is executing, so for example if we are signing up we can show a toast while the Action is executing.
let newActionEnabled = MutableProperty(false)
let newAction = Action<AnyObject, (), NSError>(enabledIf: newActionEnabled) { _ in
    return SignalProducer(value: ())
}
//: Here we have an Action that is enabled only if the value of the mutable property is true. The button will then be enabled/disabled when its correspondant action is enabled/disabled.
//: We can also execute an Action programatically:
action.apply("").start()
//: apply() returns us the SignalProducer and then we start it.
//: Notice that (as we were listeing to the executing property) it emitted:
//: false -> true -> false

//: [Next](@next)



