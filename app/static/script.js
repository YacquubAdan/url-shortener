let currentShortUrl = '';

document.getElementById('shortenForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const urlInput = document.getElementById('urlInput');
    const shortenBtn = document.getElementById('shortenBtn');
    const loading = document.getElementById('loading');
    const error = document.getElementById('error');
    const result = document.getElementById('result');
    const shortUrlDiv = document.getElementById('shortUrl');
    
    const url = urlInput.value.trim();
    
    if (!url) {
        showError('Please enter a valid URL');
        return;
    }

    shortenBtn.disabled = true;
    loading.style.display = 'block';
    error.style.display = 'none';
    result.classList.remove('show');

    try {
        const response = await fetch('/shorten', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ url: url })
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        currentShortUrl = `${window.location.origin}/${data.short}`;
        shortUrlDiv.textContent = currentShortUrl;
        result.classList.add('show');
        
    } catch (err) {
        showError('Failed to shorten URL. Please try again.');
        console.error('Error:', err);
    } finally {
        shortenBtn.disabled = false;
        loading.style.display = 'none';
    }
});

function showError(message) {
    const error = document.getElementById('error');
    error.textContent = message;
    error.style.display = 'block';
}

async function copyToClipboard() {
    try {
        await navigator.clipboard.writeText(currentShortUrl);
        const copyBtn = document.querySelector('.copy-btn');
        const originalText = copyBtn.textContent;
        copyBtn.textContent = '✅ Copied!';
        copyBtn.style.background = '#28a745';
        
        setTimeout(() => {
            copyBtn.textContent = originalText;
            copyBtn.style.background = '#28a745';
        }, 2000);
    } catch (err) {
        console.error('Failed to copy to clipboard:', err);
        showError('Failed to copy to clipboard');
    }
}

document.getElementById('urlInput').addEventListener('input', function() {
    document.getElementById('error').style.display = 'none';
});
