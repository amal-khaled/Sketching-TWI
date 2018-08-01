//
//  DrawingImage.swift
//  Sketching-TWI
//
//  Created by Amal Khaled on 8/1/18.
//  Copyright © 2018 TWI. All rights reserved.
//

import UIKit

class DrawImage: UIImageView {
  
        var isDrawing = false
        var lines: Array = [Line]()
        var undoList : Array = [Line]()
        var lastPoint : CGPoint!
        
        
        // Only override draw() if you perform custom drawing.
        // An empty implementation adversely affects performance during animation.
        override func draw(_ rect: CGRect) {
            // Drawing code
            let context = UIGraphicsGetCurrentContext()
            //        CGContextBeginePath(context)
            
            context?.beginPath()
            
            for line in lines{
                context?.move( to: line.start)
                context?.addLine(to: line.end)
                
            }
            context?.setLineCap(CGLineCap.round)
            context?.setStrokeColor(UIColor.red.cgColor)
            context?.strokePath()
            
        }
        
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard !isDrawing else {
                return
            }
            isDrawing = true
            guard let touch = touches.first else {return}
            lastPoint = touch.location(in: self)
            
            print(lastPoint)
            
        }
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard isDrawing else {
                return
            }
            guard let touch = touches.first else {return}
            
            let newPoint = touch.location(in: self)
            lines.append(Line(start: lastPoint ,end: newPoint))
            lastPoint = newPoint
            self.setNeedsDisplay()
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard isDrawing else {
                return
            }
            isDrawing = false
            
            guard let touch = touches.first else {return}
            
            let newPoint = touch.location(in: self)
            lines.append(Line(start: lastPoint ,end: newPoint))
            lastPoint = nil
            //        lastPoint = newPoint
            
            self.setNeedsDisplay()
        }
        
        
    }
//    extension DrawImage {
//        func getImage()-> UIImage{
//            return UIImage(view: self)
//        }
//    }
//
//    extension UIImage {
//        convenience init(view: UIView) {
//            UIGraphicsBeginImageContext(view.frame.size)
//            view.layer.render(in:UIGraphicsGetCurrentContext()!)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            self.init(cgImage: image!.cgImage!)
//        }
//}
//
