



// Prototype declaration

extern void lcd_puts(char row, char column, const char *s);
//extern void lcd_puts(const char *s);
extern void lcd_putch(char row, char column, char out_char);
//extern void lcd_putch(const char ch);
extern void lcd_decimal(char row, char column, unsigned int num);
extern void lcd_clear();
extern void UpArrow(char pos_row, char pos_char);
extern void DownArrow(char pos_row, char pos_char);
extern void numToLcd(char row, char column, unsigned char num);
// End of prototype declaration