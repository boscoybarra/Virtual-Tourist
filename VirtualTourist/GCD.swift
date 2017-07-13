//
//  GCD.swift
//  VirtualTourist
//
//  Created by J B on 7/13/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func executeOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    func executeOnMain(withDelay timeInSecond: Double, _ updates: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSecond, execute: {
            updates()
        })
    }
}
