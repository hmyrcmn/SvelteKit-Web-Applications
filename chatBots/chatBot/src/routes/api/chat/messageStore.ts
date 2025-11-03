import { writable } from 'svelte/store';
import type { Message } from './types';

function createMessageStore() {
    // LocalStorage'dan mevcut mesajları al
    const storedMessages = typeof window !== 'undefined' 
        ? JSON.parse(localStorage.getItem('chatMessages') || '[]')
        : [];

    const { subscribe, set, update } = writable<Message[]>(storedMessages);

    return {
        subscribe,
        addMessage: (message: Message) => update(messages => {
            const newMessages = [...messages, message];
            // LocalStorage'a kaydet
            if (typeof window !== 'undefined') {
                localStorage.setItem('chatMessages', JSON.stringify(newMessages));
            }
            return newMessages;
        }),
        clearMessages: () => {
            set([]);
            if (typeof window !== 'undefined') {
                localStorage.removeItem('chatMessages');
            }
        }
    };
}

export const messageStore = createMessageStore(); 