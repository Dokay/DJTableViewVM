//
//  DJComponentTableViewVMUITests.m
//  DJComponentTableViewVMUITests
//
//  Created by Dokay on 2017/3/15.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DJComponentTableViewVMUITests : XCTestCase

@end

@implementation DJComponentTableViewVMUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInputCells {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    for (NSInteger i = 0; i < 10; i++) {
        XCUIElementQuery *tablesQuery = app.tables;
        [tablesQuery.staticTexts[@"InsertDemo"] swipeUp];
        
        [tablesQuery.staticTexts[@"TextInputDemo"] tap];
        
        XCTAssertTrue([app.navigationBars.element.identifier isEqualToString:@"Input Test"]);
        
        XCUIElement *textFieldElement = tablesQuery.textFields[@"Please input your name"];
        XCUIElement *textViewElement = [[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"Please input your address"] childrenMatchingType:XCUIElementTypeTextView].element;
        
        if (textFieldElement.exists == NO) {
            [tablesQuery.staticTexts[@"1"] swipeUp];
        }
        
        [textFieldElement tap];
        
        XCUIElement *firstCellIndex0 = tablesQuery.staticTexts[@"0"];
        XCTAssertLessThan(firstCellIndex0.frame.origin.y, 0,@"keyboard has shown and cell with 0 should not be visiable");
        
        [textFieldElement typeText:@"Ftyhgffew"];
        
        XCUIElementQuery *toolbarsQuery = app.toolbars;
        XCUIElement *doneButton = toolbarsQuery.buttons[@"Done"];
        XCUIElement *preButton = [[toolbarsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0];
        XCUIElement *nextButton = [[toolbarsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1];
        
        XCTAssertTrue(doneButton.exists);
        XCTAssertTrue(!preButton.enabled);
        XCTAssertTrue(nextButton.enabled);
        
        [nextButton tap];
        
        XCTAssertTrue(preButton.enabled);
        XCTAssertTrue(!nextButton.enabled);
        
        [preButton tap];
        
        [doneButton tap];
        XCTAssertTrue(!doneButton.exists);
        
        [textViewElement tap];
        XCTAssertLessThan(firstCellIndex0.frame.origin.y, 0,@"keyboard has shown and cell with 0 should not be visiable");
        
        [textViewElement typeText:@"Erty"];
        
        
        [preButton tap];
        XCTAssertTrue(!preButton.enabled);
        XCTAssertTrue(nextButton.enabled);
        XCTAssertLessThan(firstCellIndex0.frame.origin.y, 0,@"keyboard has shown and cell with 0 should not be visiable");
        
        [doneButton tap];
        XCTAssertTrue(!doneButton.exists);
        
        
        [[[[app.navigationBars[@"Input Test"] childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:0] tap];
    }
}



@end
