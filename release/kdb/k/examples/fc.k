/ copyright(c) 1998 kx systems

\d fc		fahrenheit-centigrade

Centigrade: 0.0

Fahrenheit..d: "32 + 1.8 * Centigrade"

Fahrenheit..t: "Centigrade:(Fahrenheit - 32) % 1.8"

\d ^

`show$`fc