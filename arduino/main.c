#define __AVR_ATmega328P__

#include <avr/io.h>
#include <util/delay.h>

#define BAUD 9600
#define MYUBRR F_CPU / 16 / BAUD - 1

// MOTOR LATCH BITS
#define MOTOR1_A 2
#define MOTOR1_B 3
#define MOTOR2_A 1
#define MOTOR2_B 4

// Defining Data Direction Registers
#define PORTB_DIR DDRB
#define PORTD_DIR DDRD

// Arduino pin names to interface with 74HCT595 shift register
#define MOTORLATCH PB4
#define MOTORDATA PB0
#define MOTORENABLE PD7
// Used to provide clock signal to shift data into the shift register.
#define MOTORCLK PD4

int isTimerInitialised = 0;

void INIT_USART(unsigned int ubrr)
{
    // Set baud rate
    UBRR0H = (unsigned char)(ubrr >> 8);
    UBRR0L = (unsigned char)ubrr;

    // Enable transmitter
    UCSR0B = (1 << TXEN0) | (1 << RXEN0);

    // Set frame format: 8 data bits, 1 stop bit
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

void USART_TRANSMIT(unsigned char data)
{
    // Wait for empty transmit buffer
    while (!(UCSR0A & (1 << UDRE0)))
        ;
    // Put data into buffer, sends the data
    UDR0 = data;
}

void USART_SEND_STRING(const char *str)
{
    while (*str)
    {
        USART_TRANSMIT(*str++);
    }
}

uint8_t USART_RECEIVE()
{
    while (!(UCSR0A & (1 << RXC0)))
        ;
    return UDR0;
}

static uint8_t shift_latch;

// Initialize Timer2 for Fast PWM mode
void INIT_PWM()
{
    if(isTimerInitialised != 0){
        return;
        USART_SEND_STRING("PWM ALREADY ENABLED\n");
    }
    isTimerInitialised = 1;
    USART_SEND_STRING("ENABLE PWM\n");

    // Set fast PWM mode, turn on OC2A and OC2B
    TCCR2A |= _BV(COM2A1) | _BV(COM2B1) | _BV(WGM20) | _BV(WGM21);
    TCCR2B = 1;  // No prescaler

    // Output compare register for Counter/Timer2
    OCR2A = 0;  // Low duty cycle for motor 1 (PB3 | PIN 11)
    OCR2B = 0;  // Low duty cycle for motor 2 (PD3 | PIN 3)

    // Set PIN 11 and PIN 3 as output
    PORTB_DIR |= (1 << PB3);
    PORTD_DIR |= (1 << PD3);

    USART_SEND_STRING("ENABLE PWM - END\n");
}

// Set the values to the shift register
void SETUP_LATCH()
{
    USART_SEND_STRING("SET LATCH\n");
    uint8_t i;

    // Initialize MOTORLATCH and MOTORDATA to LOW
    PORTB &= ~(1 << MOTORLATCH);
    PORTB &= ~(1 << MOTORDATA);

    for (i = 0; i < 8; i++)
    {
        // Clear MOTORCLK (Set it LOW)
        PORTD &= ~(1 << MOTORCLK);

        // Set or clear MOTORDATA based on the current bit in shift_latch
        if (shift_latch & _BV(7 - i))
        {
            PORTB |= (1 << MOTORDATA); // Set MOTORDATA HIGH
        }
        else
        {
            PORTB &= ~(1 << MOTORDATA); // Set MOTORDATA LOW
        }

        // Set MOTORCLK HIGH (pulse clock)
        PORTD |= (1 << MOTORCLK);
        _delay_us(1);
        PORTD &= ~(1 << MOTORCLK);
    }

    // Latch the data by pulsing MOTORLATCH
    PORTB |= (1 << MOTORLATCH);

    USART_SEND_STRING("SET LATCH - END\n");
    shift_latch = 0;
}

// Set the duty cycle for Timer2
void SET_MOTOR_SPEED(uint8_t speed)
{
    OCR2A |= speed;
    OCR2B |= speed;
    _delay_ms(1);
    USART_SEND_STRING("SETTING SPEED - END\n");
}

void ENABLE_MOTORS()
{
    USART_SEND_STRING("ENABLE MOTOR - Start\n");

    PORTB_DIR |= (1 << MOTORLATCH) | (1 << MOTORDATA);
    USART_SEND_STRING("Configured PORTB_DIR\n");

    PORTD_DIR |= (1 << MOTORENABLE) | (1 << MOTORCLK);
    USART_SEND_STRING("Configured PORTD_DIR\n");

    shift_latch = 0;
    SETUP_LATCH();
    USART_SEND_STRING("Latch Setup Complete\n");

    PORTD &= ~(1 << MOTORENABLE);
    USART_SEND_STRING("ENABLE MOTOR - END\n");
}

void RUN_MOTOR(uint8_t motornum)
{
    shift_latch = 0;

    USART_SEND_STRING("START MOTOR\n");
    uint8_t a, b;
    switch (motornum){
    case 1:
        a = MOTOR1_A; b = MOTOR1_B; break;
    case 2:
        a = MOTOR2_A; b = MOTOR2_B; break;
    default:
        return;
    }

    // We only need to run forward.
    shift_latch |= _BV(a);
    shift_latch &= ~_BV(b);
    SETUP_LATCH();

    USART_SEND_STRING("START MOTOR - END\n");
}

void STOP_MOTOR(uint8_t motornum)
{
    USART_SEND_STRING("STOP MOTOR\n");

    shift_latch = 0;

    uint8_t a, b;
    switch (motornum){
    case 1:
        a = MOTOR1_A; b = MOTOR1_B; break;
    case 2:
        a = MOTOR2_A; b = MOTOR2_B; break;
    default:
        return;
    }

    // Stop the motor.
    shift_latch &= ~(1 << a);
    shift_latch &= ~(1 << b);
    SETUP_LATCH();

    USART_SEND_STRING("STOP MOTOR - END\n");
}

int main(void)
{

    // Initialising USART Communication
    INIT_USART(MYUBRR);

    // Initialise Timer for Motor PWM
    INIT_PWM();

    _delay_ms(1);

    // Enable Motors
    ENABLE_MOTORS();

    while (1)
    {
        // Wait for the input
        const uint8_t input = USART_RECEIVE();

        _delay_ms(500);

        if (input == '1')
        {
            USART_SEND_STRING("START MOTOR\n");
            // Start Motor 1
            USART_SEND_STRING("SETTING SPEED - 255\n");
            SET_MOTOR_SPEED(255);
            _delay_ms(100);
            RUN_MOTOR(1);
        }

        if (input == '2')
        {
            USART_SEND_STRING("STOP MOTOR\n");
            // Stop Motor 1
            USART_SEND_STRING("SETTING SPEED - 0\n");
            SET_MOTOR_SPEED(0);
            _delay_ms(100);
            STOP_MOTOR(1);
        }
    }
    return 0;
}