//: [Previous](@previous)

import Foundation
import ReactiveCocoa
import enum Result.NoError

//: ## Memory Management
//: ----
//: This is (I believe) one of the most difficult topics that we face while developing for iOS. Memory issues are particularly difficult to track, I'll try to explain how do we need to manage memory with RAC.
//:
//: First, let's look an example:
public class IncorrectFoo {
    
    public private(set) var number: Int = 4
    
    public private(set) var signalProducer: SignalProducer<Int, NoError>!
    
    public init() {
        signalProducer = SignalProducer { observer, _ in
            observer.sendNext(5)
            self.number = 5
        }
    }
    
    deinit {
        print("Deiniting incorrect foo")
    }
    
}
//: okay, now we have an instance of IncorrectFoo:
var incorrectFoo: IncorrectFoo? = IncorrectFoo()
print(incorrectFoo?.number)
incorrectFoo = nil
//: What happened? We removed the reference to the instance that foo was pointing by setting it to nil. The thing is, we have a memory leak here.
//:
//: Can you spot where is it?
//:
//: Yes, you are right!(?). In the init method, we are explicitly retaining self. The problem here is that
//: self ---retains--> signalProducer because it's an instance property
//: signalProducer ---retains--> self because it is using self inside the closure we passed.
//:
//: How do we solve this? We need to explicitly tell the compiler that we don't want to keep the strong reference to self.
public class Foo {
    
    public private(set) var number: Int = 4
    
    public private(set) var signalProducer: SignalProducer<Int, NoError>!
    
    public init() {
        signalProducer = SignalProducer { [unowned self] observer, _ in
            observer.sendNext(5)
            self.number = 5
        }
    }
    
    deinit {
        print("Deiniting foo")
    }
    
}
//: okay, now we have an instance of Foo:
var foo: Foo? = Foo()
print(foo?.number)
foo = nil
//: Yeah! Foo deinitialized itself correctly.
//:
//: So every time you pass a closure that will be retained, you need to analize if you have to add unowned (or weak) self.
//:
//: Both unowned and weak makes the reference to self "weak". This means that we end up with a self?. 
//: * weak self: we remain with self?, so it's an optional, and we need to unwrapp it inside the closure.
//: * unowned self: the compiler explicitly does this self!, so it assumes it has an instance.
//:
//: There is no rule like use unowned or use weak, it depends on the context. 
//: We generally use unowned self if we know that the instance will be alive whenever the closure that is retaining it is executed. There are some particular cases in which self could be nil when the closure is called. You should use weak in those cases.
//:
//: *** Disposables
//:
//: We've used in other places of this tutorial objects called "Disposables". They are a way of manually manipulating the lifetime of SignalProducer and Signal*.
//:
//: Let's look at the previous example again.
public class Foo2 {
    
    public private(set) var number: Int = 4
    
    public private(set) var signalProducer: SignalProducer<Int, NoError>!
    
    public init() {
        signalProducer = SignalProducer { observer, _ in
            observer.sendNext(5)
            self.number = 5
        }
    }
    
    deinit {
        print("Deiniting foo2")
    }
    
}


//: [Next](@next)
