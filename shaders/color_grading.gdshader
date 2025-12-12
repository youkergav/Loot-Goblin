shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float saturation : hint_range(0.0, 2.0) = 1;
uniform float brightness : hint_range(0.0, 2.0) = 1;
uniform float contrast : hint_range(0.0, 2.0) = 1;
uniform vec3 tint_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float tint_strength : hint_range(0.0, 1.0) = 0;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0;
uniform float vignette_radius : hint_range(0.0, 1.0) = 0;

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);

    // Apply adjustment
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    color.rgb = mix(vec3(gray), color.rgb, saturation);

    // Apply tint
    color.rgb = mix(color.rgb, color.rgb * tint_color, tint_strength);

    // Apply brightness
    color.rgb *= brightness;

    // Apply contrast
    color.rgb = ((color.rgb - 0.5) * contrast) + 0.5;

    // Apply vignette
    vec2 center = UV - vec2(0.5);
    float dist = length(center);
    float vignette = smoothstep(vignette_radius, vignette_radius - 0.3, dist);
    color.rgb *= mix(1.0 - vignette_strength, 1.0, vignette);

    // Clamp to valid range
    color.rgb = clamp(color.rgb, 0.0, 1.0);

    COLOR = color;
}
