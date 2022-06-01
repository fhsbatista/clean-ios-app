import Foundation
import XCTest

extension XCTestCase {
    func checkMemoryLeak(
        for instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock{ [weak instance] in
            XCTAssertNil(
                instance,
                "A memory leak has been detected. Instance is referencing itself somewhere",
                file: file,
                line: line
            )
        }
    }
}
