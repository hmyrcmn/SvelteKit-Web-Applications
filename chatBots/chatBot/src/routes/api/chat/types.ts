export interface Message {
    text: string;
    isUser: boolean;
    timestamp: Date;
}

export interface ApiResponse {
    message: string;
    success: boolean;
} 