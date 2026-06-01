/**
 * Sends a query to the Apple AI plugin and logs the response or error.
 * @param {Window} window - The window to send the query from.
 * @param {string} query - The query to send to the Apple AI plugin.
 * @param {number} TIMEOUT - The maximum time to wait for a response in milliseconds (default is 10000).
 * @returns {Promise<string>} The response from the Apple AI plugin, or an error message if the query fails.
 * @example
 * sendAIQuery(window, "What is the capital of France?")
 *   .then(response => console.log(response))
 *   .catch(error => console.error(error));
 */
module.exports = async (window, query, TIMEOUT = 10000) => {
const ai = await window.request("apple-ai", `apple-ai-reply-${window.id}`, query, `TIMEOUT=${TIMEOUT}`)

if(ai.response) {
  return ai.response
} else {
  throw new Error(ai.error || "AI failed")
}
}