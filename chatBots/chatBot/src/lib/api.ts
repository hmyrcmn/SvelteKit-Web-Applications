export async function sendMessageToBot(message: string) {
    try {
        const response = await fetch('/api/chat', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ message }),
        });

        if (!response.ok) {
            throw new Error('API yanıtı başarısız');
        }

        return await response.json();
    } catch (error) {
        console.error('API hatası:', error);
        throw error;
    }
} 