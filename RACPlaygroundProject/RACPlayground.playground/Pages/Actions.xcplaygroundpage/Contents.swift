//: [Previous](@previous)
//:
import UIKit
import Result
import ReactiveCocoa
import Rex
//:
//: # Action
//:
//: There are some cases in which we want to know if a *SignalProducer* is executing, well rather than executing, we want to observe it's life cycle. Here is where Action type comes into play. 
//: As before, please go first to [Actions](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md#actions).
//:
//: An **action** is parametrized with 3 types:
    let _: Action<Int, (), NSError>
//:* The first type(**Int**) is the input of the action
//:* The second type(**Void**) is the output of the action
//:* The third type(**NSError**) is the possible errors for the action
//:
//: To initialize an **action**, we need to provide a **SignalProducer** as follows.
    let a = Action<Int, (), NSError> { number in
        return SignalProducer { observer, _ in
            print(number)
        }
    }
//: Action receives a InputType -> SignalProducer<OutputType, ErrorType> in its initialization.
//:
//: The best use case for Action is to bind it to a button.
//:
//: >I am using [Rex](https://github.com/neilpa/Rex) here, which has some extensions to let us bind UI properties to RAC components.
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
    button.sendActionsForControlEvents(.TouchUpInside) // This simulates a user touching the button
//: Right, but we could have a *SignalProducer* and start it, and it would be the same than an Action?
//:
//: Actions have other useful properties.
//:
//: ### Executing
//:
//: We can observe an Action's executing property, so for example if we are signing up we can show a toast while the *Action* is executing.
    print("---------------(2)---------------")
    action.executing.producer.startWithNext {
        print("Executing: \($0)")
    }

    button.sendActionsForControlEvents(.TouchUpInside)
//:
//: ### Enabled
//:
//: We can also specify when should the action be enabled, by passing a **MutableProperty** or **AnyProperty** to it:
//:
    let newActionEnabled = MutableProperty(false)
    let newAction = Action<AnyObject, (), NSError>(enabledIf: newActionEnabled) { _ in
        return SignalProducer(value: ())
    }
//: Here we have an Action that is enabled only if the value of the mutable property is true. 
//:
//: > The button will then be enabled/disabled when its correspondant action is enabled/disabled.
//:
//: We can also execute an Action programatically:
    action.apply("").start()
//: apply() returns us the SignalProducer and then we start it.
//: Notice that (as we were listening to the executing property) it emitted:
//: false -> true -> false
//:
//: [Next](@next)



