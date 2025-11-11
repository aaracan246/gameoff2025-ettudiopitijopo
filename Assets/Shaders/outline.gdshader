shader_type spatial;
render_mode blend_mix, cull_back, unshaded;

uniform vec4 rim_color : source_color = vec4(1.0, 0.8, 0.3, 1.0);
uniform float rim_intensity : hint_range(0.0, 5.0) = 2.0;
uniform float rim_power : hint_range(0.1, 10.0) = 3.0;

void fragment() {
    vec3 view_dir = normalize(-VIEW);
    float rim = 1.0 - max(dot(NORMAL, view_dir), 0.0);
    rim = pow(rim, rim_power) * rim_intensity;

    vec3 final_color = rim_color.rgb * rim;

    // Se usa la salida BUILTIN 'ALBEDO' y 'ALPHA' en lugar de COLOR
    ALBEDO = final_color;
    ALPHA = rim_color.a;
}
