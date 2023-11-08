import FaceTecSDK

// Class that allows all Processors to have a common type and a common way to query the success
// This is done for demonstration purposes and you do not need to define this in your classes.
protocol Processor: AnyObject {
    func isSuccess() -> Bool
    func faceScan() -> String?
}

protocol ProcessorDelegate:AnyObject{
    func onProcessingComplete(isSuccess: Bool, faceTecSessionResult: FaceTecSessionResult?,errorMsg:String?)
}

