const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8080";
const BASE_URL = `${API_URL}/api`;

export async function shortenUrl(longUrl) {
    const response = await fetch(`${BASE_URL}/shorten`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ url: longUrl })
    });

    if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || "Failed to shorten URL");
    }

    return response.json();
}
