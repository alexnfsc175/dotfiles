// waves.glsl — Shader de ondas suaves (Catppuccin Macchiato)
// Efeito de ondas escuras com brilho sutil
// GPU: Muito leve (~1-2% em GTX 1060)

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime * 0.2;

    // Base escura (Catppuccin crust)
    vec3 baseColor = vec3(0.094, 0.095, 0.149);

    // Ondas sobrepostas
    float wave = 0.0;
    for (int i = 0; i < 5; i++) {
        float fi = float(i);
        float freq = 2.0 + fi * 1.5;
        float speed = t * (0.5 + fi * 0.15);
        float amp = 0.02 / (1.0 + fi * 0.5);
        wave += sin(uv.x * freq + speed + fi * 1.3) * amp;
    }

    // Gradiente vertical com ondas
    float y = uv.y + wave;
    float band = smoothstep(0.3, 0.5, y) * smoothstep(0.7, 0.5, y);

    // Brilho — sapphire do Catppuccin
    vec3 glowColor = vec3(0.490, 0.768, 0.894);
    vec3 color = baseColor + glowColor * band * 0.15;

    // Segundo layer de ondas
    float wave2 = 0.0;
    for (int i = 0; i < 3; i++) {
        float fi = float(i);
        wave2 += sin(uv.x * (3.0 + fi) - t * 0.7 + fi * 2.5) * 0.015;
    }
    float band2 = smoothstep(0.35, 0.55, uv.y + wave2) * smoothstep(0.65, 0.45, uv.y + wave2);
    vec3 glowColor2 = vec3(0.541, 0.678, 0.890);  // blue
    color += glowColor2 * band2 * 0.1;

    // Vignette suave
    float vig = 1.0 - length(uv - 0.5) * 0.5;
    color *= vig;

    fragColor = vec4(color, 1.0);
}
