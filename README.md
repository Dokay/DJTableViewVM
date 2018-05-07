DJTableViewVM
==========

![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)
![Pod version](https://img.shields.io/cocoapods/v/DJTableViewVM.svg?style=flat)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform info](https://img.shields.io/cocoapods/p/DJTableViewVM.svg?style=flat)](http://cocoadocs.org/docsets/DJTableViewVM)

## What

__DJTableViewVM is a lightweight MVVM solution for finsih your pages using UITableView.__

## Features
* less code and more flexible to implement page using UITableView;
* easy to control cell lines;
* prefetch for iOS under iOS 10;
* cell height dynamic caculate;
* cell height pre caculate.
* auto scroll while keyboard showing and hiding.

## Requirements
* Xcode 9 or higher
* Apple LLVM compiler
* iOS 8.0 or higher
* ARC

## Demo

Build and run the `DJComponentTableViewVM.xcodeproj` in Xcode.


## Installation

###  CocoaPods
Edit your Podfile and add DJTableViewVM:

``` bash
pod 'DJTableViewVM'
```
###  Carthage
Edit your Cartfile and add DJTableViewVM:

``` bash
github "Dokay/DJTableViewVM"
```

## Quickstart
* Sample code
```objc
- (void)testTextRowAutoLayoutWithNib
{
    DJTableViewRegister(self.aDJTableViewVM, DJTableViewVMTextTestRow, DJTableViewVMTextTestCell);

    [self.aDJTableViewVM removeAllSections];

    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"AutoLayoutWithNib"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
            DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
            row.contentText = @"This is a test content";
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *rowVM) {
                [rowVM deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
        [section addRow:row];
        }
    }
    [self.aDJTableViewVM reloadData];
}
```
* set default style:
```objc
    [DJTableViewVMRow defaultStyleInstance].titleFont = [UIFont systemFontOfSize:18];
```

##  Key Classes
* DJTableViewVM: ViewModel for UITableView.It has implemented UITableViewDelegate & UITableViewDataSource, and has multiple DJTableViewVMSection sections.
* DJTableViewVMSection: ViewModel for sections in DJTableViewVM,each section has multiple DJTableViewVMRow rows.
* DJTableViewVMRow: ViewModel for rows in sections,it has properties relate to cells.
* DJTableViewVMCell: Cell(View) for DJTableViewVMRow(ViewModel),it defines the attributes and behavior that appear in UITableView.
* DJTableViewVMCellProtocol: Protocol for cell releate to DJTableViewVMRow,DJTableViewVMCell implemented it,if you do not want or can not inherit DJTableViewVMCell, just implement the protocol.
* DJInputRowProtocol: Protocol that all Input Cells (such as cell with UITextField/UITextView/UIDataPicker) implement.DJTableViewVMTextFieldRow and DJTableViewVMTextViewRow implement it.You can implement it for your input view in cells.
* DJPickerProtocol: Protocol that all Picker Cells (such as cell with UIDatePicker/UIPickerView) implemente.DJNormalPickerDelegate and DJRelatedPickerDelegate implement it.You can implement it for your picker view in cells.

* For exsist cells in your project<br />1.If the super class of your cell is UITableViewCell ,just change it to DJTableViewVMCell.<br />2.If tht super class of your cell is your custom class ,you need to implement the protocol DJTableViewVMCellDelegate or change it to DJTableViewVMCell.<br />

## DJCollectionViewVM
    
ViewModel for UICollectionView: [DJCollectionViewVM](http://github.com/Dokay/DJCollectionViewVM)


## Contact

Dokay Dou

- https://github.com/Dokay
- http://www.douzhongxu.com
- dokay_dou@163.com

## License

DJTableViewVM is available under the MIT license.


