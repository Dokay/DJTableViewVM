DJTableViewVM
==========

![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)
![Pod version](https://img.shields.io/cocoapods/v/DJTableViewVM.svg?style=flat)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform info](https://img.shields.io/cocoapods/p/DJTableViewVM.svg?style=flat)](http://cocoadocs.org/docsets/DJTableViewVM)

## What

__DJTableViewVM is a lightweight ViewModel implementation for UITableView.__

## Features
* less code and more flexible to show data with UITableView;
* easy to control cell bottom line;
* prefetch for iOS under iOS 10;
* cell height dynamic caculate;
* cell height pre caculate.
* keyboard shows and input view scroll automatically.

## Requirements
* Xcode 7 or higher
* Apple LLVM compiler
* iOS 7.0 or higher
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
    self.aDJTableViewVM.preCaculateHeightEnable = YES;

    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"AutoLayoutWithNib"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
        NSInteger random = arc4random() % kConstContent.length;
        random = MAX(10, random);
        DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
        row.heightCaculateType = DJCellHeightCaculateAutoLayout;
        row.contentText = [kConstContent substringToIndex:random];
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

* API
<table>
  <tr><th colspan="2" style="text-align:center;">Key Classes</th></tr>
  <tr>
    <td>DJTableViewVM</td>
    <td>The ViewModel for <tt>UITableView</tt>, which has implemented UITableViewDelegate & UITableViewDataSource. It has multiple <tt>DJTableViewVMSection</tt> sections.</td>
  </tr>
  <tr>
    <td>DJTableViewVMSection</td>
    <td>The ViewModel for sections in <tt>DJTableViewVM</tt>, each section has multiple <tt>DJTableViewVMRow</tt> rows.</td>
  </tr>
  <tr>
    <td>DJTableViewVMRow</td>
    <td>The ViewModel for row in sections,it is the root class of all <tt>DJTableViewVM</tt> row hierarchies.<br />
        You should subclass <tt>DJTableViewVMRow</tt> to obtain cell characteristics specific to your application's needs.
        Through <tt>DJTableViewVMRow</tt>, rows inherit a basic interface that communicates with <tt>DJTableViewVM</tt> and <tt>DJTableViewVMSection</tt>.</td>
  </tr>
  <tr>
    <td>DJTableViewVMCell</td>
    <td>The Cell(View) for DJTableViewVMRow(ViewModel),it defines the attributes and behavior of the cells that appear in <tt>UITableView</tt> objects.
        You should subclass <tt>DJTableViewVMCell</tt> to obtain cell characteristics and behavior specific to your application's needs.
        By default, it is being mapped with <tt>DJTableViewVMRow</tt>.</td>
  </tr>
  <tr>
    <td>DJInputRowProtocol</td>
    <td>The Protocol that all input Rows (such cell with UITextField/UITextView/UIDataPicker) has to implemented.By default,<tt>DJTableViewVMTextFieldRow</tt> and <tt>DJTableViewVMTextViewRow</tt> implement it.You can implement it for your input view in cell.</td>
  </tr>
  <tr>
    <td>DJTableViewVMTextFieldRow</td>
    <td>The ViewModel for DJTableViewVMTextFieldCell.</td>
  </tr>
  <tr>
    <td>DJTableViewVMTextFieldCell</td>
    <td>Cell with a UITextField.If you want keyboard(showed by the UITextField) be managed by <tt>DJTableViewVM</tt>,property keyboardManageEnabled in <tt>DJTableViewVM</tt> should be set YES.By default, it is being mapped with <tt>DJTableViewVMTextFieldRow</tt>.</td>
  </tr>
  <tr>
    <td>DJTableViewVMTextViewRow</td>
    <td>The ViewModel for DJTableViewVMTextViewCell.</td>
  </tr>
  <tr>
    <td>DJTableViewVMTextViewCell</td>
    <td>Cell with a UITextView.If you want keyboard(showed by the UITextView) be managed by <tt>DJTableViewVM</tt>,property keyboardManageEnabled in <tt>DJTableViewVM</tt> should be set YES.By default, it is being mapped with <tt>DJTableViewVMTextFieldRow</tt>.</td>
  </tr>
</table>

* For exsist cells in your project<br />1.If the super class of your cell is UITableViewCell ,just change it to DJTableViewVMCell.<br />2.If tht super class of your cell is your custom class ,you need to implement the protocol DJTableViewVMCellDelegate or change it to DJTableViewVMCell.<br />

##UICollectionView
    
ViewModel for UICollectionView: [DJCollectionViewVM](http://github.com/Dokay/DJCollectionViewVM)


## Contact

Dokay Dou

- https://github.com/Dokay
- http://www.douzhongxu.com
- dokay_dou@163.com

## License

DJTableViewVM is available under the MIT license.


