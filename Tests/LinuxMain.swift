import XCTest

import ReflectionTests

var tests = [XCTestCaseEntry]()
tests += MirrorExtensionTests.allTests()
tests += ReflectionTests.allTests()
XCTMain(tests)
