// plasma.glsl — Shader de plasma animado (Catppuccin Macchiato)
// Efeito de plasma colorido com movimento suave
// GPU: Muito leve (~2% em GTX 1060)

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime * 0.3;

    // Plasma pattern
    float v1 = sin(uv.x * 5.0 + t);
    float v2 = sin(uv.y * 5.0 + t * 1.3);
    float v3 = sin((uv.x + uv.y) * 5.0 + t * 0.7);
    float v4 = sin(length(uv - 0.5) * 8.0 - t * 1.5);

    float v = (v1 + v2 + v3 + v4) * 0.25;

    // Catppuccin Macchiato dark palette
    vec3 col1 = vec3(0.094, 0.095, 0.149);  // crust
    vec3 col2 = vec3(0.180, 0.190, 0.290);  // surface0
    vec3 col3 = vec3(0.490, 0.500, 0.680);  // overlay1
    vec3 col4 = vec3(0.541, 0.678, 0.890);  // blue

    vec3 color = mix(col1, col2, smoothstep(-1.0, -0.3, v));
    color = mix(color, col3, smoothstep(-0.3, 0.3, v));
    color = mix(color, col4, smoothstep(0.3, 1.0, v));

    // Vignette escuro nas bordas
    float vig = 1.0 - length(uv - 0.5) * 0.8;
    color *= vig;

    fragColor = vec4(color, 1.0);
}
