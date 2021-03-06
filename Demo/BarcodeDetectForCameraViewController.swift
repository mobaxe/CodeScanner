//
//  BarcodeDetectForCameraViewController.swift
//  CodeScanner
//
//  Created by 須藤 将史 on 2017/02/17.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit
import AVFoundation
import CodeScanner

final class BarcodeDetectForCameraViewController: UIViewController {
    
    private var scanner: CodeScanner!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Detect barcode by camera"
        self.view.backgroundColor = .groupTableViewBackground
        
        self.scanner = CodeScanner(metadataObjectTypes: [.ean8, .ean13, .code128], preview: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CodeScanner.requestCameraPermission { (success) in
            if success {
                self.scanner.scan(resultOutputs: { (outputs) in
                    
                    print(outputs)

                    if let output: String = outputs.first {

                        if output.isJANLowerBarcode() {
                            return
                        }
                        
                        if let isbn = output.convartISBN() {
                            self.scanner.stop()
                            isbn.searchAamazon()
                        }
                    }
                })
            }
        }
    }
}
