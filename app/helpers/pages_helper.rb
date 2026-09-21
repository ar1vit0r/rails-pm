module PagesHelper
  # Full class strings, not interpolated pieces, so Tailwind's scanner sees them.
  # Hues match the badges in tasks/_task so a task keeps the same colors app-wide.
  PRIORITY_STYLES = {
    "urgent" => { edge: "bg-red-500", text: "text-red-300" },
    "high"   => { edge: "bg-orange-500", text: "text-orange-300" },
    "medium" => { edge: "bg-yellow-500", text: "text-yellow-300" },
    "low"    => { edge: "bg-gray-600", text: "text-gray-300" }
  }.freeze

  STATUS_STYLES = {
    "todo"        => { glyph: "○", text: "text-gray-300" },
    "in_progress" => { glyph: "◐", text: "text-yellow-300" },
    "done"        => { glyph: "●", text: "text-green-300" }
  }.freeze

  def priority_style(task) = PRIORITY_STYLES.fetch(task.priority, PRIORITY_STYLES["low"])

  def status_style(task) = STATUS_STYLES.fetch(task.status, STATUS_STYLES["todo"])
end
