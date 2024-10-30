package com.af.academic_festival.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // WebSocket 연결 엔드포인트 설정
        registry.addEndpoint("/ws")
                .setAllowedOrigins("*")  // 실제 운영환경에서는 구체적인 도메인을 지정하는 것이 좋습니다
                .withSockJS();  // SockJS 지원 추가
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 구독용 prefix 설정
        registry.enableSimpleBroker("/topic");
        // 메시지 발행용 prefix 설정
        registry.setApplicationDestinationPrefixes("/app");
    }
}