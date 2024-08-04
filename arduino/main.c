#define __AVR_ATmega328P__


#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#define BAUD 9600
#define MYUBRR F_CPU/16/BAUD-1

void USART_Init(unsigned int ubrr) {
    // Set baud rate
    UBRR0H = (unsigned char)(ubrr>>8);
    UBRR0L = (unsigned char) ubrr;

    // Enable transmitter
    UCSR0B = (1<<TXEN0);

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

void USART_ReceiveString(){

}

int main(void) {
    USART_Init(MYUBRR);
    USART_SendString("Hello, Computer!\r\n");
    
    // while (1) {
    //     _delay_ms(1000); // Delay for 1 second
    // }
    
    return 0;
}