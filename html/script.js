window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'report') {
        const reportContainer = document.getElementById('report-container');
        reportContainer.style.display = 'block';

        const report = document.getElementById('report');
        report.innerHTML = `
            <p><strong>Safe Scripts:</strong> ${data.report.safe}</p>
            <p><strong>Suspicious Scripts:</strong> ${data.report.suspicious}</p>
            <p><strong>Malicious Scripts:</strong> ${data.report.malicious}</p>
        `;
    }
});

document.getElementById('close-button').addEventListener('click', () => {
    document.getElementById('report-container').style.display = 'none';
    fetch('https://scanner/closeModal', { method: 'POST' });
});
