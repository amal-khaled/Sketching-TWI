//
//  ViewController.swift
//  Sketching-TWI
//
//  Created by Amal Khaled on 7/31/18.
//  Copyright © 2018 TWI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var drawingView: DrawView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func redoTaped(_ sender: Any) {
        guard let lastElement = drawingView.undoList.popLast() else {return}
        drawingView.lines.append( lastElement)
        drawingView.setNeedsDisplay()
    }
    @IBAction func undoTapped(_ sender: Any) {
        guard let lastElement =  drawingView.lines.popLast() else {return}
        drawingView.undoList.append( lastElement)
        drawingView.setNeedsDisplay()

    }
}

