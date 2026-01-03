const BASE_URL = "http://localhost:8080/api";

export async function shortenUrl(longUrl) {
    const response = await fetch(`${BASE_URL}/shorten`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(longUrl)
    });

    if (!response.ok) {
        throw new Error("Failed to shorten URL");
    }

    return response.text();
}
