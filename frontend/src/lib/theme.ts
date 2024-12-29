import { writable } from "svelte/store";
import { browser } from "$app/environment";

const initialTheme = () => {
  if (!browser) return "light"; // Server-side rendering
  const storedTheme = localStorage.getItem("theme");
  if (storedTheme) {
    return storedTheme as "light" | "dark";
  } else if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
    return "dark";
  }
  return "light";
};

export const theme = writable<"light" | "dark">(initialTheme());

if (browser) {
  theme.subscribe((value) => {
    document.documentElement.setAttribute("data-theme", value);
    localStorage.setItem("theme", value);
  });
}
