import Cocoa
import FoundationModels
import Foundation


public class AppleAI {

    static func handle(windowId: Int, args: [String]) {

        let model = SystemLanguageModel.default

        var unavailabilityReasons = ""

        switch model.availability {
        case .unavailable(.deviceNotEligible):
            print("Device not eligible")
            unavailabilityReasons += "Device not eligible. "
        case .unavailable(.appleIntelligenceNotEnabled):
            print("Apple Intelligence not enabled")
                unavailabilityReasons += "Apple Intelligence not enabled. "
        case .unavailable(.modelNotReady):
            print("Model not ready")
            unavailabilityReasons += "Model not ready. "
        case .unavailable(_):
            print("Unknown reason")
                unavailabilityReasons += "Unknown reason. "
        case .available:
            break
        }

let replyChannel = args.last ?? "apple-ai-reply-\(windowId)"

        if !unavailabilityReasons.isEmpty {
            let response = IPCResponse(
                windowId: windowId,
                event: replyChannel,
                data: ["error": "Model is unavailable: \(unavailabilityReasons)"]
            )
            AppDelegate.shared?.ipcClient.send(response)
            return
        }


        guard let prompt = args.first, !prompt.isEmpty else {
            let response = IPCResponse(
                windowId: windowId,
                event: replyChannel,
                data: ["error": "Prompt is required."]
            )
            AppDelegate.shared?.ipcClient.send(response)
            return
        }

        let instructions = args.indices.contains(1) ? args[1] : ""
        let temperature = args.indices.contains(2) ? Double(args[2]) ?? 0.7 : 0.7
        let maxTokens = args.indices.contains(3) ? Int(args[3]) ?? 1000 : 1000

        let session = LanguageModelSession(instructions: instructions)
        let options = GenerationOptions(temperature: temperature, maximumResponseTokens: maxTokens)

        Task {
            do {
                let res = try await session.respond(to: prompt, options: options)
                let response = IPCResponse(
                    windowId: windowId,
                    event: replyChannel,
                    data: ["response": res.content]
                )
                AppDelegate.shared?.ipcClient.send(response)
            } catch {
                let response = IPCResponse(
                    windowId: windowId,
                    event: replyChannel,
                    data: ["error": error.localizedDescription]
                )
                AppDelegate.shared?.ipcClient.send(response)
            }
        }
    }
}