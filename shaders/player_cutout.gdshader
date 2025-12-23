shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 player_screen_position;
uniform vec2 player_offset = vec2(0.0, 0.0);
uniform float cutout_radius = 100;
uniform float cutout_softness = 32.0;
uniform float cutout_opacity = 0.5;

void fragment() {
    vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
    if (c.a > 0.0001) {
        c.rgb /= c.a;
    }
    
    // Get the current screen position
    vec2 pixel_pos = FRAGCOORD.xy;
    
    // Calculate distance to player + offset
    float dist = distance(pixel_pos, player_screen_position + player_offset);
    
    // Create gradient cutout mask
    float mask = smoothstep(cutout_radius - cutout_softness, cutout_radius + cutout_softness, dist);
    
    // Apply alpha and lerp between cutout_opacity and 1.0
    c.a *= mix(cutout_opacity, 1.0, mask);
    
    COLOR = c;
}