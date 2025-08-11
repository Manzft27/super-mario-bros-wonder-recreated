// A Gaussian blur shader for Godot 4.3
shader_type canvas_item;


uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// The radius of the blur effect (number of pixels to blur, NOT USED).
uniform int blur_radius : hint_range(1, 32) = 8;

// Controls the intensity of the blur. (NOT USED)
uniform float blur_strength : hint_range(0.1, 10.0) = 10.0;

// Direction of the fade: 0 = left, 1 = right, 2 = top, 3 = bottom.
uniform int fade_direction : hint_range(0, 3) = 0;

// Sets the cutoff point for the blur fade (0.0 to 1.0).
uniform float fade_cutoff : hint_range(0.0, 1.0) = 0.2;

// Controls the sharpness of the fade transition.
uniform float fade_intensity : hint_range(0.1, 10.0) = 2.0;


// Calculated with with blur_radius of 32 and blur_strength of 10 (16 works nice as well)
const float gaussian_32[32] = float[](
    0.039940,0.039741,0.039149,0.038183,0.036869,0.035247,0.033361,0.031261,
	0.029002,0.026639,0.024225,0.021810,0.019441,0.017157,0.014990,0.012967,
	0.011105,0.009416,0.007904,0.006569,0.005405,0.004403,0.003552,0.002836,
	0.002242,0.001755,0.001360,0.001043,0.000792,0.000596,0.000444,0.000327
);

// Precomputed weights for the Gaussian kernel. (NOT USED)
float gaussian_weight(float i, float sigma) {
    return exp(-0.5 * (i * i) / (sigma * sigma));
}

// Precomputes the weights for the Gaussian kernel.
void calculate_kernel(out float kernel[32], int radius, float sigma) {
    float sum = 0.0;
    for (int i = 0; i <= radius; i++) {
        kernel[i] = gaussian_weight(float(i), sigma);
        sum += i == 0 ? kernel[i] : 2.0 * kernel[i];
    }
    for (int i = 0; i <= radius; i++) {
        kernel[i] /= sum;
    }
}

// Computes the fade factor based on the direction and UV coordinates.
float calculate_fade(vec2 uv) {
    float fade = 0.0;
    if (fade_direction == 0) {
        fade = uv.x; // Left to right
    } else if (fade_direction == 1) {
        fade = 1.0 - uv.x; // Right to left
    } else if (fade_direction == 2) {
        fade = uv.y; // Top to bottom
    } else {
        fade = 1.0 - uv.y; // Bottom to top
    }

    // Normalize fade based on cutoff and intensity.
    if (fade < fade_cutoff) {
        return 1.0; // Full blur
    }

    // Scale fade factor smoothly to 0 at the edge.
    fade = (fade - fade_cutoff) / (1.0 - fade_cutoff);
    return clamp(pow(1.0 - fade*2.0, fade_intensity), 0.0, 1.0);
}




void fragment() {
    vec2 resolution = SCREEN_PIXEL_SIZE;
    vec2 uv = SCREEN_UV;
	
	
	// Calculate the fade factor.
    float fade_factor = calculate_fade(uv);
    // Gaussian kernel weights.
    float kernel[32] ;//= gaussian_32; // remove this varuble and enable the next line
    calculate_kernel(kernel, blur_radius, blur_strength);
	
	 vec4 final_color = vec4(0.0);
	
    // Horizontal blur pass.
    //for (int i = -blur_radius; i <= blur_radius; i++) {
        //final_color += texture(SCREEN_TEXTURE, uv + vec2(0.0, float(i)) * resolution).rgba * kernel[abs(i)];
    //}


    // Vertical blur pass.
    for (int i = -blur_radius; i <= blur_radius; i++) {
        final_color += texture(SCREEN_TEXTURE, uv + vec2(0.0, float(i)) * resolution).rgba * kernel[abs(i)];
    }
	
	
	// One pass blur ... ***VERY BAD PROFORMANCE***
    //for (int x = -blur_radius; x <= blur_radius; x++) {
        //for (int y = -blur_radius; y <= blur_radius; y++) {
            //float weight = kernel[abs(x)] * kernel[abs(y)];
            //vec2 offset = vec2(float(x), float(y)) * resolution;
            //final_color += texture(SCREEN_TEXTURE, uv + offset).rgb * weight;
        //}
    //}

    // Output the blurred color.
	float alpha = fade_factor; // Transparency is tied to the fade factor.
	final_color.a = fade_factor;
	COLOR = final_color;
}