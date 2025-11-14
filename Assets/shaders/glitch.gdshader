shader_type canvas_item;

// Intensidad general del glitch
uniform float glitch_intensity : hint_range(0.0, 10.0) = 3.0;

// Distorsión horizontal por bloques
uniform float block_distort = 80.0;

// Potencia del desplazamiento horizontal
uniform float shake_power = 0.15;

// Probabilidad de que ocurra un glitch por frame
uniform float shake_rate : hint_range(0.0, 1.0) = 0.4;

// Velocidad del parpadeo
uniform float shake_speed = 9.0;

// Separación de color (RGB split)
uniform float color_split = 0.05;  // antes 0.01, ahora 5× más

// Desplazamiento de UV adicional para más caos
uniform float uv_drift = 0.02;

float random(float seed) {
    return fract(623.2543 * sin(dot(vec2(seed, seed), vec2(9525.46, -154.3415))));
}

void fragment() {
    float enable_shift = float(
        random(trunc(TIME * shake_speed)) < shake_rate
    );

    vec2 fixed_uv = UV;

    // Distorsión fuerte por bloques horizontales
    fixed_uv.x += (
        random(
            (trunc(UV.y * block_distort) / block_distort) + TIME
        ) - 0.5
    ) * shake_power * glitch_intensity * enable_shift;

    // Drift adicional para que se mueva en todas direcciones
    fixed_uv += vec2(
        sin(TIME * 2.5 + UV.y * 12.0),
        cos(TIME * 3.5 + UV.x * 10.0)
    ) * uv_drift * enable_shift * glitch_intensity;

    // Sample base
    vec4 col = texture(TEXTURE, fixed_uv);

    // RGB Split fuerte
    float split = color_split * glitch_intensity;

    col.r = mix(col.r,
        texture(TEXTURE, fixed_uv + vec2(split, 0.0)).r,
        enable_shift
    );

    col.g = mix(col.g,
        texture(TEXTURE, fixed_uv + vec2(-split * 0.5, 0.0)).g,
        enable_shift
    );

    col.b = mix(col.b,
        texture(TEXTURE, fixed_uv + vec2(-split, 0.0)).b,
        enable_shift
    );

    COLOR = col;
}
