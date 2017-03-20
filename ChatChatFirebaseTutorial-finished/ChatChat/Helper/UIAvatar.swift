//
//  UIAvatar.swift
//  Exclusiv
//
//  Created by Thanh Tran on 10/3/16.
//  Copyright © 2016 SotaTek. All rights reserved.
//

import Foundation
import UIKit

class UIAvatar: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius = self.frame.size.width / 2
    }
}
