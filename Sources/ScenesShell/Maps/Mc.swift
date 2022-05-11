//wwwww
import Scenes
import Igis
import Foundation



class Mc : RenderableEntity, KeyDownHandler, KeyUpHandler {
    let char : Image
    var chardestrect : Rect
    var charsourcerect : Rect
    var canrender = false
    var mvmttracker = 0
    var rendermc = true
    var mvmtlocked = false

    var caninteract = false
    


    init() {
        guard let charurl = URL(string:"https://github.com/onikh/ISPData/blob/main/spritebase.png?raw=true") else {
            fatalError("Failed to create URL for char")

        }
        char = Image(sourceURL:charurl)
        chardestrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        charsourcerect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        super.init(name:"Mc")
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        if let canvasSize = canvas.canvasSize {
            
            chardestrect = Rect(topLeft:canvasSize.center, size:Size(width:canvasSize.height/10, height:canvasSize.height/10))
            charsourcerect = Rect(topLeft:Point(x:0, y:0), size:Size(width:64, height:64))
            
            canvas.setup(char)
            dispatcher.registerKeyDownHandler(handler:self)
            dispatcher.registerKeyUpHandler(handler:self)
            canrender = true
        }
    }

        override func teardown() {
            dispatcher.unregisterKeyDownHandler(handler:self)
            dispatcher.unregisterKeyUpHandler(handler:self)
        }
            
    

    override func render(canvas:Canvas) {
        if char.isReady && canrender && rendermc {
            char.renderMode = .sourceAndDestination(sourceRect:charsourcerect, destinationRect:chardestrect)
            canvas.render(char)
            
            }
        }
    

    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {

        if !mvmtlocked {
        if code == "ArrowDown" {
            charsourcerect.topLeft.y = 0
            mvmttracker += 1
            if mvmttracker%3 == 0 || mvmttracker < 6 {
                charsourcerect.topLeft.x += 64
            }
            if charsourcerect.topLeft.x > 192 {
                charsourcerect.topLeft.x = 0
            }
        }

        if code == "ArrowLeft" {
            charsourcerect.topLeft.y = 64
            mvmttracker += 1
            if mvmttracker%3 == 0 || mvmttracker < 6 {
                charsourcerect.topLeft.x += 64
            }
            if charsourcerect.topLeft.x > 192 {
                charsourcerect.topLeft.x = 0
            }
        }

        if code == "ArrowRight" {
            charsourcerect.topLeft.y = 128
            mvmttracker += 1
            if mvmttracker%3 == 0 || mvmttracker < 6 {
                charsourcerect.topLeft.x += 64
            }
            if charsourcerect.topLeft.x > 192 {
                charsourcerect.topLeft.x = 0
            }
        }

        if code == "ArrowUp" {
            charsourcerect.topLeft.y = 192
            mvmttracker += 1
            if mvmttracker%3 == 0 || mvmttracker < 6 {
                charsourcerect.topLeft.x += 64
            }
            if charsourcerect.topLeft.x > 192 {
                charsourcerect.topLeft.x = 0
            }
        }

        }
             
    }

    func onKeyUp(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {

        if !mvmtlocked {

        
        if code == "ArrowDown" {
            charsourcerect.topLeft = Point(x:0, y:0)
           
            mvmttracker = 3
            caninteract = false
        }

        if code == "ArrowLeft" {
            charsourcerect.topLeft = Point(x:0, y:64)
            mvmttracker = 3
            caninteract = false
        }

        if code == "ArrowRight" {
            charsourcerect.topLeft = Point(x:0, y:128)
            mvmttracker = 3
            caninteract = false
        }

        if code == "ArrowUp" {
            charsourcerect.topLeft = Point(x:0, y:192)
            mvmttracker = 3
            caninteract = true
        }

        }
    }
}
    


