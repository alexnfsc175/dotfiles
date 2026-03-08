// aurora.glsl — Shader de aurora boreal (Catppuccin Macchiato)
// Efeito de luzes ondulantes no estilo northern lights
// GPU: Leve (~3% em GTX 1060)

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float n = i.x + i.y * 57.0;
    return mix(
        mix(hash(n), hash(n + 1.0), f.x),
        mix(hash(n + 57.0), hash(n + 58.0), f.x),
        f.y
    );
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    float t = iTime * 0.15;

    // Céu escuro (Catppuccin crust)
    vec3 sky = vec3(0.094, 0.095, 0.149);

    // Aurora layers
    float aurora = 0.0;
    for (int i = 0; i < 3; i++) {
        float fi = float(i);
        float wave = sin(uv.x * 3.0 + t * (1.0 + fi * 0.3) + fi * 2.0) * 0.1;
        float band = smoothstep(0.0, 0.15, uv.y - 0.3 - wave - fi * 0.08);
        band *= smoothstep(0.15, 0.0, uv.y - 0.6 - wave - fi * 0.08);
        float n = noise(vec2(uv.x * 4.0 + t * 0.5, uv.y * 2.0 + fi));
        aurora += band * n * (1.0 - fi * 0.2);
    }

    // Cores da aurora — green/teal/mauve do Catppuccin
    vec3 auroraColor1 = vec3(0.545, 0.855, 0.659);  // green
    vec3 auroraColor2 = vec3(0.545, 0.835, 0.792);  // teal
    vec3 auroraColor3 = vec3(0.776, 0.627, 0.965);  // mauve

    vec3 aColor = mix(auroraColor1, auroraColor2, uv.x);
    aColor = mix(aColor, auroraColor3, pow(uv.x, 3.0));

    vec3 color = sky + aColor * aurora * 0.8;

    // Estrelas
    float stars = pow(hash(floor(uv.x * 200.0) + floor(uv.y * 100.0) * 200.0), 20.0);
    stars *= step(0.4, uv.y);
    color += vec3(stars * 0.5);

    // Vignette
    float vig = 1.0 - length(uv - vec2(0.5, 0.4)) * 0.6;
    color *= vig;

    fragColor = vec4(color, 1.0);
}
