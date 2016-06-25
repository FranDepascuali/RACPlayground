//: [Previous](@previous)

import UIKit
import Result
import ReactiveCocoa

//: ## Chaining Asynchronous operations
//:
//: We will see how to chain asynchronous operations. This is what I found one of the greatest features of RAC. Once you understand it, it makes a lot of sense and you will use it a lot. 
//:
//: Let's suppose that we have to fetch Users and for each User, we need to fetch its tweets. These are two asynchronous operations. How would we model it with RAC?
//: They are both `SignalProducer`, but we haven't seen any way to chain SignalProducers.
//:

public struct Tweet {
    
    public let content: String
    
}

public struct User {
    
    public let name: String
}

// Suppose that this is an async operation
public func signUp(name: String) -> SignalProducer<User, NoError> {
    return SignalProducer<User, NoError> { observer, _ in
        observer.sendNext(User(name: name))
        observer.sendCompleted()
    }
}

// Suppose that this is an async operation
public func fetchTweets(user: User) -> SignalProducer<[Tweet], NoError> {
    return SignalProducer<[Tweet], NoError> { observer, _ in
        let tweets = [Tweet(content: "Hello user \(user.name)"), Tweet(content: "xcode crashing again?")]
        observer.sendNext(tweets)
        observer.sendCompleted()
    }
}
//: Okay, now how do we chain them? Meaning that every time I fetch a User, I want to fetch its tweets?
//:
//: There is a function that allows us to chain producers. It is called flatMap(), both for Signal and SignalProducer.
//: It has the following signature:
//: public func flatMap<U>(
//:    strategy: ReactiveCocoa.FlattenStrategy,
//:    transform: Self.Value -> ReactiveCocoa.SignalProducer<U, Self.Error>) -> ReactiveCocoa.SignalProducer<U, Self.Error>
//:
//: Let us try some examples:
print("---------------(1)---------------")
let _chainedProducers = signUp("bob")
    .flatMap(
        FlattenStrategy.Latest,
        transform: { user -> SignalProducer<[Tweet], NoError> in
            return fetchTweets(user)
    })
//: We provided the strategy and the transform function. I will now write it in a more swifty way.

let chainedProducers = signUp("bob").flatMap(.Latest, transform: fetchTweets)
//: They are both equivalent.
//: Now, let us start chainedProducers (it is a SignalProducer) and look what happens.
chainedProducers.startWithNext { tweets in
    print("Tweets: \(tweets)")
}
//: Great! It fetched the user and then fetched the tweets, we could chain those SignalProducers.
//: Now, let us see some other cases:

print("---------------(2)---------------")
let _currentUser = MutableProperty(User(name: "john"))
let chainedProducers2 = _currentUser.producer.flatMap(.Latest, transform: fetchTweets)
//: let's see what happens when we start the chainedProducers2.
chainedProducers2.startWithNext { tweets in
    print("Tweets: \(tweets)")
}
print("---------------(3)---------------")
//: It printed the tweets for john. Now, suppose that we change the user john to the user emily. We want it to fetch the tweets for emily.
_currentUser.value = User(name: "emily")
//: Great! When the user changed to "emily", it fetched the tweets for emily. One more time:
print("---------------(4)---------------")
_currentUser.value = User(name: "tyrion")
//:
//: I will now explain what flatMap do.
//: The producer for which we call .flatMap() is the outer producer (here the producer that exposes the User). The inner producer is in this case the producer for the Tweets.
//:
//: FlattenStrategy is the strategy we want for manipulating the values. We have three options:
//:* .Latest: It will output only the events from the last inner producer. This is what we've beeng using. 
//:
//: This means that whenever we change a user, for example emily to tyrion, it only emits values corresponding from the last inner producer (remeber inner producer is fetchTweets), so it only emits the values from tyrion. If we change again to another User, let's say Bob, it will only emit the tweets for bob.
//:
//:* .Concat: "The producers should be concatenated, so that their values are sent in the order of the producers themselves."
//:
//:* .Merge:  "The producers should be merged, so that any value received on any of the inner producers will be forwarded immediately to the outer producer."

//: I need to manually manipulate the producers, so I will use .buffer() again.

let (currentUser, currentUserObserver) = SignalProducer<User, NoError>.buffer(0)

let (emilyTweets, emilyTweetsObserver) = SignalProducer<Tweet, NoError>.buffer(0)

let (tyrionTweets, tyrionTweetsObserver) = SignalProducer<Tweet, NoError>.buffer(0)


//: Here we have three streams of information:
//: * currentUser, which emits the current user.
//: emily -> tyrion -> bob -> etc..
//: * emilyTweets, which emits the tweets of emily.
//: emilytweet1 -> emilytweet2 -> emilytweet3 -> etc...
//: * tyrionTweets, which emits the tweets of tyrion.
//: tyrionTweet1 -> tyrionTweet2 -> tyrionTweet3 -> etc...
//:
//: What I will do is to manipulate these streams to show the different between .Latest, .Concat, .Merge

print("---------------(5)---------------")
print("strategy: .Latest")

let latestChainedProducers = currentUser.flatMap(.Latest) { user -> SignalProducer<Tweet, NoError> in
    if user.name == "emily" {
        return emilyTweets
    } else if user.name == "tyrion" {
        return tyrionTweets
    }
    
    return SignalProducer.empty
}

let latestdisposable = latestChainedProducers.startWithNext { tweets in
    print(".Latest Tweets: \(tweets)")
}

//: 1) We emit a tweet for emily
//: 2) We change user to tyrion
//: 3) We send a new tweet for EMILY
//: 4) We send a tweet from tyrion

currentUserObserver.sendNext(User(name: "emily"))
emilyTweetsObserver.sendNext(Tweet(content: "Hello! I'm emily"))
currentUserObserver.sendNext(User(name: "tyrion"))
emilyTweetsObserver.sendNext(Tweet(content: "Hello @tyrion!"))
//: What happened?
//: The tweet "Hello @tyrion!" didn't show in the console because we are using .Latest strategy. This means that it switched to Tyrion, and now it emits only the tweets from tyrion
//:
//: Now, let's send a tweet from tyrion
tyrionTweetsObserver.sendNext(Tweet(content: "Hello! I'm tyrion"))
//: It did appear because it switched to Tyrion, so it only emits tyrion tweets.
//:
latestdisposable.dispose()

print("---------------(6)---------------")
print("strategy: .Merge")
let mergeChainedProducers = currentUser.flatMap(.Merge) { user -> SignalProducer<Tweet, NoError> in
    if user.name == "emily" {
        return emilyTweets
    } else if user.name == "tyrion" {
        return tyrionTweets
    }
    
    return SignalProducer.empty
}

let mergedDisposable = mergeChainedProducers.startWithNext { tweets in
    print(".Merge Tweets: \(tweets)")
}

//: 1) We emit a tweet for emily
//: 2) We change user to tyrion
//: 3) We send a new tweet for EMILY
//: 4) We send a tweet from tyrion

currentUserObserver.sendNext(User(name: "emily"))
emilyTweetsObserver.sendNext(Tweet(content: "Hello! I'm emily"))
currentUserObserver.sendNext(User(name: "tyrion"))
emilyTweetsObserver.sendNext(Tweet(content: "Hello @tyrion!"))
tyrionTweetsObserver.sendNext(Tweet(content: "Hello! I'm tyrion"))
//: What happened?
//: We are using .Merge strategy, so all the tweets emitted from both Tyrion and Emily go to the outer producer, in the order in which they both arrived.

mergedDisposable.dispose()
print("---------------(7)---------------")
print("strategy: .Concat")

let concatChainedProducers = currentUser.flatMap(.Concat) { user -> SignalProducer<Tweet, NoError> in
    if user.name == "emily" {
        return emilyTweets
    } else if user.name == "tyrion" {
        return tyrionTweets
    }
    
    return SignalProducer.empty
}

concatChainedProducers.startWithNext { tweets in
    print(".Concat Tweets: \(tweets)")
}

//: 1) We emit a tweet for emily
//: 2) We change user to tyrion
//: 3) We send a new tweet for EMILY
//: 4) We send a tweet from tyrion

currentUserObserver.sendNext(User(name: "emily"))
emilyTweetsObserver.sendNext(Tweet(content: "Hello! I'm emily"))
currentUserObserver.sendNext(User(name: "tyrion"))
emilyTweetsObserver.sendNext(Tweet(content: "Hello @tyrion!"))
tyrionTweetsObserver.sendNext(Tweet(content: "Hello! I'm tyrion"))
//: What happened? .Concat sends value in order, so it waits until the tweets emitted by emily completes. Then, it will switch to tyrion tweets.
//: Let us send a .Completed to emily tweets stream and see what happens
//:
print("sending Completed to emily's tweets")
emilyTweetsObserver.sendCompleted()
tyrionTweetsObserver.sendNext(Tweet(content: "Hello! I'm tyrion. My latest tweet wasn't published!"))
//:
//: We lost the first tweet from tyrion because emily's tweets were stil active (it didn't completed). When we send completed to Emily, we started observing the values emitted by Tyrion producer.
//:
//: So this is how we chain producers with RAC. flatMap can be used also with signals; just remember that we observe signals and do not start them, it can lead to some issues when observing values if the signal already emitted some values that we missed...
//: flatMap is **EXTREMELY** useful. I spent some time learning about it, until one moment I made the click and it was "AHA!". 
//:
//: Tip: Whenever you are starting a producer in the next block of another producer, it is a hint that you should be using flatMap().

let producer1 = SignalProducer<Int, NoError>(value: 4)
let producer2 = SignalProducer<String, NoError>(value: "hello")

// You shouldn't do this
producer1.startWithNext { _ in
    producer2.start()
}

//:
//: [Next](@next)
//:
//: ----
//: ### Further Info
//: Just a detail. If you've noticed it, if you ignore the strategy for flatMap() it looks like the flatMap from Optional. It also looks similar to the flatMap() from array.
//:
//: Look at this:
//:
//: **Optional**:
//:
//: public func flatMap<U>(f: Wrapped -> U?) -> U?
//:
//: **Array**:
//:
//: public func flatMap<T>(transform: Element -> [T]) rethrows -> [T]
//:
//: **RAC**:
//:
//: public func flatMap<U>(
//:    strategy: ReactiveCocoa.FlattenStrategy,
//:    transform: Self.Value -> ReactiveCocoa.SignalProducer<U, Self.Error>) -> ReactiveCocoa.SignalProducer<U, Self.Error>
//:
//: Optional, Array, SignalProducer, etc... are all "contexts" for which we can apply operations.
//:
//: flatMap receives a function will take an element, applies a transformation to it and returns it in the same context (Optional, Array, SignalProducer, etc...).
//: [This post](http://www.mokacoding.com/blog/functor-applicative-monads-in-pictures/) is really GREAT to understand flatMap, one of the best posts I've read.
//:
//: [Next](@next)
