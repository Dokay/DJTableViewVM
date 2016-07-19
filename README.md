# DJTableViewVM

__DJTableViewVM is a light ViewModel implementation for UITableView.__

##Features
* less code and more flexible to implement a UITableView;
* dynamic cell height;
* easy to control cell bottom line;
* prefetch for iOS 7.0+;

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

## Quickstart
* Sample code
```objc
- (void)testTextRowFrameLayout
{
    self.aDJTableViewVM[@"DJTableViewVMTextTestRow"] = @"DJTableViewVMTextFrameCell";
    [self.aDJTableViewVM removeAllSections];
    
    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"FrameLayout"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
            DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
            row.heightCaculateType = DJCellHeightCaculateAutoFrameLayout;
            row.contentText = [NSString stringWithFormat:@"%d---%d,TextRowFrameLayout",i,j];
            [row setSelectionHandler:^(DJTableViewVMRow *roff) {
                [roff deselectRowAnimated:YES];
            }];
            [section addRow:row];
        }
    }
    [self.tableView reloadData];
}

- (void)testDefault
{
    [self.aDJTableViewVM removeAllSections];
    
    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"Default"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
            DJTableViewVMRow *row = [DJTableViewVMRow new];
            row.cellHeight = 70;
            if (i == 0) {
                row.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            }
            row.title = [NSString stringWithFormat:@"%d-Default-%d",j,i];
            [row setSelectionHandler:^(DJTableViewVMRow *roff) {
                [roff deselectRowAnimated:YES];
            }];
            [section addRow:row];
        }
    }
    [self.tableView reloadData];
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
    <td>The ViewModel for rows in sections,it is the root class of all <tt>DJTableViewVM</tt> row hierarchies.<br />
        You should subclass <tt>DJTableViewVMRow</tt> to obtain cell characteristics specific to your application's needs.
        Through <tt>DJTableViewVMRow</tt>, rows inherit a basic interface that communicates with <tt>DJTableViewVM</tt> and <tt>DJTableViewVMSection</tt>.</td>
  </tr>
  <tr>
    <td>DJTableViewVMCell</td>
    <td>The View for DJTableViewVMRow(ViewModel),it defines the attributes and behavior of the cells that appear in <tt>UITableView</tt> objects.
        You should subclass <tt>DJTableViewVMCell</tt> to obtain cell characteristics and behavior specific to your application's needs.
        By default, it is being mapped with <tt>DJTableViewVMRow</tt>.</td>
  </tr>
</table>

* For exsist cells in your project
    1.If the super class of your cell is UITableViewCell ,just change it to DJTableViewVMCell.
    2.If tht super class of your cell is your custom class ,you need to implement the protocol DJTableViewVMCellDelegate or change it to DJTableViewVMCell.

    

## Contact

Dokay Dou

- https://github.com/Dokay
- http://www.douzhongxu.com
- dokay_dou@163.com

## License

DJTableViewVM is available under the MIT license.

Copyright © 2016 Dokay Dou.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
