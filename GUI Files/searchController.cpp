#include "searchcontroller.h"
#include <algorithm>

SearchController::SearchController(ResultsModel* model, QObject* parent)
    : QObject(parent), m_model(model) {}

void SearchController::search(const QString& query) {
    // In the real app, you'd call Python, parse JSON IDs, fetch/construct Books, convert.
    // For now, we search inside the mock list:
    auto all = buildDemoData();
    m_model->setResults(all);
}

void SearchController::loadDemo() {
    m_model->setResults(buildDemoData());
}

QVector<BookDTO> SearchController::buildDemoData() const {
    //Build cpp book instances and then convert into bookDTO to interface with QT
    std::vector<Book> raw;

    raw.emplace_back(
        "The Pragmatic Programmer", "Andrew Hunt & David Thomas",
        1999, 10, 30,
        "Classic software craftsmanship guide with tips, analogies, and best practices.",
        std::vector<std::string>{"Software", "Engineering", "Nonfiction"}, true);

    raw.emplace_back(
        "Clean Code", "Robert C. Martin",
        2008, 8, 1,
        "How to write readable, maintainable, and testable code; lots of refactoring examples.",
        std::vector<std::string>{"Software", "Best Practices"}, true);

    raw.emplace_back(
        "Design Patterns", "Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides",
        1994, 10, 31,
        "The GoF catalog of reusable object-oriented design patterns.",
        std::vector<std::string>{"Software", "Architecture"}, false);

    raw.emplace_back(
        "Introduction to Algorithms", "Cormen, Leiserson, Rivest, Stein",
        2009, 7, 31,
        "Foundational textbook (CLRS) covering algorithms, complexity, data structures.",
        std::vector<std::string>{"Algorithms", "Textbook"}, true);

    raw.emplace_back(
        "Dune", "Frank Herbert",
        1965, 8, 1,
        "Epic sci-fi saga of politics, ecology, and prophecy on the desert planet Arrakis.",
        std::vector<std::string>{"Science Fiction", "Classic"}, true);

    raw.emplace_back(
        "The Name of the Wind", "Patrick Rothfuss",
        2007, 3, 27,
        "Kvothe recounts his life—music, magic, and mystery—in a richly told fantasy.",
        std::vector<std::string>{"Fantasy", "Adventure"}, false);

    raw.emplace_back(
        "Sapiens: A Brief History of Humankind", "Yuval Noah Harari",
        2011, 1, 1,
        "A sweeping history of Homo sapiens—culture, cognition, agriculture, capitalism.",
        std::vector<std::string>{"History", "Anthropology", "Nonfiction"}, true);

    raw.emplace_back(
        "Atomic Habits", "James Clear",
        2018, 10, 16,
        "Tiny changes, remarkable results—systems for building and breaking habits.",
        std::vector<std::string>{"Self-Help", "Productivity"}, true);

    QVector<BookDTO> out;
    out.reserve(static_cast<int>(raw.size()));
    for (auto& b : raw) {
        BookDTO dto = bookConvert(b);
        // Use title as a stand-in ID for now (replace with real DB/py IDs later)
        dto.id = dto.title;
        out.push_back(dto);
    }
    return out;
}


