//: [Previous](@previous)
import UIKit
import ReactiveCocoa
import Rex
import XCPlayground

//: # Use Case
//:
//: In the previous use case, we implemented the logic for sign up.
//:
//: We ended up with something like this:
    public struct User {
        
        public let email: String
        
    }

    public protocol UserRepositoryType {
        
        func signUp(
            email: String,
            password: String,
            onSuccess: User -> (),
            onFailure: NSError -> ())
        
    }

    public protocol RACUserRepositoryType {
        
        func signUp(email: String, password: String) -> SignalProducer<User, NSError>
        
    }

    public final class RACUserRepository: RACUserRepositoryType {
        
        public func signUp(email: String, password: String) -> SignalProducer<User, NSError> {
            return SignalProducer { observer, disposable in
                MockExternalPersistanceService()
                    .signUp(email, password: password) { maybeUser, maybeError in
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

    public class MockExternalPersistanceService {
        
        func signUp(email: String, password: String, callBack: (User?, NSError?) -> ()) {
            callBack(User(email: email), nil)
        }
    }
//: I will now make the UI part of the exercise.
//:
//: I will have two text fields: username and password (these would be in our view).
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
//: Now, I want to now wether the textfields are empty, valid or invalid. What's better than using an **Enum** for that?
    let MinimumLength = 5

    enum InputValidity {
        case Empty
        case Invalid
        case Valid
        
        init(input: String) {
            guard input != "" else {
                self = .Empty
                return
            }
            self = input.characters.count >= MinimumLength ? .Valid : .Invalid
        }
    }
//: Okay, now we want to have two properties which will hold the values of the text fields.
    let username = MutableProperty("")
    let password = MutableProperty("")
//: We use an operator provided by reactive cocoa <~. It is the same as starting the producer/observing a signal and redirect its output to a mutable property
//:
    username <~ usernameTextField.rex_textSignal
    password <~ passwordTextField.rex_textSignal
//:
//: Now whenever we write a value on usernameTextField or passwordTextField, username and password will hold those values.
//:
    username.signal.observeNext {
        print("username: \($0)")
    }

    password.signal.observeNext {
        print("password: \($0)")
    }
//:
//: Okay. Now we want to have a property that combines 

    let usernameValid = username.signal.map(InputValidity.init)
    let passwordValid = password.signal.map(InputValidity.init)

    usernameValid.observeNext {
        print("username input validity: \($0)")
    }

    passwordValid.observeNext {
        print("password input validity: \($0)")
    }
//: And now, we want to create a sign up action, which will be enabled when the input validity of usernameValid and passwordValid is .Valid.
let signUpValidSignal = combineLatest(usernameValid, passwordValid).map { $0 == .Valid && $1 == .Valid }

//: We initialize a new property that will hold the validity of sign up, so we can pass it to the enabledIf().
//:
    let signUpValid = AnyProperty(
        initialValue: false,
        signal: signUpValidSignal)

    signUpValid.producer
        .startWithNext {
            print("signup valid: \($0)")
    }
//:
//:
//: And now we create the sign up action:
//:
    let signUpAction: Action<AnyObject, User, NSError> = Action(enabledIf: signUpValid) { _ in
        return RACUserRepository().signUp("user", password: "password")
    }
//:
    signUpAction.enabled.producer
        .filter { $0 }
        .startWithNext {
            print("sign up enabled: \($0)")
    }

    signUpAction.values
        .observeNext {
            print("user logged in: \($0)")
    }
//: Now, I have my sign up button.
    let signUpButton = UIButton()
//:
//: Last of all, we bind the button to the action.
    signUpButton.rex_pressed.value = signUpAction.unsafeCocoaAction // Ignore the unsafe part.
//:
//: Now, let's sign up with an incorrect user.
    signUpButton.sendActionsForControlEvents(.TouchUpInside)
//: Nothing happened as the action is not enabled.
    print("---------------(1)---------------")
    username.value = "us" // This should be through the textfield text property, but because we are using a playground, it doesn't work.
    print("---------------(2)---------------")
    password.value = "password"// This should be through the textfield text property, but because we are using a playground, it doesn't work.
    print("---------------(3)---------------")
    signUpButton.sendActionsForControlEvents(.TouchUpInside)
//: The username is invalid, so we cannot sign up.
    print("---------------(4)---------------")
    username.value = "validUser"
//: It is valid because length is greater than minimumLength defined previously
//:
//: We can finally sign up:
    signUpButton.sendActionsForControlEvents(.TouchUpInside)
//:
//: > In a real app, the textfields will be in the UIView or the UIViewController. The action would be on the ViewModel and the controller would do the binding between the View's button and the ViewModel action
//:
//: [Next](@next)
