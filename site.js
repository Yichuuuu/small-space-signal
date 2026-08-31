document.addEventListener("DOMContentLoaded", () => {
  const year = document.querySelector("[data-year]");
  if (year) year.textContent = new Date().getFullYear();

  const search = document.querySelector("[data-article-search]");
  const cards = [...document.querySelectorAll("[data-article-card]")];
  const empty = document.querySelector("[data-empty-state]");

  if (search && cards.length) {
    search.addEventListener("input", () => {
      const query = search.value.trim().toLowerCase();
      let visible = 0;

      cards.forEach((card) => {
        const matches = !query || card.textContent.toLowerCase().includes(query);
        card.hidden = !matches;
        if (matches) visible += 1;
      });

      if (empty) empty.hidden = visible !== 0;
    });
  }
});
