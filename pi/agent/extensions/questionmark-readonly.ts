import { isToolCallEventType, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

const readOnlyTools = new Set(["read", "grep", "find", "ls"]);

const allowedBashCommands = new Set([
  "awk",
  "cat",
  "cut",
  "fd",
  "find",
  "grep",
  "head",
  "ls",
  "pwd",
  "rg",
  "sort",
  "tail",
  "tree",
  "uniq",
  "wc",
]);

const allowedGitSubcommands = new Set([
  "branch",
  "diff",
  "grep",
  "log",
  "ls-files",
  "show",
  "status",
]);

const allowedJjSubcommands = new Set([
  "diff",
  "file",
  "log",
  "show",
  "status",
]);

function isAllowedSegment(segment: string): boolean {
  const parts = segment.split(/\s+/);
  const executable = parts[0]?.split("/").pop();
  if (!executable) return false;

  if (allowedBashCommands.has(executable)) return true;

  if (executable === "git") {
    return allowedGitSubcommands.has(parts[1] ?? "");
  }

  if (executable === "jj") {
    const subcommand = parts[1] ?? "";
    if (!allowedJjSubcommands.has(subcommand)) return false;

    // `jj file` has write-capable subcommands, so only allow listing files.
    if (subcommand === "file") return parts[2] === "list";

    return true;
  }

  return false;
}

function isAllowedReadOnlyBash(command: string): boolean {
  const trimmed = command.trim();
  if (!trimmed) return false;

  // Allow read-only pipelines/chains, but no command substitution, grouping,
  // statement separators, or redirection/writes.
  if (/[;`<>(){}]/.test(trimmed) || trimmed.includes("$(")) return false;
  if (/(^|\s)(?:>|>>|2>|2>>|&>)/.test(trimmed)) return false;

  const segments = trimmed
    .split(/\s*(?:\|\|?|&&)\s*/)
    .map((segment) => segment.trim())
    .filter(Boolean);

  if (segments.length === 0) return false;
  return segments.every(isAllowedSegment);
}

// If the current user prompt contains a double question mark, force the turn into
// read-only mode by blocking every tool except Pi's built-in read-only tools.
export default function (pi: ExtensionAPI) {
  let questionPromptActive = false;

  pi.on("before_agent_start", async (event, ctx) => {
    questionPromptActive = event.prompt.includes("??");

    if (questionPromptActive && ctx.hasUI) {
      ctx.ui.notify(
        "Double question mark detected: write/edit/bash and other non-read-only tools are blocked for this turn.",
        "info",
      );
    }
  });

  pi.on("tool_call", async (event) => {
    if (!questionPromptActive) return;
    if (readOnlyTools.has(event.toolName)) return;
    if (
      isToolCallEventType("bash", event) &&
      isAllowedReadOnlyBash(event.input.command)
    ) {
      return;
    }

    return {
      block: true,
      reason:
        "Blocked by questionmark-readonly: the last user prompt contains '??' so only read-only tools are allowed.",
    };
  });

  pi.on("agent_end", async () => {
    questionPromptActive = false;
  });
}
