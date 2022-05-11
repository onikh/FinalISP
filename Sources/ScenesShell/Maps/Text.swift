
import Scenes
import Igis
import Foundation


class Textbox : RenderableEntity, KeyDownHandler {

    let textbox : Image
    var destrect : Rect

    var active = false
    var nextbox = false
    let words : Text


    init(dialogue: String) {
        guard let textboxURL = URL(string:"https://github.com/onikh/ISPData/blob/main/textbox.png?raw=true") else {
            fatalError("Failed to create URL for textbox")
        }

        textbox = Image(sourceURL:textboxURL)


        destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        words = Text(location:Point(x:0, y:0), text:dialogue)
        super.init(name:"Text")

    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        if let canvasSize = canvas.canvasSize {
            canvas.setup(textbox)
            destrect = Rect(bottomLeft:Point(x:0, y: canvasSize.height), size:Size(width:canvasSize.width, height: canvasSize.height/5))

            words.font = "\(Int(canvasSize.width/32))pt Arial"
            words.location = destrect.topLeft
            words.location.y += canvasSize.height/40
            words.location.x += canvasSize.width/24
            words.baseline = .top
            

        }

        dispatcher.registerKeyDownHandler(handler:self)
    }

        

    override func render(canvas:Canvas) {
        
        if textbox.isReady && active {
            textbox.renderMode = .destinationRect(destrect)
            canvas.render(textbox)
            
            canvas.render(words)
            
            }
            }
            



override func teardown() {
    dispatcher.unregisterKeyDownHandler(handler:self)
}
        
func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {

    if code == "Enter" && active {
       nextbox = true

    }
}

override func calculate(canvasSize:Size) {
    if nextbox == true {
        print(nextbox)
    }
}


}


    
    
  
