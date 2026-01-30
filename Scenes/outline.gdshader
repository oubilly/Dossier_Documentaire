shader_type canvas_item;

// ---------- Outline 1 (outer or inner, configurable) ----------
uniform float outline1_maxLineWidth: hint_range(0.0, 100.0) = 10.0;
uniform float outline1_minLineWidth: hint_range(0.0, 100.0) = 50.0;
uniform float outline1_blockSize: hint_range(0.001, 100.0) = 80.0;
uniform vec4  outline1_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);

// ---------- Outline 2 (other outline) ----------
uniform float outline2_maxLineWidth: hint_range(0.0, 100.0) = 00.0;
uniform float outline2_minLineWidth: hint_range(0.0, 100.0) = 30.0;
uniform float outline2_blockSize: hint_range(0.001, 100.0) = 80.0;
uniform vec4  outline2_color: source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Shared controls
uniform float speed: hint_range(0.0, 10.0) = 10.0; // how often to recompute the noisy width
uniform float tolerance: hint_range(0.0, 0.999) = 0.95; // alpha tolerance for considering a pixel transparent

// Compensate VERTEX for both outlines' maximum possible widths so the sprite quad is big enough.
void vertex() {
	float max1 = max(outline1_maxLineWidth, outline1_minLineWidth);
	float max2 = max(outline2_maxLineWidth, outline2_minLineWidth);
	float combinedMax = max(max1, max2);
	VERTEX = vec2(
		VERTEX.x * (1.0 + TEXTURE_PIXEL_SIZE.x * combinedMax * 2.0),
		VERTEX.y * (1.0 + TEXTURE_PIXEL_SIZE.y * combinedMax * 2.0)
	);
}

// ---------- Helpers (alpha checks, noise) ----------
bool border(vec2 uv) {
	vec2 uvBorder = abs(uv - vec2(0.5));
	return max(step(0.5, uvBorder.x), step(0.5, uvBorder.y)) > 0.0;
}

float get_alpha(sampler2D tex, vec2 uv){
	float res = 0.0;
	if (!border(uv)) {
		res = texture(tex, uv).a;
	}
	return res;
}

float hash(vec2 p, float s) {
	return fract(35.1 * sin(dot(vec3(112.3, 459.2, 753.2), vec3(p, s))));
}

float noise(vec2 p, float s) {
	vec2 d = vec2(0, 1);
	vec2 b = floor(p);
	vec2 f = fract(p);
	return mix(
		mix(hash(b + d.xx, s), hash(b + d.yx, s), f.x),
		mix(hash(b + d.xy, s), hash(b + d.yy, s), f.x),
		f.y
	);
}

// Randomize line width at fragment but parameterized per-outline.
float get_line_width(vec2 p, float s, float inMin, float inMax, float inBlockSize) {
	p /= inBlockSize;
	float w = 0.0;
	float intensity = 1.0;
	for (int i = 0; i < 3; i++) {
		w = mix(w, noise(p, s), intensity);
		p /= 2.0;
		intensity /= 2.0;
	}
	return mix(inMax, inMin, w);
}

// Checks for neighboring pixels (used to decide if this fragment is within outline range)
float in_range(vec2 size, sampler2D tex, vec2 uv) {
	float res = 0.0;
	for (float i = -1.0; i < 2.0; i += 2.0) {
		res += get_alpha(tex, uv + vec2(i * size.x, 0.0));
		res += get_alpha(tex, uv + vec2(0.0, i * size.y));
		for (float j = -1.0; j < 2.0; j += 2.0) {
			res += get_alpha(tex, uv + vec2(i * size.x, j * size.y));
			res += get_alpha(tex, uv + vec2(i * size.x, j * size.y * 0.5));
		}
	}
	return res;
}

void fragment() {
	vec4 outColor = vec4(0.0);

	// Check if outlines are disabled
	bool outlines_disabled = max(max(outline1_maxLineWidth, outline1_minLineWidth),
	                             max(outline2_maxLineWidth, outline2_minLineWidth)) <= 0.0;

	if (outlines_disabled) {
		outColor = texture(TEXTURE, UV);
	} else {
		// Adjust UV similarly to original so the outline appears around the sprite
		vec2 uv = UV;
		uv -= vec2(0.5);
		float max1 = max(outline1_maxLineWidth, outline1_minLineWidth);
		float max2 = max(outline2_maxLineWidth, outline2_minLineWidth);
		float combinedMax = max(max1, max2);
		vec2 edge = TEXTURE_PIXEL_SIZE * combinedMax * 2.0;
		uv = uv + uv * edge;
		uv += vec2(0.5);

		// Sample the texture at adjusted UV
		vec4 texCol = texture(TEXTURE, uv);

		// If this fragment is inside the sprite (opaque enough) and not on the edge, keep the sprite pixel.
		if (texCol.a > tolerance && !border(uv)) {
			outColor = texCol;
		} else {
			// Compute time step seed for noise; offset slightly per-outline so they don't share identical noise
			float timeStep = floor(TIME * speed);

			// Outline 1
			vec2 size1 = TEXTURE_PIXEL_SIZE;
			size1 *= get_line_width(uv / TEXTURE_PIXEL_SIZE, timeStep + 0.0, outline1_minLineWidth, outline1_maxLineWidth, outline1_blockSize);
			float mask1 = step(1.0 - tolerance, in_range(size1, TEXTURE, uv)); // 1.0 if within the outline1 radius

			// Outline 2
			vec2 size2 = TEXTURE_PIXEL_SIZE;
			size2 *= get_line_width(uv / TEXTURE_PIXEL_SIZE, timeStep + 37.0, outline2_minLineWidth, outline2_maxLineWidth, outline2_blockSize);
			float mask2 = step(1.0 - tolerance, in_range(size2, TEXTURE, uv)); // 1.0 if within the outline2 radius

			// Compose final outline color.
			// Priority: outline2 drawn over outline1 when both apply. If neither applies, remain transparent.
			vec4 finalOutline = vec4(0.0);
			finalOutline = outline1_color * mask1;
			finalOutline = mix(finalOutline, outline2_color * mask2, mask2);

			outColor = finalOutline;
		}
	}

	COLOR = outColor;
}
