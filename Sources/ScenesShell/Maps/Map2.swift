import Scenes
import Igis
import Foundation

class Map2 : RenderableEntity, KeyDownHandler {

    let map2 : Image
    let audio1 : Audio
    let audio2: Audio

    
    var destrect : Rect
    var sourcerect : Rect
    var active = false

    let miguel : Image
    var rendermiguel = false
    
    var sourceheight : Int
    var sourcewidth : Int

    //Canvas Data
    var canrender = false
    var canvasratio : Double
    var canvaswidth : Int
    var canvasheight : Int

    //containment
    var characterboundingrect : Rect
    var boundrect : Rect
    var boundrect2 : Rect
    var boundrect3 : Rect
    var boundrect4 : Rect
    var boundrect5 : Rect
    var miguelrect : Rect

    //mvmt lock
    var lockedup = false
    var lockeddown = false
    var lockedleft = false
    var lockedright = false
    var mvmtlocked = false

    
    






    init() {

        guard let map2url = URL(string:"https://github.com/onikh/ISPData/blob/main/map2final.png?raw=true") else {
            fatalError("Failed to create URL for map2")
        }

        guard let miguelURL = URL(string:"https://github.com/onikh/ISPData/blob/main/miguel.png?raw=true") else {
            fatalError("Failed to create URL for miguel")
        }

        guard let audio1URL = URL(string:"https://github.com/onikh/ISPData/blob/main/forest.mp3?raw=true") else {
            fatalError("Failed to create URL for audio1")
        }

        guard let audio2URL = URL(string:"https://github.com/onikh/ISPData/blob/main/paris.mp3?raw=true") else {
            fatalError("Failed to create URL for audio2")
        }

        map2 = Image(sourceURL:map2url)
        miguel = Image(sourceURL:miguelURL)
        audio1 = Audio(sourceURL:audio1URL)
        audio2 = Audio(sourceURL:audio2URL)

        destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        sourcerect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        characterboundingrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))

        boundrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        boundrect2 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        boundrect3 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        boundrect4 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        boundrect5 = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        
        miguelrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))  

        canvasratio = 0.0
        sourceheight = 0
        sourcewidth = 0
        canvaswidth = 0
        canvasheight = 0

        super.init(name:"Map2")
    }

    override func teardown() {
        dispatcher.unregisterKeyDownHandler(handler:self)
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(map2)
        canvas.setup(miguel)
        canvas.setup(audio1)
        canvas.setup(audio2)
        dispatcher.registerKeyDownHandler(handler:self)
        if let canvasSize = canvas.canvasSize {

            canvasratio = Double(canvasSize.width)/Double(canvasSize.height)
            sourceheight = 200
            sourcewidth = Int(Double(sourceheight)*canvasratio)

            let heightratio = Double(canvasSize.height)/Double(sourceheight)
            let widthratio = Double(canvasSize.height)/(Double(sourceheight)*canvasratio)


            destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:canvasSize.width, height:canvasSize.height))
            sourcerect = Rect(topLeft:Point(x:266-(sourcewidth/2), y:313-(sourceheight/2)), size:Size(width:sourcewidth, height:sourceheight))

            func generateBoundingRect(xpoint:Int, ypoint:Int, width:Int, height:Int) -> Rect {
                let rect = Rect(topLeft:Point(x: Int((Double(xpoint - Int(266-(sourcewidth/2)))/Double(sourcerect.width))*Double(canvasSize.width)), y:Int((Double(ypoint-212)/200.0)*Double(canvasSize.height))), size:Size(width:Int((Double(width)/Double(sourcerect.width))*Double(canvasSize.width)), height:Int((Double(height)/Double(200))*Double(canvasSize.height))))
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


            characterboundingrect = generateBoundingRect(xpoint:270, ypoint:322, width:13, height:11)   

            boundrect = generateBoundingRect(xpoint:160, ypoint:331, width:97, height:149)
            boundrect2 = generateBoundingRect(xpoint:174, ypoint:112, width:32, height:224)
            boundrect3 = generateBoundingRect(xpoint:175, ypoint:112, width:256, height:32)
            boundrect4 = generateBoundingRect(xpoint:320, ypoint:144, width:32, height:192)
            boundrect5 = generateBoundingRect(xpoint:288, ypoint:331, width:32, height:149)
            miguelrect = generateBoundingRect(xpoint:256, ypoint:224, width:16, height:16)

            
            boundrect.topLeft -= generateBoundingOffset(xtoreach:-18, ytoreach:0)
            boundrect2.topLeft -= generateBoundingOffset(xtoreach:-96, ytoreach:0)
            boundrect3.topLeft -= generateBoundingOffset(xtoreach:-96, ytoreach:-176)
            boundrect4.topLeft -= generateBoundingOffset(xtoreach:32, ytoreach:0)
            boundrect5.topLeft -= generateBoundingOffset(xtoreach:0, ytoreach:-4)
            miguelrect.topLeft -= generateBoundingOffset(xtoreach:-16, ytoreach:-81)   
            

            canvaswidth = canvasSize.width
            canvasheight = canvasSize.height

            canrender = true
        }
        
    }

    override func render(canvas:Canvas) {
        if map2.isReady && canrender && active && audio2.isReady && audio1.isReady {

            audio2.mode = .pause
            audio1.mode = .play

            
            map2.renderMode = .sourceAndDestination(sourceRect:sourcerect, destinationRect:destrect)
            miguel.renderMode = .destinationRect(miguelrect)
            canvas.render(map2)

            /*
            canvas.render(Rectangle(rect:boundrect, fillMode:.stroke))
            canvas.render(Rectangle(rect:boundrect2, fillMode:.stroke))
            canvas.render(Rectangle(rect:boundrect3, fillMode:.stroke))
            canvas.render(Rectangle(rect:boundrect4, fillMode:.stroke))
            canvas.render(Rectangle(rect:boundrect5, fillMode:.stroke))
            canvas.render(Rectangle(rect:characterboundingrect, fillMode:.stroke))
            canvas.render(Rectangle(rect:miguelrect, fillMode:.stroke))
            
             */
            
            if rendermiguel {
                canvas.render(miguel)
                audio2.mode = .play
                audio1.mode = .pause
            }
        } else {
            audio1.mode = .pause
            audio2.mode = .pause
        }

        if audio1.isReady && audio2.isReady {
            canvas.render(audio1)
            canvas.render(audio2)
        }
        
    }

    override func calculate(canvasSize:Size) {
        let boundrectcontainment = boundrect.containment(target:characterboundingrect)
        let boundrect2containment = boundrect2.containment(target:characterboundingrect)
        let boundrect3containment = boundrect3.containment(target:characterboundingrect)
        let boundrect4containment = boundrect4.containment(target:characterboundingrect)
        let boundrect5containment = boundrect5.containment(target:characterboundingrect)
        let miguelcontainment = miguelrect.containment(target:characterboundingrect)

        if (!boundrect3containment.intersection([.overlapsBottom]).isEmpty && boundrect3containment.contains(.contact)) || (!miguelcontainment.intersection([.overlapsBottom]).isEmpty && miguelcontainment.contains(.contact)) {
            lockedup = true
            print("locked")
        } else {
            lockedup = false
        }
        

        if (!boundrectcontainment.intersection([.overlapsTop]).isEmpty && boundrectcontainment.contains(.contact)) || (!boundrect5containment.intersection([.overlapsTop]).isEmpty && boundrect5containment.contains(.contact)) || (!miguelcontainment.intersection([.overlapsTop]).isEmpty && miguelcontainment.contains(.contact)) {
            lockeddown = true
        } else {
            lockeddown = false
        }


        if (!boundrectcontainment.intersection([.overlapsRight]).isEmpty && boundrectcontainment.contains(.contact)) || (!boundrect2containment.intersection([.overlapsRight]).isEmpty && boundrect2containment.contains(.contact)) || (!miguelcontainment.intersection([.overlapsRight]).isEmpty && miguelcontainment.contains(.contact)) {
            lockedleft = true
        } else {
            lockedleft = false
        }


        if (!boundrect4containment.intersection([.overlapsLeft]).isEmpty && boundrect4containment.contains(.contact)) || (!boundrect5containment.intersection([.overlapsLeft]).isEmpty && boundrect5containment.contains(.contact)) || (!miguelcontainment.intersection([.overlapsLeft]).isEmpty && miguelcontainment.contains(.contact)) {
            lockedright = true
        } else {
            lockedright = false
        }

        
        
    }
                                               

    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if active {

            if !mvmtlocked {
            if code == "ArrowUp" && sourcerect.topLeft.y > 0 && !lockedup {
                sourcerect.topLeft.y -= 2
                boundrect.topLeft.y += Int(Double(canvasheight)/100.0)
                boundrect2.topLeft.y += Int(Double(canvasheight)/100.0)
                boundrect3.topLeft.y += Int(Double(canvasheight)/100.0)
                boundrect4.topLeft.y += Int(Double(canvasheight)/100.0)
                boundrect5.topLeft.y += Int(Double(canvasheight)/100.0)
                miguelrect.topLeft.y += Int(Double(canvasheight)/100.0) 
            }

            if code == "ArrowDown" && sourcerect.bottomLeft.y < 563 && !lockeddown {
                sourcerect.topLeft.y += 2
                boundrect.topLeft.y -= Int(Double(canvasheight)/100.0)
                boundrect2.topLeft.y -= Int(Double(canvasheight)/100.0)
                boundrect3.topLeft.y -= Int(Double(canvasheight)/100.0)
                boundrect4.topLeft.y -= Int(Double(canvasheight)/100.0)
                boundrect5.topLeft.y -= Int(Double(canvasheight)/100.0)
                miguelrect.topLeft.y -= Int(Double(canvasheight)/100.0)
            }

            if code == "ArrowRight" && sourcerect.bottomRight.x < 527 && !lockedright {
                sourcerect.topLeft.x += 2
                boundrect.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
                boundrect2.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
                boundrect3.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
                boundrect4.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
                boundrect5.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
                miguelrect.topLeft.x -= Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            }

            if code == "ArrowLeft" && sourcerect.topLeft.x > 2 && !lockedleft {
                sourcerect.topLeft.x -= 2
                boundrect.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
                boundrect2.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
                boundrect3.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
                boundrect4.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
                boundrect5.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
                miguelrect.topLeft.x += Int(Double(canvaswidth)/(Double(sourcewidth)/2.0))
            }
        }
        }
    }

    
}
                         
