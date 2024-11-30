window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'report') {
        console.log("[Backdoor Scanner] Report data received:", data.report);

        if (!data.report) {
            console.error("[Backdoor Scanner] Report data is missing or undefined.");
            document.getElementById('report').innerHTML = "<p>Rapor yüklenemedi. Sunucu ile bağlantıyı kontrol edin.</p>";
            return;
        }

        const reportContainer = document.getElementById('report');
        reportContainer.innerHTML = '';

        const summary = `
            <p><strong>Güvenli Scriptler:</strong> <span class="safe">${data.report.safe}</span></p>
            <p><strong>Şüpheli Scriptler:</strong> <span class="suspicious">${data.report.suspicious}</span></p>
            <p><strong>Zararlı Scriptler:</strong> <span class="malicious">${data.report.malicious}</span></p>
        `;

        const details = Object.entries(data.report.details)
            .map(([script, result]) => `
                <p>
                    <span>${script}: </span>
                    <span class="${result.status}">${result.status}</span>
                    ${result.details.length > 0 ? `<button class="show-details" data-script="${script}">Detayları Göster</button>` : ''}
                </p>
            `)
            .join('');

        reportContainer.innerHTML = `<div>${summary}</div><div>${details}</div>`;
    }
});
