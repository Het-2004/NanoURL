import { useState } from "react";
import { shortenUrl } from "../services/api";
import Result from "./Result";

export default function UrlShortener() {
    const [longUrl, setLongUrl] = useState("");
    const [shortUrl, setShortUrl] = useState("");
    const [error, setError] = useState("");

    async function handleShorten() {
        try {
            setError("");
            const code = await shortenUrl(longUrl);
            setShortUrl(`http://localhost:8080/${code}`);
        } catch (err) {
            setError("Something went wrong");
        }
    }

    return (
        <>
            <h2>NanoURL</h2>

            <input
                type="text"
                placeholder="Enter long URL"
                value={longUrl}
                onChange={(e) => setLongUrl(e.target.value)}
                style={{ width: "100%", padding: "8px" }}
            />

            <br /><br />

            <button onClick={handleShorten}>Shorten URL</button>

            {error && <p style={{ color: "red" }}>{error}</p>}
            {shortUrl && <Result shortUrl={shortUrl} />}
        </>
    );
}
