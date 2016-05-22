//: [Previous](@previous)

import UIKit
import Result
import ReactiveCocoa

//: Right now, we've seen ***Events***, ***Signals*** and ***SignalProducers***. We will now see a real aplications of ***SignalProducers***.
//:
//: Let's assume we are building an application and we are going to develop the sign up requirement. I'll avoid using RAC first.
//:
//: We model our User:
    public struct User {
        
        public let email: String
        
    }
//: And the following UserRepositoryType protocol:
    public protocol UserRepositoryType {
        
        func signUp(
            email: String,
            password: String,
            onSuccess: User -> (),
            onFailure: NSError -> ())

    }
//: signUp receives an email, a password and a function to be call in successful sign up and another one for failure.
//: We can now provide an implementation for UserRepository:
    public final class UserRepository: UserRepositoryType {
        
        public func signUp(email: String, password: String, onSuccess: User -> (), onFailure: NSError -> ()) {
            MockExternalPersistanceService()
                .signUp(email, password: password) { maybeUser, maybeError in
                if let error = maybeError {
                    onFailure(error)
                } else if let user = maybeUser {
                    onSuccess(user)
                }
            }
            
        }
    }
//: Here we are mocking the ExternalPersistanceService, it will be a real one in production.
    public class MockExternalPersistanceService {
        
        func signUp(email: String, password: String, callBack: (User?, NSError?) -> ()) {
            callBack(User(email: email), nil)
        }
    }

    print("---------------(1)---------------")

    UserRepository().signUp(
        "user@gmail.com",
        password: "password",
        onSuccess: { user in print("callback user: \(user)") },
        onFailure: { _ in () })
//: Now, let's introduce RAC for signing up:
    public protocol RACUserRepositoryType {
        
        func signUp(email: String, password: String) -> SignalProducer<User, NSError>

    }

    public final class RACUserRepository: RACUserRepositoryType {
        
        public func signUp(email: String, password: String) -> SignalProducer<User, NSError> {
            return SignalProducer { observer, disposable in
                MockExternalPersistanceService()
                    .signUp("user@gmail.com", password: "password") { maybeUser, maybeError in
                        if let error = maybeError {
                            observer.sendFailed(error)
                        } else if let user = maybeUser {
                            observer.sendNext(user)
                            observer.sendCompleted()
                        }
                }
            }
        }
    }

//: Here I'm introducing how we initialize SignalProducers (remember that in the previous page we used buffer()). The difference with buffer is that here we don't have an observer outside the initialization of the SignalProducer to send values. 
//:
//: ***WHEN STARTED*** this SignalProducer will make the (asynchronous) request to sign up and then send a new user (or an error if it failed).
//: For example, we can do this
    let signUpProducer = RACUserRepository().signUp("newUser@gmail.com", password: "password")
//: Look at the console. Nothing printed out. This is because we didn't start the producer yet.
    print("---------------(2)---------------")
    signUpProducer.startWithNext { user in
        print("Reactive Cocoa user: \(user)")
    }
//: Now we did start the producer, so we received the user in the startWithNext closure.
//:
//: Could you spot the advantages of RAC approach over callbacks approach?
//: * We have a producer, therefore we can apply transformations (such as map or filter and a lot more) to the user that it emits.
//: * One of those operations that we can apply is to chain different producers, so for example, if we want to fetch a user and then fetch its tweets, RAC provides us a way to do it (I'll come back to it later).
//:
//: You maybe asking yourself why we used SignalProducer instead of Signal?
//:
//: Because with the producer, we decide when to start it. If we have a signal, as soon as we initialize it, it executed the closure. Look at this:
public final class WrongRACUserRepository {
    
    public func signUp(email: String, password: String) -> Signal<User, NSError> {
        return Signal { observer in
            MockExternalPersistanceService()
                .signUp("user@gmail.com", password: "password") { maybeUser, maybeError in
                    print("Making request...")
                    if let error = maybeError {
                        observer.sendFailed(error)
                    } else if let user = maybeUser {
                        observer.sendNext(user)
                        observer.sendCompleted()
                    }
            }
            // Ignore this return
            return .None
        }
    }
}

print("---------------(3)---------------")

let signalSignUp = WrongRACUserRepository().signUp("user@gmail.com", password: "password")
signalSignUp.observeNext {
    user in print("user")
}
//: Why didn't it print a value?
//:
//: This is because as soon as we called signup, the signal executed the closure that we passed through initialization. When we start observing the signal, it already emitted the value.
//:
//: Usually, we want to sign up when pressing a button, so we would have a producer like the one before and start it when pressing the button.
//:
//: This last example represents why Signals are "hot" and SignalProducers are "cold".
//:
//: We already Know what ***Events***, ***Signal*** and ***SignalProducers*** are and we saw a use case for ***SignalProducers***.
//: The next concepts that we will learn are ***MutableProperty*** and ***AnyProperty***.
//:
//: [Next](@next)
