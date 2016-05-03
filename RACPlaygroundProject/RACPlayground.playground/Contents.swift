//: Playground - noun: a place where people can play

import UIKit
import Result
import ReactiveCocoa
// Uncomment this for indefiniteExecution
//import XCPlayground

//XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

var str = "Hello, playground"

let a = SignalProducer<Int, NoError>.buffer(0)

a.0.startWithNext { print("value: \($0)") }

a.1.sendNext(4)
a.1.sendNext(5)
