//
//  ViewController.swift
//  wheel
//
//  Created by 林祔利 on 2023/4/4.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var wheelUIImage: wheelUIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startWheel(_ sender: Any) {
        wheelUIImage.rotateGradually { resule in
            let alertContoller = UIAlertController(title: "你轉到了\(resule)區塊", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            alertContoller.addAction(okAction)
            self.present(alertContoller,animated: true)
            
        }
    }
    


}

