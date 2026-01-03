export default function Result({ shortUrl }) {
    function copy() {
        navigator.clipboard.writeText(shortUrl);
        alert("Copied!");
    }

    return (
        <div style={{ marginTop: "20px" }}>
            <p>Short URL:</p>
            <a href={shortUrl} target="_blank">{shortUrl}</a>
            <br /><br />
            <button onClick={copy}>Copy</button>
        </div>
    );
}
