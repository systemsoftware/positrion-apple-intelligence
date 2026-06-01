# Positron Apple AI Extension

`positron-apple-ai` is a native stitched extension for [Positron.js](https://npmjs.com/positron.js) that allows your desktop applications to seamlessly interact with **Apple Intelligence** (via `SystemLanguageModel`) directly from your macOS device.

It exposes a simple command through Positron's IPC to generate AI responses using Apple's on-device models, while remaining a safe no-op on Windows.

## Installation & Setup

To use this plugin in your Positron application, simply add it to your project dependencies:

```bash
npm i positron-apple-ai
```

Then, trigger a Positron build:
```bash
npx positron build
```

## IPC Communication Flow
1. **Frontend Request:** Your JavaScript application sends a payload over Positron's IPC WebSocket server with the command `"apple-ai"`.
2. **Native Execution:** 
   - On macOS, `AppleAI.handle(windowId: args:)` is invoked. It checks if `SystemLanguageModel` is available and ready on the Mac. If it's ready, it starts an asynchronous task to evaluate the prompt.
   - On Windows, the C# implementation is a no-op because Apple Intelligence is exclusive to macOS.
3. **Frontend Reply:** Once the macOS model finishes generation, the native runtime sends an IPC response event back to your Node.js layer containing the model's generated text or an error message.

## Usage

You can invoke the `apple-ai` command via Positron's IPC system.

The command accepts the following arguments (passed in order):
1. `prompt` (String, **Required**): The prompt to send to Apple Intelligence.
2. `instructions` (String, Optional): System instructions to guide the model (default: `""`).
3. `temperature` (Double, Optional): Temperature for the generation (default: `0.7`).
4. `maxTokens` (Int, Optional): Maximum tokens for the response (default: `100`).

## Example
```js

const promptAppleAI = require("positron-apple-ai")

mainWindow.on("ready", () => {

// ARGS: window, prompt, max timeout
const content = await promptAppleAI(mainWindow, "prompt here", 10000)

console.log(content)

})
```

### Potential Errors
The extension handles Apple Intelligence availability and may return one of the following errors if the model cannot be queried:
- `Device not eligible.`
- `Apple Intelligence not enabled.`
- `Model not ready.`
- `Prompt is required.`
