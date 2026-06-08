import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// If the current user prompt contains a question mark, force the turn into
// read-only mode by blocking every tool except Pi's built-in read-only tools.
export default function (pi: ExtensionAPI) {
  const readOnlyTools = new Set(["read", "grep", "find", "ls"]);
  let questionPromptActive = false;

  pi.on("before_agent_start", async (event, ctx) => {
    questionPromptActive = event.prompt.includes("?");

    if (questionPromptActive && ctx.hasUI) {
      ctx.ui.notify(
        "Question mark detected: write/edit/bash and other non-read-only tools are blocked for this turn.",
        "info",
      );
    }
  });

  pi.on("tool_call", async (event) => {
    if (!questionPromptActive) return;
    if (readOnlyTools.has(event.toolName)) return;

    return {
      block: true,
      reason:
        "Blocked by questionmark-readonly: the last user prompt contains '?' so only read-only tools are allowed.",
    };
  });

  pi.on("agent_end", async () => {
    questionPromptActive = false;
  });
}
