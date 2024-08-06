#define __AVR_ATmega328P__


#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#define BAUD 9600
#define MYUBRR F_CPU/16/BAUD-1

#define PINDIR DDRB
#define LED_PIN PB5 // Pin 13

void USART_Init(unsigned int ubrr) {
    // Set baud rate
    UBRR0H = (unsigned char)(ubrr>>8);
    UBRR0L = (unsigned char) ubrr;

    // Enable transmitter
    UCSR0B = (1<<TXEN0) | (1<<RXEN0);

    // Set frame format: 8 data bits, 1 stop bit
    UCSR0C = (1<<UCSZ01) | (1<<UCSZ00);
}

void USART_Transmit(unsigned char data) {
    // Wait for empty transmit buffer
    while (!(UCSR0A & (1<<UDRE0)));
    // Put data into buffer, sends the data
    UDR0 = data;
}

void USART_SendString(const char *str) {
    while (*str) {
        USART_Transmit(*str++);
    }
}

uint8_t USART_Receive(){
    while(!(UCSR0A & (1 << RXC0)));
    return UDR0;
}

int main(void) {
    // Setting the output mode
    PINDIR = (1 << LED_PIN);

    USART_Init(MYUBRR);
    
    while(1){
        const uint8_t input = USART_Receive();
        // Send the data to serial monitor.
        _delay_ms(500);

        if(input == '1'){
            USART_SendString("RE - 1\n");
            PORTB |= (1 << PB5);
        }
    }
    return 0;
}