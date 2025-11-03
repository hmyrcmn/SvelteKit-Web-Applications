import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { rateLimit } from '$lib/utils/rateLimit';

export const POST: RequestHandler = async ({ request, clientAddress }) => {
    // Güvenlik kontrolleri
    const origin = request.headers.get('origin');
    if (!origin || !['http://localhost:5173', 'https://sizinsite.com'].includes(origin)) {
        return new Response('Unauthorized', { status: 401 });
    }

    try {
        // Rate limiting kontrolü
        const rateLimitResult = await rateLimit(clientAddress);
        if (!rateLimitResult.success) {
            return json(
                { message: 'Çok fazla istek gönderdiniz. Lütfen bekleyin.', success: false },
                { status: 429 }
            );
        }

        const { message } = await request.json();
        
        // Burada chatbot API entegrasyonu yapılacak
        const response = {
            message: "Bu bir test yanıtıdır. API entegrasyonu henüz yapılmadı.",
            timestamp: new Date().toISOString()
        };

        return json(response);
    } catch (error) {
        return json({ error: 'Internal Server Error' }, { status: 500 });
    }
}; 