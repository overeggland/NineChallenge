//
//  NineChallengeUITests.swift
//  NineChallengeUITests
//
//  Created by Xavier Zhang on 6/7/2023.
//

import XCTest

final class NineChallengeUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Test navigation
    func testNavigation() {
        // 0
        app.launch()
        // 1
        let cells = app.collectionViews.element(boundBy:0).cells
        if cells.count > 0 {
           cells.element(boundBy: 0).tap()
        }
        sleep(3)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        let titleLabel = app.navigationBars.staticTexts.firstMatch
        let title = titleLabel.label
        XCTAssertTrue(title.contains("iPad"))
    }
    
    //Test scroll
    func testScroll() {
        app.launch()
        
        let scrollView = app.collectionViews.element(boundBy: 0)
        
        scrollView.swipeUp(velocity: .fast)
        
        sleep(2)
        
        scrollView.swipeUp()
        
        sleep(1)
        
        scrollView.swipeDown()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
