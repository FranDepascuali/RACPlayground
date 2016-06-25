//: [Previous](@previous)
//:
import UIKit
import Result
import ReactiveCocoa
//:
//: ## MutableProperty
//:
//: There are some occasions in which we want to store the values emitted by a Signal or a SignalProducer. Here is where *MutableProperty* comes handy. Please go the [**Properties overview**](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md#properties) and read about them.
//:
//: Let's see some examples:
//:
    print("---------------(1)---------------")
    let property: MutableProperty<Int> = MutableProperty(4)
    print("value: \(property.value)")
//:
//: You can think of a ***MutableProperty*** as a reference to an object that contains a value. We mutate the value that it points to, but not the MutableProperty itself.
    print("---------------(2)---------------")
    property.value = 3
    print("value: \(property.value)")
//:
//: It would be too simple if this is the only thing **MutableProperty** provide us. They need to have some relation with **Signal** and **SignalProducer**. 
//: 
//: Let's see how:
    print("---------------(3)---------------")
    property.signal.observeNext { value in
        print("value emitted by signal of property: \(value)")
    }
    property.value = 7
//: We only see that the ***Signal*** emitted the value 7. Why didn't it emit the values 4 and 3? This is because we started observing the signal ***after*** we changed the property.value to 3 and 4. So we only see the 7, because it arrived ***after*** the observeNext closure.
//: 
//: We can also ask for the property's producer:
    print("---------------(4)---------------")
    property.producer.startWithNext { value in
        print("value emitted by producer of property: \(value)")
    }
//: Whoa! What happened there? Unlike ***Signal***, when we ask for the producer of a property, **it always emit first the current value of the property(!!!)**. That's why it printed 7.
    print("---------------(5)---------------")
    property.value = 8
//:
//: ## AnyProperty
//:
//: We should not have a class exposing a MutableProperty. Why is that?
//: Because any external entity could modify the current value of that MutableProperty(remember, it's a pointer).
//:
//: > There are some exceptions, for example when we have a UITextField on our view and want to bind it with a mutable property on the view model. In that case, we do want to have the mutable property exposed as public because we will be changing that property.
//:
    print("---------------(6)---------------")
    public class Foo {
        public let myProperty = MutableProperty(5)
    }
    let foo = Foo()
    print("myProperty: \(foo.myProperty.value)")
    foo.myProperty.value = 3
    print("myProperty: \(foo.myProperty.value)")
//: Apart from the exceptions, we don't want this kind of behaviour. Here is where we use *AnyProperty*: It is basically like a MutableProperty, but we can't change the value to which it is pointing to:
    let anyProperty1 = AnyProperty(property)
//: It offers the same operations like MutableProperty, but we can't change the current value. We usually end up having both of them:
    public class Bar {
        
        public let myProperty: AnyProperty<Int>
        
        private let _myProperty = MutableProperty(4)
        
        public init() {
             myProperty = AnyProperty(_myProperty)
        }
        
    }
//: Here we cannot change the value of myProperty from outside Bar.
//:
//: > We can also initialize an ***AnyProperty*** from a ***Signal*** or ***SignalProducer***, but we need to provide it an initial value.
    let anyProperty2 = AnyProperty<Int>(initialValue: 5, signal: Signal<Int, NoError>.empty)

//: [Next](@next)
