import asyncio
import aiohttp
import aiofiles
import csv
import os

CSV_FILE = "books_dataset.csv"
OUT = "test_covers"
CONCURRENCY = 20

os.makedirs(OUT, exist_ok=True)

async def download_one(session, row, sem):
    cover_id = row["cover_id"]
    if cover_id in ("", "None", None):
        return

    book_id = row["id"]
    base = f"https://covers.openlibrary.org/b/id/{cover_id}"

    exts = [
        "-S.jpg", "-M.jpg", 
    ]

    async with sem:
        for ext in exts:
            url = base + ext
            filename = f"{book_id}{ext[-4:]}"  # .webp or .jpg
            path = os.path.join(OUT, filename)

            if os.path.exists(path):
                return

            try:
                async with session.get(url) as resp:
                    if resp.status != 200:
                        continue

                    data = await resp.read()
                    async with aiofiles.open(path, "wb") as f:
                        await f.write(data)

                    print("Downloaded:", path)
                    return

            except:
                continue

        print("FAILED:", book_id, cover_id)


async def main():
    sem = asyncio.Semaphore(CONCURRENCY)

    async with aiohttp.ClientSession() as session:
        tasks = []
        with open(CSV_FILE, encoding="utf-8") as f:
            reader = csv.DictReader(f)
            for row in reader:
                tasks.append(asyncio.create_task(download_one(session, row, sem)))

        await asyncio.gather(*tasks)

if __name__ == "__main__":
    asyncio.run(main())
