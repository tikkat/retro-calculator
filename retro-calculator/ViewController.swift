import UIKit
import AVFoundation

enum Operator: Int {
    case Divide = 10
    case Multiply = 11
    case Subtract = 12
    case Add = 13
    case Equals = 14
    case Empty
}

class ViewController: UIViewController
{

    @IBOutlet weak var outputLabel: UILabel!
    var buttonSound: AVAudioPlayer!
    var runningNumber = ""
    var leftVal = 0
    var rightVal = 0
    var currentOperation: Operator = Operator.Empty
    var result = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        outputLabel.text = String(runningNumber)
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            try buttonSound = AVAudioPlayer(contentsOfURL: soundUrl)
            buttonSound.prepareToPlay()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    @IBAction func numberPressed(button: UIButton!)
    {
        playSound()
        
        runningNumber += String(button.tag)
        outputLabel.text = runningNumber
    }
    
    @IBAction func operatorPressed(button: UIButton)
    {
        let operationCalled = button.tag
        
        switch operationCalled {
        case Operator.Divide.rawValue:
            processOperation(Operator.Divide)
        case Operator.Multiply.rawValue:
            processOperation(Operator.Multiply)
        case Operator.Subtract.rawValue:
            processOperation(Operator.Subtract)
        case Operator.Add.rawValue:
            processOperation(Operator.Add)
        case Operator.Equals.rawValue:
            processOperation(Operator.Equals)
        default:
            return
        }
    }
    
    private func processOperation(operation: Operator)
    {
        playSound()
        
        if currentOperation != Operator.Empty {
            //A user did not chose two operators in a row
            if runningNumber != "" {
                rightVal = Int(runningNumber)!
                runningNumber = ""
                
                if currentOperation == .Multiply {
                    result = leftVal * rightVal
                } else if currentOperation == .Divide {
                    result = leftVal / rightVal
                } else if currentOperation == .Subtract {
                    result = leftVal - rightVal
                } else if currentOperation == .Add {
                    result = leftVal + rightVal
                }
                
                leftVal = result
                outputLabel.text = String(result)
            }
            currentOperation = operation
        } else {
            //This is the first time an operator has been pressed
            leftVal = Int(runningNumber)!
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    private func playSound()
    {
        if buttonSound.playing {
            buttonSound.stop()
        }
        
        buttonSound.play()
    }
}

