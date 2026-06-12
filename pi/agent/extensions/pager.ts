import { spawnSync } from "node:child_process";
import { mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import type { AgentMessage } from "@earendil-works/pi-agent-core";

const DEFAULT_AUTO_LINES = 0;

function assistantText(message: AgentMessage): string | undefined {
  if (message.role !== "assistant") return undefined;

  const parts = message.content
    .filter((part) => part.type === "text")
    .map((part) => part.text)
    .filter(Boolean);

  return parts.length > 0 ? parts.join("\n\n") : undefined;
}

function lastAssistantMessage(messages: AgentMessage[]): AgentMessage | undefined {
  for (let i = messages.length - 1; i >= 0; i--) {
    if (messages[i]?.role === "assistant") return messages[i];
  }
  return undefined;
}

function getLastAssistantFromSession(ctx: { sessionManager: { getBranch(): Array<{ type: string; message?: AgentMessage }> } }) {
  const branch = ctx.sessionManager.getBranch();
  for (let i = branch.length - 1; i >= 0; i--) {
    const entry = branch[i];
    if (entry?.type === "message" && entry.message?.role === "assistant") return entry.message;
  }
  return undefined;
}

function autoLineThreshold(): number {
  const raw = process.env.PI_PAGER_AUTO_LINES;
  if (raw === undefined || raw.trim() === "") return DEFAULT_AUTO_LINES;
  const parsed = Number.parseInt(raw, 10);
  return Number.isFinite(parsed) ? parsed : DEFAULT_AUTO_LINES;
}

function isLongEnoughForAutoPager(text: string): boolean {
  const threshold = autoLineThreshold();
  if (threshold <= 0) return false;

  const terminalWidth = process.stdout.columns || 100;
  const visualLineEstimate = text
    .split("\n")
    .reduce((total, line) => total + Math.max(1, Math.ceil(line.length / Math.max(1, terminalWidth))), 0);

  return visualLineEstimate >= threshold;
}

function shellQuote(value: string): string {
  return `'${value.replace(/'/g, `'\\''`)}'`;
}

async function openInPager(ctx: { mode: string; ui: any }, text: string, label = "assistant-response") {
  if (ctx.mode !== "tui") {
    ctx.ui.notify("/pager is only available in TUI mode.", "error");
    return;
  }

  const dir = mkdtempSync(join(tmpdir(), "pi-pager-"));
  const file = join(dir, `${label}.md`);
  writeFileSync(file, text, "utf8");

  const pager = process.env.PAGER || process.env.MANPAGER || "less -R";
  const debug = process.env.PI_PAGER_DEBUG === "1";
  if (debug) {
    ctx.ui.notify(`Opening pager: ${pager} ${file} (${text.length} bytes)`, "info");
  }

  await ctx.ui.custom<void>((tui: any, _theme: unknown, _kb: unknown, done: () => void) => {
    tui.stop();
    process.stdout.write("\x1b[2J\x1b[H");

    try {
      const shell = process.env.SHELL || "/bin/sh";
      spawnSync(shell, ["-c", `${pager} ${shellQuote(file)}`], {
        stdio: "inherit",
        env: process.env,
      });
    } finally {
      if (!debug) {
        try {
          rmSync(dir, { recursive: true, force: true });
        } catch {
          // Best-effort cleanup only.
        }
      }
      tui.start();
      tui.requestRender(true);
      done();
    }

    return { render: () => [], invalidate: () => {} };
  });
}

export default function (pi: ExtensionAPI) {
  let lastAutoPagedText: string | undefined;

  pi.registerCommand("pager", {
    description: "Open the last assistant response in $PAGER, $MANPAGER, or less",
    handler: async (_args, ctx) => {
      const message = getLastAssistantFromSession(ctx);
      const text = message ? assistantText(message) : undefined;

      if (!text) {
        ctx.ui.notify("No assistant response found to page.", "warning");
        return;
      }

      await openInPager(ctx, text);
    },
  });

  pi.on("agent_end", async (event, ctx) => {
    const message = lastAssistantMessage(event.messages);
    const text = message ? assistantText(message) : undefined;
    if (!text || text === lastAutoPagedText || !isLongEnoughForAutoPager(text)) return;

    lastAutoPagedText = text;
    await openInPager(ctx, text);
  });
}
