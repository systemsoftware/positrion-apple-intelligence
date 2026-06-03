/**
 * Sends a query to the Apple AI plugin and logs the response or error.
 * @param {Window} window - The window to send the query from.
 * @param {string} query - The query to send to the Apple AI plugin.
 * @param {Object} config - Optional configuration object for the AI query.
 * @param {string} config.instructions - Optional instructions to guide the AI's response (default is an empty string).
 * @param {number} config.temp - Optional temperature setting for the AI's response (default is 0.7).
 * @param {number} config.maxTokens - Optional maximum number of tokens for the AI's response (default is 1000).
 * @param {number} config.timeout - Optional timeout in milliseconds for the AI query (default is 10000).
 * @returns {Promise<string>} The response from the Apple AI plugin, or an error message if the query fails.
 */
module.exports = async (window, query, config = { instructions:"", temp:0.7, timeout:10000, maxTokens:1000 }) => {
const ai = await window.request("apple-ai", { timeout: config.timeout }, query, config.instructions, config.temp, config.maxTokens)

if(ai.response) {
  return ai.response
} else {
  throw new Error(ai.error || "AI failed")
}
}