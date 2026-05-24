// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", () => {
  const btn = document.getElementById("isbn_fetch_btn");
  if (!btn) return;

  btn.addEventListener("click", async () => {
    const isbn = document.getElementById("isbn_lookup").value.trim().replace(/-/g, "");
    const status = document.getElementById("isbn_status");

    if (!isbn) {
      status.textContent = "Please enter an ISBN.";
      status.style.color = "#c0737a";
      return;
    }

    status.textContent = "Looking up…";
    status.style.color = "#b07090";
    btn.disabled = true;

    try {
      const url = `https://openlibrary.org/api/books?bibkeys=ISBN:${isbn}&format=json&jscmd=data`;
      const res = await fetch(url);
      const data = await res.json();
      const key = `ISBN:${isbn}`;

      if (!data[key]) {
        status.textContent = "No book found for that ISBN. Try another or fill in manually.";
        status.style.color = "#c0737a";
        btn.disabled = false;
        return;
      }

      const book = data[key];

      if (book.title) {
        document.getElementById("book_title").value = book.title;
      }

      if (book.authors && book.authors.length > 0) {
        document.getElementById("book_author").value =
          book.authors.map(a => a.name).join(", ");
      }

      if (book.notes) {
        const desc = typeof book.notes === "string" ? book.notes : book.notes.value;
        document.getElementById("book_description").value = desc;
      }

      if (book.subjects && book.subjects.length > 0) {
        const existing = document.getElementById("book_genre").value;
        if (!existing) {
          document.getElementById("book_genre").value = book.subjects[0].name;
        }
      }

      document.getElementById("book_isbn").value = isbn;

      status.textContent = "✓ Details filled in! Review and edit as needed.";
      status.style.color = "#2d6a4f";

    } catch (err) {
      status.textContent = "Something went wrong. Please try again.";
      status.style.color = "#c0737a";
    }

    btn.disabled = false;
  });
});