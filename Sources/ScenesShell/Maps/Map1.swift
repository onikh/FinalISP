import Scenes
import Igis
import Foundation
  /*
     This class is responsible for rendering the background.
   */


class Map1 : RenderableEntity, KeyDownHandler {



    
    // Intro Area/Map1
    let map1 : Image
    var destrect : Rect
    var sourcerect : Rect
    let audio : Audio
    var active = true
    
    var sourceheight : Int
    var sourcewidth : Int

    //Canvas Data
    var canrender = false
    var canvasratio : Double

    // Containment Testing
    var characterboundingrect : Rect

    var testrect : Rect
    var testrect2 : Rect
    var testrect3 : Rect
    var testrect4 : Rect
    var testrect5 : Rect
    var testrect6 : Rect
    var testrect7 : Rect
    var testrect8 : Rect
    
    var canvaswidth : Int
    var canvasheight : Int
   
    //movement locking
    var lockedup = false
    var lockeddown = false
    var lockedleft = false
    var lockedright = false
    var mvmtlocked = false
    
    
    

    init() {

        guard let map1url = URL(string:"https://github.com/onikh/ISPData/blob/main/finalmap1.png?raw=true") else {
            fatalError("Failed to create URL for map1")
        }

        guard let AudioURL = URL(string:"https://github.com/onikh/ISPData/blob/main/map1audio.mp3?raw=true") else {
            fatalError("Failed to create URL for audio")
        }
        
        map1 = Image(sourceURL:map1url)
        audio = Audio(sourceURL:AudioURL)
        
        destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        sourcerect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        testrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testrect2 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testrect3 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testrect4 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testrect5 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1)) 
        testrect6 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testrect7 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        testrect8 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        
        characterboundingrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        
        canvasratio = 0.0
        sourceheight = 0
        sourcewidth = 0
        canvaswidth = 0
        canvasheight = 0
        


        
          // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")
    }

   
override func setup(canvasSize:Size, canvas:Canvas) {
    canvas.setup(map1)
    canvas.setup(audio)


    // canvas setup
    
    if let canvasSize = canvas.canvasSize {
        canvasratio = Double(canvasSize.width)/Double(canvasSize.height)
        sourceheight = 200
        sourcewidth = Int(Double(sourceheight)*canvasratio)

        let heightratio = Double(canvasSize.height)/Double(sourceheight)
        let widthratio = Double(canvasSize.height)/(Double(sourceheight)*canvasratio)
          
          canrender = true


        //map1
        destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:canvasSize.width, height:canvasSize.height))
        sourcerect = Rect(topLeft:Point(x:208-(sourcewidth/2), y:376-(sourceheight/2)), size:Size(width:sourcewidth, height:sourceheight))

        //keyhandler setup
        dispatcher.registerKeyDownHandler(handler:self)

        
        print("Canvas Height to Width Ratio:", canvasratio)
        print("Canvas Height: \(canvasSize.height)")
        print("Canvas Width: \(canvasSize.width)")
        print("")
        
        print("Canvas to Displayed Source Image Height Ratio: \(heightratio)")
        print("Canvas to Displayed Source Image Width Ratio: \(widthratio)")
        print("Resolution in game: \(sourcerect.width)x\(sourcerect.height)")
        print("")
        print("")
        print("Left Edge: \(208-(sourcewidth/2))")
        print("Right Edge: \(208+(sourcewidth/2))")
      
        

        func generateBoundingRect(xpoint:Int, ypoint:Int, width:Int, height:Int) -> Rect {
            let rect = Rect(topLeft:Point(x: Int((Double(xpoint - Int(208-(sourcewidth/2)))/Double(sourcerect.width))*Double(canvasSize.width)), y:Int((Double(ypoint-275)/200.0)*Double(canvasSize.height))), size:Size(width:Int((Double(width)/Double(sourcerect.width))*Double(canvasSize.width)), height:Int((Double(height)/Double(200))*Double(canvasSize.height))))
            return rect
        }

        func generateBoundingOffset(xtoreach:Int, ytoreach:Int) -> Point {
            let stepspermovey = Double(canvasSize.height)/(Double(sourceheight)/2.0)
            let losspery = stepspermovey.truncatingRemainder(dividingBy:1.0)
            let totalyloss = (Double(ytoreach)/2.0)*losspery

            let stepspermovex = Double(canvasSize.width)/(Double(sourcewidth)/2.0)
            let lossperx = stepspermovex.truncatingRemainder(dividingBy:1.0)
            let totalxloss = (Double(xtoreach)/2.0)*lossperx

            return Point(x: Int(totalxloss), y: Int(totalyloss))
        }
            
            
        


        //Containment
        let stepspermovey = Double(canvasSize.height)/(Double(sourceheight)/2.0)
        let losspery = stepspermovey.truncatingRemainder(dividingBy:1.0)

        let stepspermovex = Double(canvasSize.width)/(Double(sourcewidth)/2.0)
        let lossperx = stepspermovex.truncatingRemainder(dividingBy:1.0)

        characterboundingrect = generateBoundingRect(xpoint:211, ypoint:389, width:14, height:7)
        
          
        testrect = generateBoundingRect(xpoint:208, ypoint:405, width:120, height:30)
        testrect2 = generateBoundingRect(xpoint:192, ypoint:376, width:16, height:30)
        testrect3 = generateBoundingRect(xpoint:208, ypoint:96, width:80, height:279)
        testrect4 = generateBoundingRect(xpoint:320, ypoint:303, width:145, height:102)
        testrect5 = generateBoundingRect(xpoint:464, ypoint:128, width:16, height:176)
        testrect6 = generateBoundingRect(xpoint:336, ypoint:144, width:138, height:16)
        testrect7 = generateBoundingRect(xpoint:320, ypoint:96, width:16, height:62)
        testrect8 = generateBoundingRect(xpoint:320, ypoint:176, width:112, height:112) 

        testrect.topLeft -= generateBoundingOffset(xtoreach:-4, ytoreach:15)
        testrect2.topLeft -= generateBoundingOffset(xtoreach:-10, ytoreach:-6)
        testrect3.topLeft -= generateBoundingOffset(xtoreach:76, ytoreach:-2)
        testrect4.topLeft -= generateBoundingOffset(xtoreach:98, ytoreach:-92)
        testrect5.topLeft -= generateBoundingOffset(xtoreach:242, ytoreach:-91)
        testrect6.topLeft -= generateBoundingOffset(xtoreach:113, ytoreach:-220)
        testrect7.topLeft -= generateBoundingOffset(xtoreach:94, ytoreach:-237)
        testrect8.topLeft -= generateBoundingOffset(xtoreach:98, ytoreach:-93)

        testrect8.width -= Int(62.0*lossperx)
        
        testrect8.topLeft.y += Int(68.0*losspery)
        testrect8.height -= Int(68.0*losspery)
        
        canvaswidth = canvasSize.width
        canvasheight = canvasSize.height
    }
}

override func teardown() {
    dispatcher.unregisterKeyDownHandler(handler:self)
}



override func render(canvas:Canvas) {

    if map1.isReady && canrender && active {
        map1.renderMode = .sourceAndDestination(sourceRect:sourcerect, destinationRect:destrect)
        canvas.render(map1)

        /*

        canvas.render(Rectangle(rect:characterboundingrect, fillMode:.stroke))

        canvas.render(Rectangle(rect:testrect, fillMode:.stroke))
        canvas.render(Rectangle(rect:testrect2, fillMode:.stroke))
        canvas.render(Rectangle(rect:testrect3, fillMode:.stroke))
        canvas.render(Rectangle(rect:testrect4, fillMode:.stroke))
        canvas.render(Rectangle(rect:testrect5, fillMode:.stroke))
        canvas.render(Rectangle(rect:testrect6, fillMode:.stroke))
        canvas.render(Rectangle(rect:testrect7, fillMode:.stroke))
        canvas.render(Rectangle(rect:testrect8, fillMode:.stroke))
        */
        audio.mode = .play
    } else {
        audio.mode = .pause
    }

    if audio.isReady {

        canvas.render(audio)
    }

}
//////////////////////////
override func calculate(canvasSize:Size) {
    let rect1containment = testrect.containment(target:characterboundingrect)
    let rect2containment = testrect2.containment(target:characterboundingrect) 
    let rect8containment = testrect8.containment(target:characterboundingrect)
    let rect3containment = testrect3.containment(target:characterboundingrect) 
    let rect4containment = testrect4.containment(target:characterboundingrect)
    let rect5containment = testrect5.containment(target:characterboundingrect)  
    let rect6containment = testrect6.containment(target:characterboundingrect)
    let rect7containment = testrect7.containment(target:characterboundingrect)


    
    if (!rect1containment.intersection([.overlapsTop]).isEmpty && rect1containment.contains(.contact)) || (!rect8containment.intersection([.overlapsTop]).isEmpty && rect8containment.contains(.contact)) || (!rect4containment.intersection([.overlapsTop]).isEmpty && rect4containment.contains(.contact))  {
        lockeddown = true
    } else {
        lockeddown = false
    }

    if (!rect2containment.intersection([.overlapsRight]).isEmpty && rect2containment.contains(.contact)) || (!rect3containment.intersection([.overlapsRight]).isEmpty && rect3containment.contains(.contact)) || (!rect8containment.intersection([.overlapsRight]).isEmpty && rect8containment.contains(.contact)) {
        lockedleft = true
    } else {
        lockedleft = false
    }

    if (!rect3containment.intersection([.overlapsBottom]).isEmpty && rect3containment.contains(.contact)) || (!rect6containment.intersection([.overlapsBottom]).isEmpty && rect6containment.contains(.contact)) || (!rect8containment.intersection([.overlapsBottom]).isEmpty && rect8containment.contains(.contact)) || (!rect7containment.intersection([.overlapsBottom]).isEmpty && rect7containment.contains(.contact)) {
        lockedup = true
    } else {
        lockedup = false
    }

    if (!rect4containment.intersection([.overlapsLeft]).isEmpty && rect4containment.contains(.contact)) || (!rect5containment.intersection([.overlapsLeft]).isEmpty && rect5containment.contains(.contact)) || (!rect7containment.intersection([.overlapsLeft]).isEmpty && rect7containment.contains(.contact)) || (!rect8containment.intersection([.overlapsLeft]).isEmpty && rect8containment.contains(.contact)) {
        lockedright = true
    } else {
        lockedright = false
    }

}


func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
    if active {



        

        //boundingrect movement

        if !mvmtlocked {

        
 
        if code == "ArrowUp" && sourcerect.topLeft.y > 0 && !lockedup {
            sourcerect.topLeft.y -= 2
            testrect.topLeft.y += Int(Double(canvasheight)/100.0)
            testrect2.topLeft.y += Int(Double(canvasheight)/100.0)
            testrect3.topLeft.y += Int(Double(canvasheight)/100.0)
            testrect4.topLeft.y += Int(Double(canvasheight)/100.0)
            testrect5.topLeft.y += Int(Double(canvasheight)/100.0)
            testrect6.topLeft.y += Int(Double(canvasheight)/100.0)
            testrect7.topLeft.y += Int(Double(canvasheight)/100.0)
            testrect8.topLeft.y += Int(Double(canvasheight)/100.0)
          }
   
        if code == "ArrowDown" && sourcerect.bottomLeft.y < 563 && !lockeddown {
            sourcerect.topLeft.y += 2
            testrect.topLeft.y -= Int(Double(canvasheight)/100.0)
            testrect2.topLeft.y -= Int(Double(canvasheight)/100.0)
            testrect3.topLeft.y -= Int(Double(canvasheight)/100.0)
            testrect4.topLeft.y -= Int(Double(canvasheight)/100.0)
            testrect5.topLeft.y -= Int(Double(canvasheight)/100.0)
            testrect6.topLeft.y -= Int(Double(canvasheight)/100.0)
            testrect7.topLeft.y -= Int(Double(canvasheight)/100.0)
            testrect8.topLeft.y -= Int(Double(canvasheight)/100.0)
        }

        if code == "ArrowRight" && sourcerect.bottomRight.x < 703 && !lockedright {
            sourcerect.topLeft.x += 2
            testrect.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect2.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect3.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect4.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect5.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect6.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect7.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect8.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
        }

        if code == "ArrowLeft" && sourcerect.topLeft.x > 2 && !lockedleft {
            sourcerect.topLeft.x -= 2
            testrect.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect2.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect3.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect4.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect5.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect6.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect7.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            testrect8.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
        }

        }

    }
    
    
        

        

    }

}
                   






