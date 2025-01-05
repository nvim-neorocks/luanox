import { error } from "@sveltejs/kit";

export function formatNumberWithDot(num: number) {
  if (isNaN(num)) {
    throw error(500, "Invalid input provided");
  }

  return num.toLocaleString("en-US");
}
