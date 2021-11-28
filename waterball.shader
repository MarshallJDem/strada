shader_type spatial;
render_mode cull_back, depth_draw_always;

uniform sampler2D noise_tex : hint_black;

uniform vec2 vertex_noise_speed = vec2( 0.1, 0.05 );
uniform float vertex_noise_scale = 1.0;

uniform vec2 wave_noise_speed = vec2( 0.42, 0.23 );
uniform float wave_noise_scale = 0.1;

uniform vec4 water_color : hint_color = vec4( 1.0, 1.0, 1.0, 1.0 );

float random( vec2 pos )
{ 
	return fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453);
}

float value_noise( vec2 pos )
{
	vec2 p = floor( pos );
	vec2 f = fract( pos );

	float v00 = random( p + vec2( 0.0, 0.0 ) );
	float v10 = random( p + vec2( 1.0, 0.0 ) );
	float v01 = random( p + vec2( 0.0, 1.0 ) );
	float v11 = random( p + vec2( 1.0, 1.0 ) );

	vec2 u = f * f * ( 3.0 - 2.0 * f );

	return mix( mix( v00, v10, u.x ), mix( v01, v11, u.x ), u.y );
}

void vertex( )
{
	VERTEX *= 1.0 + texture( noise_tex, UV + vertex_noise_speed * TIME ).r * vertex_noise_scale;
}

void fragment( )
{
	vec2 uv = UV + wave_noise_speed * TIME;
	vec2 screen_uv = SCREEN_UV + ( ( texture( noise_tex, uv ).xy + texture( noise_tex, uv * 6.0 ).xy ) * 0.5 - vec2( 0.5, 0.5 ) ) * wave_noise_scale;

	ALBEDO = texture( SCREEN_TEXTURE, screen_uv ).rgb * water_color.rgb;
	ALPHA = water_color.a;
	NORMALMAP = ( texture( noise_tex, uv ).xyz + texture( noise_tex, uv * 2.0 ).xyz ) * 0.5;
}