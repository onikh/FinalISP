import Scenes
import Igis
import Foundation

class Option : RenderableEntity, EntityMouseClickHandler {
    let box : Image
    var destrect : Rect

    
    let word : Text

    var active = false
    var clicked = false




    init(option:String) {
        guard let boxURL = URL(string:"https://github.com/onikh/ISPData/blob/main/textbox.png?raw=true") else {
            fatalError("Failed to create URL for textbox")
        }
        box = Image(sourceURL:boxURL)


        destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        word = Text(location:Point(x:0, y:0), text:option)
       


        super.init(name:"Option")
    }


    override func setup(canvasSize:Size, canvas:Canvas) {
        dispatcher.registerEntityMouseClickHandler(handler:self)
        canvas.setup(box)

        if let canvasSize = canvas.canvasSize {
            destrect = Rect(topLeft:Point(x:0,y:0), size:Size(width:canvasSize.width/2, height:canvasSize.height/6))
            word.font = "\(Int(canvasSize.width/32))pt Arial" 

        }
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }

    override func render(canvas:Canvas) {
        if box.isReady && active {
            box.renderMode = .destinationRect(destrect)
            canvas.render(box)

          
            canvas.render(FillStyle(color:Color(.black)), word)

        }
    }

    func onEntityMouseClick(globalLocation:Point) {
        if active {
            print("hit!!!!")
            clicked = true 
        }
    }

        override func boundingRect() -> Rect {
            return destrect
        }
    }
