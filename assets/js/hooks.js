// This hook is intended to be used only by the landing page
const Typewriter = {
  mounted() {
    this.words = [
      "modern",
      "fast",
      "scalable",
      "secure",
    ];
    this.i = 0;
    this.j = 0;
    this.delay = 100;
    this.isDeleting = false;
    this.timeoutId = null;
    this.type();
  },
  destroyed() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId);
    }
  },
  type() {
    const el = this.el;
    const currentWord = this.words[this.i];

    if (this.isDeleting) {
      el.textContent = currentWord.substring(0, this.j - 1);
      this.j--;
      // Reset delay
      this.delay = 100;

      if (this.j === 0) {
        this.isDeleting = false;
        this.i = (this.i + 1) % this.words.length;
      }
    } else {
      this.delay = 100;
      el.textContent = currentWord.substring(0, this.j + 1);
      this.j++;

      if (this.j === currentWord.length) {
        this.isDeleting = true;
        // Set 1 sec delay before starting to delete the current word
        this.delay = 1000;
      }
    }

    this.timeoutId = setTimeout(() => this.type(), this.delay);
  }
};

export default Hooks = {
  Typewriter: Typewriter,
}
