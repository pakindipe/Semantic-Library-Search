import asyncio
import aiohttp
import csv
import re

# English filtering
allowed_re = re.compile(r"^[A-Za-z0-9\s\.\,\!\?\'\"\:\;\-\(\)]+$")
def is_english(s):
    return bool(s and allowed_re.match(s))

genres = [
    "fantasy", "science_fiction", "mystery", "romance",
    "historical_fiction", "horror", "young_adult",
    "biography", "self_help", "classics"
]

BOOKS_PER_GENRE = 10
CONCURRENCY = 10


async def fetch_page(session, genre, offset):
    url = f"https://openlibrary.org/subjects/{genre}.json?limit=50&offset={offset}"
    async with session.get(url) as resp:
        if resp.status != 200:
            return None
        return await resp.json()

async def scrape_genre(session, genre, start_id):
    collected = []
    offset = 0

    while len(collected) < BOOKS_PER_GENRE:
        tasks = [fetch_page(session, genre, offset + 50*i)
                 for i in range(CONCURRENCY)]
        results = await asyncio.gather(*tasks)

        if all(r is None or not r.get("works") for r in results):
            break

        for r in results:
            if not r or not r.get("works"):
                continue

            for w in r["works"]:
                if len(collected) >= BOOKS_PER_GENRE:
                    break

                title = w.get("title", "").strip()
                authors = w.get("authors", [])
                author = ", ".join(a["name"] for a in authors) if authors else ""

                if not (is_english(title) and is_english(author)):
                    continue

                cover_id = w.get("cover_id")
                year = w.get("first_publish_year")

                collected.append({
                    "title": title,
                    "author": author,
                    "genre": genre,
                    "year": year,
                    "cover_id": cover_id
                })

        offset += 50 * CONCURRENCY

    # Assign IDs deterministically
    for i, b in enumerate(collected):
        b["id"] = start_id + i
        b["filename"] = f"{b['id']}.jpg"  # will be replaced if webp exists

    return collected, start_id + len(collected)


async def main():
    all_books = []
    next_id = 0

    async with aiohttp.ClientSession() as session:
        for g in genres:
            print(f"Scraping {g}...")
            books, next_id = await scrape_genre(session, g, next_id)
            all_books.extend(books)
            print(f"{g}: {len(books)} books")

    # Write CSV
    with open("books_dataset.csv", "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=["id","title","author","genre","year","cover_id","filename"]
        )
        writer.writeheader()
        writer.writerows(all_books)

    print(f"Total books: {len(all_books)}")

if __name__ == "__main__":
    asyncio.run(main())
