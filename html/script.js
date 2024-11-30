// NUI'den gelen mesajları dinle
window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'report') {
        const reportContainer = document.getElementById('report-container');
        reportContainer.style.display = 'block'; // Arayüzü aç

        const report = document.getElementById('report');
        report.innerHTML = ''; // Eski içeriği temizle

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

        report.innerHTML = `<div>${summary}</div><div>${details}</div>`;
    }
});

// Kapama butonunun işlevi
document.getElementById('close-button').addEventListener('click', () => {
    fetch('https://scanner/closeModal', { method: 'POST' })
        .then(() => {
            console.log("Kapatma isteği gönderildi.");
        })
        .catch((err) => {
            console.error("Kapatma tuşunda bir hata oluştu:", err);
        });
});
