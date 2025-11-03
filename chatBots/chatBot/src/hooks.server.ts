import type { Handle } from '@sveltejs/kit';
import { sequence } from '@sveltejs/kit/hooks';

export const handle: Handle = sequence(
    async ({ event, resolve }) => {
        const session = event.cookies.get('session');
        
        if (!session) {
            const newSession = crypto.randomUUID();
            event.cookies.set('session', newSession, {
                path: '/',
                httpOnly: true,
                sameSite: 'strict',
                secure: process.env.NODE_ENV === 'production',
                maxAge: 60 * 60 * 24 * 7 // 1 hafta
            });
        }
        
        return resolve(event);
    }
); 