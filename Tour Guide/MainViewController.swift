//
//  MainViewController.swift
//  Tour Guide
//
//  Created by Atibhav Mittal on 12/12/16.
//  Copyright © 2016 Ati. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var mainScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let V1: View1 = View1(nibName: "View1", bundle: nil)
        self.addChildViewController(V1)
        self.mainScrollView.addSubview(V1.view)
        V1.didMove(toParentViewController: self)
        
        let V2: View2 = View2(nibName: "View2", bundle: nil)
        self.addChildViewController(V2)
        self.mainScrollView.addSubview(V2.view)
        V2.didMove(toParentViewController: self)
        
        var V2Frame = V2.view.frame
        V2Frame.origin.x = self.view.frame.width
        V2.view.frame = V2Frame
        
        self.mainScrollView.contentSize = CGSize(width: self.view.frame.width*2, height: self.view.frame.height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
